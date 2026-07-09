.. _notes-mdi-lammps-phase-a:

==================================================================
Phase A -- MOPAC-side MDI engine launch contract and port strategy
==================================================================

:Author: Paul Saxe (with Claude)
:Date: 2026-06-23
:Status: In progress
:Campaign: LAMMPS + MOPAC/xTB QM-MD via MDI

.. contents:: Contents
   :depth: 2
   :local:


Scope
=====

Phase A delivers the **MOPAC side** of the LAMMPS-driven MDI/QM-MD
integration: everything ``mopac_step`` must expose so that a driver
(``lammps_step``, Phase B) can launch the MOPAC MDI engine in the correct
conda environment *without hardwiring any MOPAC-specific knowledge*.

In scope for Phase A:

* ``MOPACStep.get_executor_config()`` -- read ``mopac.ini`` for the active
  executor and resolve the bundled engine script (delivered earlier this
  session).
* ``MOPACStep.get_mdi_engine_command()`` -- build the engine launch argv.
* Shipping ``mopac_mdi.py`` inside the package at
  ``mopac_step/data/mopac_mdi.py`` (Option C, below).
* A guard test keeping ``_MDI_CAPABLE_METHODS`` and the engine's
  ``--method`` choices in lock-step.
* The agreed design for the launch script and TCP port allocation
  (implemented driver-side in Phase B).

Deferred to Phase B:

* ``lammps_step`` actually generating and running the launch script.
* Reading ``lammps.ini`` for the LAMMPS (driver) half.
* GUI wiring of the MDI/QM model-chemistry choice in the LAMMPS step.
* Concurrent-job port-collision retry (see `Port allocation`_).
* Non-conda installations (local / modules / docker) for the engine.


Why Option C (script shipped in ``data/``)
==========================================

``mopac_mdi.py`` is shipped **inside the package** at
``mopac_step/data/mopac_mdi.py`` and located at run time via
``importlib.resources.files("mopac_step") / "data" / "mopac_mdi.py"``.

Rationale, versus the two alternatives considered:

* **Option A (console-script entry point in mopactools)** was rejected: we
  do not control ``mopactools``, so we cannot add an entry point there.
* **Option B (copy into seamm-mopac/bin at install, the torchani pattern)**
  was rejected because the copy goes stale: a user who runs
  ``pip install -U mopac-step`` but does not re-run the step installer would
  keep running an old engine. Tying the engine to the installer is "tempting
  fate."
* **Option C (chosen)**: the file rides along in the wheel, so
  ``pip install -U mopac-step`` refreshes it automatically -- no dependence
  on the user re-running the environment installer.

.. note::

   ``mopac_mdi.py`` runs under the **seamm-mopac** Python, even though the
   file physically lives in the **seamm** environment's site-packages. This
   works because a script's location does not determine its imports -- the
   interpreter does. The engine therefore **must** import only packages
   present in ``seamm-mopac`` (``mopactools``, ``pymdi``/``mdi``, ``numpy``,
   ``seamm_util``) and **nothing** from ``mopac_step`` or ``seamm``.

   It is shipped in ``data/`` (not as ``mopac_step/mopac_mdi.py``)
   deliberately, so it is *not* importable as a module -- which removes the
   temptation to add a ``from . import ...`` that would pass tests under
   ``seamm`` but fail at run time under ``seamm-mopac``.


Division of responsibility
===========================

The MDI rendezvous has two halves that must agree on transport, port, and
hostname. We split ownership as follows:

* **Driver (lammps_step) owns the rendezvous.** It chooses the transport
  (TCP), allocates the port, and sets the hostname, because it must give the
  *same* values to both the engine and the LAMMPS driver.
* **MOPAC (mopac_step) owns its engine line.** Given the rendezvous
  parameters, it returns a ready-to-run argv that knows the conda
  environment, the engine script path, the engine's MDI ``-name``, and the
  ``--method`` / ``--charge`` / ``--multiplicity`` flags.

So ``lammps_step`` passes port/hostname *in*, and ``mopac_step`` hands the
engine argv *back*. No MOPAC knowledge leaks into ``lammps_step``.


The two new classmethods
========================

``get_executor_config(executor, seamm_options)``
------------------------------------------------

Mirrors the ``mopac.ini`` handling in ``MOPAC.run()`` (read the section for
``executor.name``; bootstrap the bundled default if absent; fall back to
``shutil.which("mopac")``). Returns that section's dict plus:

* ``version``    -- the plug-in version (container tag).
* ``mdi_script`` -- absolute path to ``data/mopac_mdi.py``.

It is a classmethod taking ``executor`` and ``seamm_options`` because reading
the ini needs the active executor type and the SEAMM root -- both of which
the *driver* already holds (``self.flowchart.executor`` and
``self.global_options``). No node instance is required, so it remains
reachable via Stevedore, symmetric with ``get_model_chemistry_options()``.

``get_mdi_engine_command(executor, seamm_options, *, method, port, ...)``
-------------------------------------------------------------------------

Builds the engine launch argv::

    [conda, run, --live-stream, -n, <seamm-mopac>,
     python, <abs path to mopac_mdi.py>,
     -mdi, "-role ENGINE -name MOPAC -method TCP -port <port> -hostname <host>",
     --method <method>, --charge <q>, --multiplicity <m>, <extra_args...>]

Notes:

* ``method`` is validated against ``_MDI_CAPABLE_METHODS``.
* Returns an argv *list*; the caller renders it with ``shlex.join()`` so the
  ``-mdi`` value is correctly quoted as a single token.
* Currently raises ``NotImplementedError`` for non-conda installations --
  flagged honestly rather than mis-launched. Local / modules / docker is a
  Phase B+ item.


Launch script shape (driver-side, Phase B)
==========================================

The driver composes a small bash script, engine backgrounded first (it is
the listener), driver second::

    #!/bin/bash
    set -e
    <engine argv>  &
    ENGINE_PID=$!
    <driver argv>
    wait $ENGINE_PID

The engine half comes verbatim from ``get_mdi_engine_command()``. The driver
half is built by ``lammps_step`` from its own ``lammps.ini`` (read the same
way ``mopac.ini`` is), so each code's environment stays owned by its own
step.

.. note::

   In this engine the **engine is the listener**: ``mopac_mdi.py`` calls
   ``MDI_Accept_Communicator()``, so it binds the port and LAMMPS connects to
   it (MDI's client side retries the connection). Hence the engine is
   backgrounded *first*, and the port must be free at the moment the engine
   binds.


Port allocation
===============

Each invocation needs a unique TCP port, given to both sides. Approach:

Ask the OS for a free ephemeral port -- bind a throwaway socket to port 0,
read back the assigned number, release it, pass that integer to both engine
and driver::

    import socket

    def _free_tcp_port(hostname="localhost"):
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        try:
            s.bind((hostname, 0))
            return s.getsockname()[1]
        finally:
            s.close()

.. note::

   **Race window.** There is an unavoidable gap between releasing the socket
   and the engine re-binding the port (classic TOCTOU). Fine for the typical
   one-job-per-node case.

   For many concurrent jobs on one node, the robust mitigation (Phase B,
   optional) is an orchestration-level retry: if the engine dies immediately
   with "address already in use," pick a new port and relaunch. A cheaper
   partial mitigation is to seed the candidate from a job-specific value
   (e.g. base port + hash of the SEAMM job id) so independent jobs rarely
   collide to begin with.

.. warning::

   **Unverified.** MDI's TCP transport is believed to require an explicit
   matching ``-port`` on both sides, with no ``-port 0`` / OS-negotiated
   option -- which is exactly why the port must be pre-picked here rather
   than letting the engine bind ephemeral and report back. Confirm against
   the MDI docs before relying on it; if a port-file handshake exists, switch
   to it to eliminate the race.


Method-set guard test
======================

``_MDI_CAPABLE_METHODS`` (in ``mopac_step.py``) and the engine's
``--method`` ``choices`` (in ``data/mopac_mdi.py``) live in two files and
must stay equal. ``tests/test_mdi_methods.py`` extracts the engine's choices
by parsing ``mopac_mdi.py`` with :mod:`ast` (no import -- the script is not a
module and targets ``seamm-mopac``) and asserts:

#. ``_MDI_CAPABLE_METHODS`` == engine ``--method`` choices.
#. ``_MDI_PERIODIC_VALIDATED`` is a subset of ``_MDI_CAPABLE_METHODS``.

Currently both pass; the shared set is
``{PM7, PM6-D3H4, PM6-ORG, PM6, AM1, RM1}``.


Open questions
==============

#. **MDI port-0 support** -- see the warning above; verify against MDI docs.
#. **Non-conda launches** -- ``get_mdi_engine_command`` currently only
   handles conda; do we need local/modules/docker, and if docker, how do the
   engine and driver share a TCP port across containers?
#. **Concurrent-job port collisions** -- decide whether the Phase B
   orchestration needs the bind-failure retry.
#. **Charge / multiplicity source** -- confirmed coming from the
   ``configuration`` object (per SEAMM convention), not engine CLI defaults,
   once the driver wires it through.


References
==========

* MDI Library (TCP transport, roles): https://molssi-mdi.github.io/MDI_Library/
* LAMMPS ``fix mdi/qm``: https://docs.lammps.org/fix_mdi_qm.html
* LAMMPS MDI HOWTO: https://docs.lammps.org/Howto_mdi.html
* ``conda run``: https://docs.conda.io/projects/conda/en/latest/commands/run.html
* ``importlib.resources``:
  https://docs.python.org/3/library/importlib.resources.html
* Ephemeral ports (bind to 0): https://docs.python.org/3/library/socket.html
