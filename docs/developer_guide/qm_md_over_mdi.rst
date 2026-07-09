.. _dev-qm-md-over-mdi:

***********************************
QM-MD over MDI (the LAMMPS driver)
***********************************

This page explains, at the code level, how SEAMM drives LAMMPS molecular
dynamics with energies and forces computed by a quantum-mechanical engine
(currently MOPAC or xTB) over the `MDI protocol`_. It is aimed at developers who need
to maintain this path or add a new QM engine to it. For the *user's* view --
how to build a flowchart that uses it -- see :ref:`user-qm-md-with-mdi`.

.. _MDI protocol: https://molssi-mdi.github.io/MDI_Library/

.. contents:: Contents
   :depth: 2
   :local:


The big picture
===============

The feature is split between three steps that talk to each other through one
workspace variable and one small classmethod contract:

.. list-table::
   :header-rows: 1
   :widths: 20 25 55

   * - Role
     - Step / package
     - Responsibility
   * - **Producer**
     - Model Chemistry (``model_chemistry_step``)
     - Discover the model chemistries the installed program plug-ins offer,
       let the user pick one, and publish the choice as the ``_model_chemistry``
       workspace variable.
   * - **Engine owner**
     - a program step (``mopac_step``)
     - Advertise which of its levels of theory are MDI-capable, and hand back a
       ready-to-run command that launches its MDI *engine* in the correct
       environment.
   * - **Consumer / driver**
     - LAMMPS (``lammps_step``)
     - Read ``_model_chemistry``, launch the engine, run ``lmp`` as the MDI
       *driver*, and rendezvous with the engine over TCP.

The design rule that keeps this clean: **the driver owns the rendezvous; the
engine owner owns its launch line.** ``lammps_step`` chooses the transport
(TCP), allocates the port, and sets the hostname -- because it must give the
*same* values to both sides -- while ``mopac_step`` returns an argv that knows
the conda environment, the engine script, and the method/charge/multiplicity
flags. No MOPAC-specific knowledge leaks into ``lammps_step``.


Why TCP, and the three-environment split
=========================================

SEAMM installs each external code in its own conda environment. A QM-MD run
therefore spans **three** environments:

* **seamm** -- where SEAMM itself (and these plug-ins) run.
* **seamm-lammps** -- the ``lmp`` binary, built with the MDI package so that
  ``fix mdi/qm`` exists.
* **seamm-mopac** -- MOPAC and the engine's imports (``mopactools``,
  ``pymdi``/``mdi``, ``numpy``, ``seamm_util``).

``lammps_step`` already drives *ML* force fields over MDI, but via **MPI**: a
single ``mpirun ... : ...`` MPMD launch with the engine and driver both in
``seamm-lammps`` (the ``gpu-code`` template in ``data/lammps.ini``). MOPAC
cannot share one MPI world with ``lmp`` -- it lives in a different environment --
so the QM path uses **MDI-over-TCP** instead, which decouples the two
environments. They converge only on the input deck (``fix mdi/qm``, no
``pair_style``).

.. important::

   These are *two distinct launch paths*. The MACE/ML path is MDI-over-MPI with
   both ranks hardwired in the ``lammps.ini`` MPMD line. The QM path is
   MDI-over-TCP with a generated bash script. When editing ``lammps.ini``, the
   ``code`` key **must** be a plain LAMMPS launcher (e.g.
   ``mpirun -np {NTASKS} lmp``); the MACE MPMD line belongs only in ``gpu-code``.
   Putting the MACE line in ``code`` gives the QM launch script a second engine
   and a conflicting ``-mdi`` flag.


The contract: ``_model_chemistry``
===================================

The Model Chemistry step publishes its selection with
``self.set_variable("_model_chemistry", wrapper)``
(``seamm.Node.set_variable``, backed by ``seamm.flowchart_variables`` -- the
same mechanism the Forcefield step uses for ``_forcefield``). The wrapper is::

    {
        "level":  "MOPAC:SQM@PM6-ORG",   # canonical [owner:]type@method string
        "owner":  "MOPAC",
        "type":   "SQM",
        "method": "PM6-ORG",
        "basis":  None,
        "cutoff": None,
        "step":   "<stevedore plugin name>",   # resolution handle for the owner
        "options": { ... full get_model_chemistry_options() entry ... },
    }

* ``level`` (and its parsed components) come from
  ``model_chemistry_step.grammar.parse_level`` -- the grammar
  ``[owner:]type@method[/basis[@cutoff]]`` lives in ``grammar.py`` so producer
  and consumers share one definition.
* ``step`` is the owning plug-in's Stevedore *name*, captured at discovery. The
  consumer uses it to resolve the owner without mapping the ``owner:`` token
  back to an entry point.
* ``options`` is the program step's full option entry (see below), carried
  verbatim so the consumer needs nothing else from the owner except the launch
  command.

.. note::

   The consumer reads ``mc["options"]["mdi_capable"]`` /
   ``mc["options"]["periodic_mdi"]`` to gate the launch, ``mc["method"]`` for
   the engine, and ``mc["step"]`` to resolve the owner. Charge and multiplicity
   are **not** in this contract -- they come from the configuration object, per
   SEAMM convention.


The producer: Model Chemistry step
===================================

``model_chemistry_step/model_chemistry.py``:

* ``model_chemistries(periodic_only=False, mdi_only=False)`` -- iterates the
  ``org.molssi.seamm`` Stevedore namespace and calls
  ``get_model_chemistry_options()`` on every plug-in helper that defines it,
  returning the union keyed by canonical level string. Each value is built into
  the ``_model_chemistry`` wrapper shown above (``parse_level`` + the captured
  Stevedore ``ext.name`` as ``step``). A level offered by two plug-ins logs a
  warning and keeps the first.
* ``run()`` -- reads the ``model_chemistry`` parameter (and the ``periodic``
  toggle, which passes ``periodic_only`` into discovery), validates the
  selection against what is actually available (raising a helpful error
  otherwise), then publishes ``_model_chemistry``.

The step is a pure aggregator: it does not know about MDI or MOPAC. All
program-specific knowledge lives behind ``get_model_chemistry_options()``.


The engine owner: a program step
=================================

A program step opts in to being a model-chemistry provider by defining three
classmethods on its helper class (``MOPACStep`` in
``mopac_step/mopac_step.py``). They are classmethods so they are reachable via
Stevedore with no node instance.

``get_model_chemistry_options(periodic_only=False, mdi_only=False)``
--------------------------------------------------------------------

Returns a dict keyed by bare method name; each value is the ``options`` block
that ends up in the contract. The MDI-relevant keys::

    "model_chemistry": "MOPAC:SQM@PM6-ORG",   # the level string
    "type":            "SQM",
    "mdi_capable":     True,                   # launchable via the MDI engine
    "periodic_mdi":    True,                   # validated periodic via MDI
    "mdi_method_arg":  "PM6-ORG",              # the engine's --method value
    "elements": ..., "description": ..., ...

``mdi_capable`` / ``periodic_mdi`` are computed from two module-level sets::

    _MDI_CAPABLE_METHODS    = {"PM7", "PM6-D3H4", "PM6-ORG", "PM6", "AM1", "RM1"}
    _MDI_PERIODIC_VALIDATED = {"PM7", "PM6-ORG", "PM6"}

These are deliberately *conservative*: a method is in ``_MDI_PERIODIC_VALIDATED``
only if it has actually been run periodic and validated.

``get_executor_config(executor, seamm_options)``
-------------------------------------------------

Reads the per-plug-in ``mopac.ini`` for the *current* executor (the same way
``MOPAC.run()`` does), so the engine runs in the same environment as ordinary
MOPAC jobs. Returns that ini section plus ``version`` and ``mdi_script`` (the
absolute path to the bundled engine).

``get_mdi_engine_command(executor, seamm_options, *, method, port, hostname="localhost", charge=0, multiplicity=1, n_atoms=None, engine_name="MOPAC", extra_args=None)``
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Builds the engine launch argv::

    [conda, run, --live-stream, -n, <seamm-mopac>,
     python, <abs path to mopac_mdi.py>,
     -mdi, "-role ENGINE -name MOPAC -method TCP -port <port> -hostname <host>",
     --method <method>, --charge <q>, --multiplicity <m>, <extra_args...>]

* ``method`` is validated against ``_MDI_CAPABLE_METHODS``.
* Returns a *list*; the caller renders it with ``shlex.join()`` so the ``-mdi``
  value is one correctly-quoted token.
* Non-conda installs raise ``NotImplementedError`` -- flagged honestly rather
  than mis-launched (local/modules/docker is future work).

The engine script (Option C)
-----------------------------

``mopac_mdi.py`` is shipped **inside the package** at
``mopac_step/data/mopac_mdi.py`` and located via
``importlib.resources.files("mopac_step") / "data" / "mopac_mdi.py"``.

.. note::

   The script physically lives in **seamm**'s site-packages but *runs under
   seamm-mopac's Python* -- a script's location does not determine its imports,
   the interpreter does. So ``mopac_mdi.py`` **must** import only packages
   present in seamm-mopac and **nothing** from ``mopac_step`` or ``seamm``. It
   is shipped in ``data/`` (not as an importable module) on purpose, to remove
   the temptation to add a ``from . import ...`` that would pass tests under
   seamm but fail at run time under seamm-mopac.

   Riding in the wheel means ``pip install -U mopac-step`` refreshes the engine
   automatically -- no dependence on the user re-running the environment
   installer.

A guard test (``mopac_step/tests/test_mdi_methods.py``) parses the engine's
``--method`` ``choices`` out of ``mopac_mdi.py`` with :mod:`ast` (no import, since
it is not a module) and asserts they equal ``_MDI_CAPABLE_METHODS``, keeping the
two files in lock-step.


The consumer: LAMMPS step
=========================

Detection -- ``lammps.py``, ``ff_form()``
-----------------------------------------

The QM path reuses the existing forcefield-form dispatch. ``ff_form()`` checks
``_model_chemistry`` **first** (a QM-MD flowchart has no Forcefield step, so
``_forcefield`` would not exist) and returns the sentinel ``"MDI/QM"``:

.. code-block:: python

   def ff_form(self):
       if self.variable_exists("_model_chemistry"):
           return "MDI/QM"
       ff = self.get_variable("_forcefield")
       ...

This is the Phase C consumer-precedence rule: **prefer ``_model_chemistry``,
fall back to ``_forcefield``.**

The input deck -- ``initialization.py``, ``MDI_QM_input()``
-----------------------------------------------------------

``Initialization.run()`` dispatches on ``ff_form()``; ``"MDI/QM"`` routes to
``MDI_QM_input()``. It writes the same generic deck the MACE path uses -- units
``metal``, ``atom_style atomic``, a small ``comm_modify cutoff 2.0`` (there is no
``pair_style`` to size the communication shell from, so this prevents
"atoms may get lost" warnings), and the transport-agnostic driver fix::

    fix    mdi_fix all mdi/qm elements <type1> <type2> ...            # molecular
    fix    mdi_fix all mdi/qm virial yes elements <type1> ...         # periodic

No ``pair_style`` -- ``fix mdi/qm`` ships the atoms to the engine and receives
the forces back.

The launch -- ``lammps.py``, ``_execute_single_sim``
----------------------------------------------------

When ``ff_form == "MDI/QM"`` (around ``lammps.py:1309``):

.. code-block:: python

   _, configuration = self.get_system_configuration()
   engine_argv, port = self._mdi_engine_launch(configuration)
   files["mdi_launch.sh"] = _mdi_launch_script(engine_argv, port, config, ce)
   cmd = ["bash", "mdi_launch.sh"]

* ``_mdi_engine_launch(configuration)`` -- reads ``_model_chemistry``, validates
  ``options["mdi_capable"]`` (and ``options["periodic_mdi"]`` for periodic
  systems), picks a free port with ``_free_tcp_port()``, resolves the owner with
  ``self.flowchart.plugin_manager.get(mc["step"])``, and calls its
  ``get_mdi_engine_command(...)`` -- passing ``charge=configuration.charge`` and
  ``multiplicity=configuration.spin_multiplicity`` (the SEAMM convention; LAMMPS
  ``fix mdi/qm`` does not send ``>TOTCHARGE`` / ``>ELEC_MULT``, so the engine CLI
  values are authoritative). Returns ``(engine_argv, port)``.
* ``_mdi_launch_script(engine_argv, port, config, ce)`` -- composes the bash
  script. The **engine is the listener** (it binds the port and blocks in
  ``MDI_Accept_Communicator``), so it is backgrounded *first*; the LAMMPS driver
  runs second and connects::

      #!/bin/bash
      set -e
      <engine argv via shlex.join> &        # carries its own conda run -n seamm-mopac
      ENGINE_PID=$!
      <driver from config["code"]> -mdi "-role DRIVER -name LAMMPS -method TCP -port <PORT> -hostname localhost" -in input.dat
      wait $ENGINE_PID

  The driver half is built from the ``lammps.ini`` ``code`` key (ini templates
  like ``{NTASKS}`` resolved as ``executor.run`` would). ``executor.run`` wraps
  the whole script in seamm-lammps; the engine line nests its own
  ``conda run -n seamm-mopac``, so each code stays in its own environment.

The driver runs ``-np 1`` by design -- the work is in the engine.

Port allocation and the race
----------------------------

``_free_tcp_port()`` binds a throwaway socket to port 0, reads back the OS-assigned
port, releases it, and returns the integer for *both* sides::

   def _free_tcp_port(hostname="localhost"):
       s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
       try:
           s.bind((hostname, 0))
           return s.getsockname()[1]
       finally:
           s.close()

.. warning::

   There is an unavoidable TOCTOU gap between releasing the socket and the
   engine re-binding the port. Fine for one job per node. Under heavy
   concurrency the robust fix is an engine-bind-failure retry (pick a new port
   and relaunch); a cheaper partial fix is to seed the candidate from the SEAMM
   job id so independent jobs rarely collide. MDI's TCP transport requires the
   *same explicit* ``-port`` on both sides (no port-0 negotiation), which is why
   the port must be pre-picked here.


End-to-end sequence
===================

::

   Model Chemistry.run()
     └─ set_variable("_model_chemistry", {... "MOPAC:SQM@PM6-ORG" ...})

   LAMMPS._execute_single_sim()
     ├─ ff_form() ──────────────────► "MDI/QM"
     ├─ Initialization.MDI_QM_input() ─► input.dat:  fix mdi/qm ... (no pair_style)
     ├─ _mdi_engine_launch(config)
     │    ├─ validate options["mdi_capable"] / ["periodic_mdi"]
     │    ├─ port = _free_tcp_port()
     │    ├─ step = plugin_manager.get(mc["step"])      # -> MOPACStep
     │    └─ step.get_mdi_engine_command(method=PM6-ORG, port, charge, mult) ─► engine argv
     ├─ _mdi_launch_script(...) ─► mdi_launch.sh
     └─ executor.run(["bash", "mdi_launch.sh"])  (in seamm-lammps)
          ├─ engine (seamm-mopac) binds port, MDI_Accept_Communicator …blocks
          ├─ lmp DRIVER connects over TCP; per MD step: send atoms ► / receive E,F ◄
          └─ LAMMPS sends EXIT; engine returns; wait $ENGINE_PID


A second engine: xTB
====================

``xtb_step`` is the second engine wired into this path, and it is the proof
that the contract is genuinely engine-agnostic: it implements the *same three
classmethods* as ``MOPACStep`` (``get_model_chemistry_options``,
``get_executor_config``, ``get_mdi_engine_command``), and **nothing** in
``model_chemistry_step`` or ``lammps_step`` knows it exists -- it is discovered
and driven exactly like MOPAC.

The differences are all internal to ``xtb_step``:

.. list-table::
   :header-rows: 1
   :widths: 30 35 35

   * -
     - MOPAC (``mopac_step``)
     - xTB (``xtb_step``)
   * - Environment / ini
     - ``seamm-mopac`` / ``mopac.ini``
     - ``seamm-xtb`` / ``xtb.ini``
   * - Engine script (Option C)
     - ``data/mopac_mdi.py``
     - ``data/tblite_mdi.py`` (built on `tblite`_)
   * - Engine imports
     - ``mopactools``, ``mdi``, ``numpy``, ``seamm_util``
     - ``tblite``, ``mdi``, ``numpy``
   * - MDI ``-name`` (``engine_name``)
     - ``MOPAC``
     - ``TBLITE``
   * - Level specs
     - ``MOPAC:SQM@<method>``
     - ``xTB:SQM@<method>``
   * - ``_MDI_CAPABLE_METHODS``
     - PM7, PM6-D3H4, PM6-ORG, PM6, AM1, RM1
     - GFN1-xTB, GFN2-xTB
   * - ``_MDI_PERIODIC_VALIDATED``
     - PM7, PM6-ORG, PM6
     - GFN1-xTB, GFN2-xTB
   * - Open-shell handling
     - ``--multiplicity`` (2S+1)
     - ``--uhf`` = ``multiplicity - 1`` (tblite counts *unpaired electrons*)
   * - ``n_atoms``
     - ignored (MOPAC is single-threaded)
     - used to size the engine's OpenMP/MKL threads from the ``[xtb-step]``
       section of ``seamm.ini``

.. _tblite: https://tblite.readthedocs.io/

Two points worth keeping straight when maintaining xTB:

* **The engine is tblite, not the ``xtb`` CLI.** ``tblite_mdi.py`` links the
  tblite library directly and needs no input file -- atom count, atomic
  numbers, coordinates, and (for periodic systems) the cell all arrive over the
  MDI handshake from LAMMPS, the same as the MOPAC engine. ``xtb.ini``'s
  ``code`` key (the ``xtb`` binary) is only for ordinary file-based xTB jobs;
  the MDI path uses ``mdi_script`` instead.
* **Charge/spin translation lives in the engine command.**
  ``get_mdi_engine_command`` converts SEAMM's 2S+1 multiplicity to tblite's
  unpaired-electron count (``--uhf``). The driver still passes
  ``charge=configuration.charge`` / ``multiplicity=configuration.spin_multiplicity``
  unchanged -- the convention is identical to MOPAC; only the engine-side flag
  differs.

A matching method-set guard test
(``xtb_step/tests/...``) keeps ``_MDI_CAPABLE_METHODS`` and the engine's
``--method`` choices in lock-step, exactly as MOPAC's does.


Adding a new QM engine
======================

To make another program step drivable this way (MOPAC and xTB are the two that
exist today), implement on its helper class the same three classmethods:

#. ``get_model_chemistry_options(periodic_only, mdi_only)`` returning entries
   with ``model_chemistry`` (the level string), ``mdi_capable``, ``periodic_mdi``,
   and ``mdi_method_arg``.
#. ``get_executor_config(executor, seamm_options)`` returning the ini section
   plus ``mdi_script``.
#. ``get_mdi_engine_command(executor, seamm_options, *, method, port, ...)``
   returning the engine argv.

Ship the engine script in ``<pkg>/data/`` (Option C) so it imports only packages
present in that code's environment, and add the method-set guard test. Nothing
in ``model_chemistry_step`` or ``lammps_step`` should need to change -- discovery
and the launch path are engine-agnostic.


Status and limitations
=======================

* **Verified end-to-end (2026-06-24):** MOPAC PM6-ORG drove a 45-atom
  conjugate-gradient minimization via MDI (engine in seamm-mopac over TCP, clean
  exit). The launch path is proven.
* **xTB engine implemented:** ``xtb_step`` provides the same three-classmethod
  contract (tblite engine, GFN1-xTB / GFN2-xTB) and is discovered and driven
  with no changes to ``model_chemistry_step`` or ``lammps_step``. Confirm the
  ``_MDI_PERIODIC_VALIDATED`` set against an actual periodic end-to-end run
  before relying on periodic xTB.
* Periodic systems beyond ``_MDI_PERIODIC_VALIDATED``, non-conda launches, and
  the concurrent-job port retry are open follow-ups.
* Phase D (folding the Forcefield step into ``_model_chemistry`` so the consumer
  branches on a single ``mdi_capable`` flag for QM / classical / ML / OpenKIM) is
  a design sketch, not yet built.


Campaign notes
==============

The blow-by-blow design record lives in the dated campaign notes (the contract
was named ``model_chemistry`` in early notes and is now ``level`` in code --
trust the code):

* :doc:`Phase A -- MOPAC engine contract <campaigns/2026-06-22/NOTES_A>`
* :doc:`Phase B -- Model Chemistry step <campaigns/2026-06-22/NOTES_B>`
* :doc:`Phase C -- LAMMPS consumption <campaigns/2026-06-22/NOTES_C>`
* :doc:`Phase D (sketch) -- folding in the Forcefield step <campaigns/2026-06-22/NOTES_D>`


References
==========

* MDI Library (TCP transport, roles): https://molssi-mdi.github.io/MDI_Library/
* LAMMPS ``fix mdi/qm``: https://docs.lammps.org/fix_mdi_qm.html
* LAMMPS MDI HOWTO: https://docs.lammps.org/Howto_mdi.html
