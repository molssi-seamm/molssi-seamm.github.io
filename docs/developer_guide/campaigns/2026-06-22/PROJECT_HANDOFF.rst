.. _handoff-mdi-campaign:

==================================================================
Project handoff -- LAMMPS + MOPAC QM-MD coupling via MDI
==================================================================

:Author: Paul Saxe (notes assembled with Claude)
:Date: 2026-06-23
:Audience: A developer (or Claude Code) taking over this work cold
:Campaign: LAMMPS + MOPAC/xTB QM-MD via the MolSSI Driver Interface (MDI)

.. contents:: Contents
   :depth: 2
   :local:


1. What this project is
=======================

SEAMM (Simulation Environment for Atomistic and Molecular Modeling) is a
plugin-based workflow framework. A *flowchart* is a sequence of *steps*; each
step is a separate Python package (a plug-in) discovered at runtime via
Stevedore entry points in the namespace ``org.molssi.seamm``.

**Goal of this campaign:** run molecular dynamics in LAMMPS where the forces
come from a quantum/semiempirical engine (MOPAC first, xTB later) instead of a
classical force field, by coupling the two codes over the **MDI** protocol
(https://molssi-mdi.github.io/MDI_Library/) using its **TCP** transport. LAMMPS
is the MDI *driver*; MOPAC is the MDI *engine*.

**The "thin line"** we are driving to first: a flowchart that selects
``MOPAC:SQM@PM6-ORG`` as the model chemistry, builds a periodic liquid, and runs
NVT/NPT MD in LAMMPS with MOPAC providing the forces via MDI. xTB and full
generality come after that works end to end.

Three pieces are involved, each its own package:

* ``mopac_step``         -- the MOPAC plug-in; provides the MDI engine and the
  launch contract (**Phase A, done, released**).
* ``model_chemistry_step`` -- a new plug-in: the user picks a model chemistry,
  it is stored as a workspace variable for downstream steps (**Phase B, in
  progress**).
* ``lammps_step``        -- consumes the model chemistry and orchestrates the
  MDI run (**Phase C, not started**).

Shared CI lives in ``molssi-seamm/devops`` (reusable GitHub Actions workflows
called by every plug-in).


2. Working conventions (please honor these)
===========================================

* **Files for the project are reStructuredText (.rst), not Markdown.**
* **Phase-named notes:** ``NOTES_A.rst``, ``NOTES_B.rst``, ... one per phase.
* **Diffable changes:** make surgical patches, preserve existing formatting,
  indentation, and comments so changes diff cleanly against the original.
* **Do not guess.** If something is uncertain, say so and flag it; prefer
  empirical verification (dry runs, tests) over assertion. Uploaded files /
  actual code are ground truth over assumptions.
* **Option C for shipped scripts:** engine scripts live *inside* the package at
  ``<pkg>/data/`` and are located via ``importlib.resources.files(...)``. This
  refreshes on ``pip install -U`` without the user re-running any installer.
* Use ``importlib.resources`` (not ``pkg_resources``).
* **Charge and spin multiplicity come from the configuration object**, never
  from step parameters (SEAMM convention).
* Reference plug-ins to copy patterns from: ``mopac_step``,
  ``read_structure_step``, ``strain_step``, ``gaussian_step``, ``psi4_step``.


3. Key SEAMM mechanics (verified in source)
===========================================

**Plug-in discovery.** ``seamm.PluginManager(namespace="org.molssi.seamm")``
wraps ``stevedore.ExtensionManager``. Each entry-point object is the step's
*helper class* (e.g. ``MOPACStep``), which has ``description()``,
``create_node()``, ``create_tk_node()``. A flowchart exposes
``self.flowchart.plugin_manager``; ``self.flowchart.plugin_manager.manager[name].obj``
is the (instantiated) helper for plug-in ``name``.

**Workspace variables.** ``seamm.Node`` provides ``set_variable(name, value)``,
``get_variable(name)``, ``variable_exists(name)``, backed by
``seamm.flowchart_variables``. This is how steps share state -- e.g. the
Forcefield step sets ``_forcefield`` and LAMMPS reads it. We reuse this exact
mechanism for ``_model_chemistry``. The structure/system is reached via
``self.get_variable("_system_db")``.

**Simple-step run() boilerplate** (from psi4/gaussian/vasp)::

    def run(self):
        next_node = super().run(printer)
        printer.important(self.header)
        printer.important("")
        # P = self.parameters.current_values_to_dict(...)
        # ... work, set variables, cite references ...
        return next_node


4. Phase A -- MOPAC MDI engine launch contract (DONE, released)
===============================================================

All of this is shipped in the released ``mopac_step`` and documented in
``NOTES_A.rst``.

**The engine script:** ``mopac_step/data/mopac_mdi.py`` (Option C). It imports
**only** packages present in the ``seamm-mopac`` conda environment
(``numpy``, ``seamm_util``, ``mdi`` [conda pkg ``pymdi``], ``mopactools.api``)
and nothing from ``mopac_step`` or ``seamm`` -- so it runs correctly under the
``seamm-mopac`` Python even though the file physically lives in the ``seamm``
environment's site-packages. CLI::

    python mopac_mdi.py -mdi "<MDI init string>" \
        --method <NAME> --charge <q> --multiplicity <m> [other flags]

It uses ``MDI_Accept_Communicator`` (engine acts as the TCP listener; confirm
the handshake direction against MDI if it matters, but see launch-order note in
Phase C -- it is robust either way).

**Three classmethods on ``MOPACStep`` (in ``mopac_step/mopac_step.py``):**

``get_model_chemistry_options(periodic_only=False, mdi_only=False)``
  Returns a dict keyed by bare method name; each value has
  ``model_chemistry`` ("MOPAC:SQM@<name>"), ``type`` ("SQM"),
  ``description``, ``periodic_native``, ``periodic_mdi``, ``elements``,
  ``sparkle_elements``, ``mdi_capable``, ``mdi_method_arg``.

``get_executor_config(executor, seamm_options)``
  Reads ``mopac.ini`` for the active executor exactly as ``MOPAC.run()`` does
  (bootstrap default if missing; fall back to ``shutil.which``). Returns that
  ini section dict plus ``version`` and ``mdi_script`` (absolute path to
  ``data/mopac_mdi.py``). It is a classmethod taking ``executor`` and
  ``seamm_options`` because the *caller* (LAMMPS) already holds
  ``self.flowchart.executor`` and ``self.global_options``.

``get_mdi_engine_command(executor, seamm_options, *, method, port, hostname="localhost", charge=0, multiplicity=1, engine_name="MOPAC", extra_args=None)``
  Returns the engine launch **argv** (a list). The driver owns the rendezvous
  (TCP, port, hostname) and passes it in; MOPAC contributes the conda-run
  wrapper, the script path, and the ``--method``/``--charge``/``--multiplicity``
  flags. Raises ``NotImplementedError`` for non-conda installations (TODO).

**Guard data + test.**
``_MDI_CAPABLE_METHODS = {PM7, PM6-D3H4, PM6-ORG, PM6, AM1, RM1}`` and
``_MDI_PERIODIC_VALIDATED = {PM7, PM6-ORG, PM6}`` on ``MOPACStep``.
``tests/test_mdi_methods.py`` AST-parses ``data/mopac_mdi.py`` for its
``--method choices`` and asserts they equal ``_MDI_CAPABLE_METHODS`` (and that
``_MDI_PERIODIC_VALIDATED`` is a subset). It parses rather than imports because
the script targets ``seamm-mopac``.

**Environment.** ``mopac_step/data/seamm-mopac.yml`` deps:
``python=3.12, mopac, mopactools, numpy, pymdi, seamm-util``.


5. DevOps CI modernization (DONE)
=================================

All reusable workflows in ``molssi-seamm/devops/.github/workflows`` were moved
off Node.js 20 (runner removal deadline **2026-09-16**).

* **CodeQL.yaml** -- removed the ``Autobuild`` step (Python is interpreted, so it
  must use ``build-mode: none`` on ``init``; Autobuild now hard-errors); bumped
  ``init``/``analyze`` to ``@v4`` and ``checkout`` to ``@v5``.
* **BranchCI.yaml / CI.yaml / Docs.yaml** -- ``checkout@v4 -> v5``,
  ``conda-incubator/setup-miniconda@v3 -> v4``.
* **Release.yaml** -- those two plus ``setup-python@v5 -> v6`` and
  ``codecov-action@v4 -> v6`` **with ``file:`` renamed to ``files:``** (v5
  renamed that input).

**Watch items:**

* ``setup-miniconda@v4`` is a behavioral major bump (channel/condarc handling),
  not just a runtime bump. ``test_env.yaml`` pins ``conda-forge`` so it should be
  fine, but validate on a branch first since it sets up every job's environment.
* ``peaceiris/actions-gh-pages@v4`` (in Release.yaml deploy) has no Node-24
  release yet -- left as-is; watch for an update or migrate to an alternative.
* ``pypa/gh-action-pypi-publish`` is Docker-based, exempt from the Node
  deprecation (optional future: switch to PyPI Trusted Publishing/OIDC).

The plug-in repos only contain *thin caller* workflows (``uses:
molssi-seamm/devops/...@main``), so these devops edits fix all plug-ins at once;
the cookiecutter needs no change for this.


6. Phase B -- Model Chemistry Step (IN PROGRESS)
================================================

A new simple step: the user selects a model chemistry; ``run()`` stores it as
the workspace variable ``_model_chemistry`` for LAMMPS to read. Documented in
``NOTES_B.rst``.

.. important::

   The package was generated by ``seamm-cookiecutter`` as a **subflowchart**
   plug-in, but that is a **cookiecutter bug** (issues filed) -- it is actually a
   **simple** step. ``substep.py`` has already been removed. The subflowchart
   leftovers in ``model_chemistry.py`` (iterate-over-substeps ``run()``) and
   ``tk_model_chemistry.py`` (``create_dialog`` called from ``__init__``,
   subflowchart namespace) still need to be stripped.

**Confirmed design decisions:**

* **D1:** Simple step, not subflowchart. Fix ``run()`` and remove the
  subflowchart scaffolding.
* **D2:** ``_model_chemistry`` schema (below) is approved.
* **D3:** Keep the step **general** (list all discovered model chemistries) and
  add a **periodic filter** (the user knows if periodic is required). The step
  calls discovery with ``mdi_only=False``; LAMMPS (the consumer) validates
  MDI-capability.
* **D4:** GUI is **cascading Type -> Method -> Program**. Users care about type
  and method first; the program matters only to disambiguate when more than one
  implements the same ``Type@Method`` (often it is unique and auto-selects).

**The ``_model_chemistry`` contract (producer -> LAMMPS):**

.. code-block:: python

    {
        "model_chemistry": "MOPAC:SQM@PM6-ORG",   # canonical string
        "program": "MOPAC", "type": "SQM", "method": "PM6-ORG",
        "basis": None, "cutoff": None,            # parsed components
        "step": "<stevedore plugin name>",         # owning step, captured at discovery
        "options": { ... full get_model_chemistry_options() entry ... },
    }

**Delivered in Phase B:**

* ``model_chemistry_step/grammar.py`` -- ``parse_model_chemistry(text)`` and
  ``compose_model_chemistry(components)`` for the grammar
  ``Program:Type@Method[/Basis[@Cutoff]]`` (delimiters ``:``, ``@``, ``/`` are
  reserved; a Cutoff requires a Basis). Add to ``__init__.py``::

      from .grammar import parse_model_chemistry, compose_model_chemistry  # noqa: F401

* ``tests/test_grammar.py`` -- parse/compose/round-trip/rejection tests.

**Still to build in Phase B (next actions):**

#. **Strip subflowchart scaffolding** from ``model_chemistry.py`` and
   ``tk_model_chemistry.py`` (see the ``use_subflowchart == "n"`` branches in the
   cookiecutter templates for the simple-step shape).

#. **Discovery method** on the ``ModelChemistry`` node. Proposed implementation
   (returns wrappers already in the ``_model_chemistry`` shape, keyed by
   canonical string)::

    def model_chemistries(self, periodic_only=False, mdi_only=False):
        import stevedore
        from .grammar import parse_model_chemistry

        result = {}
        mgr = stevedore.ExtensionManager(
            namespace="org.molssi.seamm",
            invoke_on_load=False,
            on_load_failure_callback=lambda m, ep, err: logger.warning(
                "Could not load step plug-in %r: %s", ep.name, err
            ),
        )
        for ext in mgr:
            getter = getattr(ext.plugin, "get_model_chemistry_options", None)
            if getter is None:
                continue
            try:
                options = getter(periodic_only=periodic_only, mdi_only=mdi_only)
            except Exception as e:
                logger.warning("%s.get_model_chemistry_options() failed: %s",
                               ext.name, e)
                continue
            for option in options.values():
                key = option["model_chemistry"]
                if key in result:
                    logger.warning("Model chemistry %s offered by multiple "
                                   "steps; keeping the first.", key)
                    continue
                result[key] = {
                    **parse_model_chemistry(key),   # program/type/method/basis/cutoff
                    "step": ext.name,
                    "options": option,
                }
        return result

   (At runtime it may instead reuse ``self.flowchart.plugin_manager``; names
   match because both use the same namespace.)

#. **Parameters** (``model_chemistry_parameters.py``): a ``model_chemistry``
   string (the persisted canonical selection) and a ``periodic`` (yes/no)
   filter. The canonical string is the single source of truth; the cascading
   GUI decomposes it (via ``parse_model_chemistry``) on open and recomposes
   (via ``compose_model_chemistry``) on close.

#. **``metadata.py``** -- replace the cookiecutter placeholder with real
   metadata (and remove the placeholder ``"time"`` parameter).

#. **``run()``** -- roughly::

    next_node = super().run(printer)
    printer.important(self.header); printer.important("")
    P = self.parameters.current_values_to_dict(...)
    periodic = P["periodic"] == "yes"
    available = self.model_chemistries(periodic_only=periodic, mdi_only=False)
    selected = P["model_chemistry"]
    if selected not in available:
        raise ValueError(f"Model chemistry '{selected}' is not available.")
    self.set_variable("_model_chemistry", available[selected])
    return next_node

#. **Cascading GUI** (``tk_model_chemistry.py``): three comboboxes
   Type -> Method -> Program plus the periodic-filter checkbox; populate from
   ``self.node.model_chemistries(...)``; Program auto-selects when unique.

#. **Tests** for discovery + storage (mock a helper class exposing
   ``get_model_chemistry_options`` registered under the namespace, or call the
   method against an env with ``mopac_step`` installed).


7. Phase C -- LAMMPS consumption (NOT STARTED)
==============================================

When an MDI/QM model chemistry is selected, ``lammps_step`` must:

#. Read ``mc = self.get_variable("_model_chemistry")``.
#. Validate: ``mc["options"]["mdi_capable"]`` (and ``periodic_mdi`` for periodic
   systems); error helpfully otherwise.
#. Resolve the owning step:
   ``step = self.flowchart.plugin_manager.manager[mc["step"]].obj``.
#. Pick a **unique TCP port** per invocation (driver owns the rendezvous)::

    import socket
    def _free_tcp_port(hostname="localhost"):
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        try:
            s.bind((hostname, 0)); return s.getsockname()[1]
        finally:
            s.close()

   There is an unavoidable bind-to-rebind race; fine for one job per node. For
   many concurrent jobs, add an engine-bind-failure retry. **Unverified:** MDI
   TCP appears to require an explicit matching ``-port`` on both sides (no
   ``-port 0`` negotiation) -- confirm against the MDI docs.

#. Get the engine argv::

    engine_argv = step.get_mdi_engine_command(
        self.flowchart.executor, self.global_options,
        method=mc["method"], port=port, hostname=hostname,
        charge=configuration.charge, multiplicity=configuration.spin_multiplicity,
    )

   (charge/multiplicity from the configuration object -- SEAMM convention.)

#. Build LAMMPS's own driver line from ``lammps.ini`` (read the same way
   ``mopac.ini`` is) and emit a small launch script -- **engine backgrounded
   first** (it is the listener), driver second::

    #!/bin/bash
    set -e
    <engine argv via shlex.join>  &
    ENGINE_PID=$!
    <driver argv via shlex.join>
    wait $ENGINE_PID

   Launch order is robust regardless of which side listens, because the MDI
   client retries the connection. Relevant LAMMPS docs:
   https://docs.lammps.org/fix_mdi_qm.html and
   https://docs.lammps.org/Howto_mdi.html.


8. Open questions / watch list
==============================

#. MDI TCP ``-port`` negotiation -- verify no ephemeral/port-0 option exists.
#. Non-conda engine launches (``get_mdi_engine_command`` currently conda-only).
#. Concurrent-job port-collision retry (defer to Phase C polish).
#. ``setup-miniconda@v4`` behavioral changes -- validate.
#. ``peaceiris/actions-gh-pages`` Node-24 -- watch or migrate.
#. **xTB**, deferred: ``tblite_mdi.py`` exists as the xTB analogue of
   ``mopac_mdi.py`` (tblite Python API). Once the MOPAC thin line works, give
   ``xtb_step`` the same three classmethods and ship ``tblite_mdi.py`` in
   ``xtb_step/data/`` (Option C). GFN2-xTB is the most physical SQM for
   hydrogen-bonded liquids in earlier validation.


9. File map
===========

::

  mopac_step/
    mopac_step/mopac_step.py        # MOPACStep + the 3 classmethods + method sets
    mopac_step/data/mopac_mdi.py    # MDI engine (Option C)
    mopac_step/data/seamm-mopac.yml
    tests/test_mdi_methods.py

  model_chemistry_step/
    model_chemistry_step/grammar.py            # DELIVERED
    model_chemistry_step/model_chemistry.py    # strip subflowchart; write run()
    model_chemistry_step/tk_model_chemistry.py # cascading GUI (TODO)
    model_chemistry_step/model_chemistry_parameters.py  # model_chemistry + periodic
    model_chemistry_step/metadata.py           # real metadata (TODO)
    tests/test_grammar.py                       # DELIVERED
    (substep.py removed)

  devops/.github/workflows/
    CodeQL.yaml BranchCI.yaml CI.yaml Docs.yaml Release.yaml   # all updated

  campaign notes: NOTES_A.rst (Phase A), NOTES_B.rst (Phase B)
