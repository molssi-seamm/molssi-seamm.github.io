.. _notes-mdi-lammps-phase-c:

==========================================================
Phase C -- LAMMPS consumption of the model chemistry (MDI)
==========================================================

:Author: Paul Saxe (with Claude)
:Date: 2026-06-24
:Status: Planned -- decisions locked, ready to implement
:Campaign: LAMMPS + MOPAC/xTB QM-MD via MDI

.. contents:: Contents
   :depth: 2
   :local:


Scope
=====

``lammps_step`` reads the ``_model_chemistry`` workspace variable produced by
the Model Chemistry step (Phase B) and, when it names an MDI-capable QM method,
drives LAMMPS MD with forces from that engine over MDI/**TCP**. Thin line:
``MOPAC:SQM@PM6-ORG``, a periodic liquid, NVT/NPT.


What already exists in lammps_step
==================================

``lammps_step`` *already* drives ML force fields over MDI, but via **MPI** -- a
single ``mpirun ... : ...`` MPMD launch with the engine and driver both in the
``seamm-lammps`` environment (the ``gpu-code`` template in ``data/lammps.ini``,
selected by GPU presence at ``lammps.py:1141``). MOPAC must instead use **TCP**:
``mopac_mdi.py`` needs the ``seamm-mopac`` environment and cannot share one MPI
world with ``lmp``. TCP decouples the two environments.

Reusable as-is: the driver fix line
``fix mdi_fix all mdi/qm [virial yes] elements <types>``
(``initialization.py:806-815``) -- transport-agnostic, works for TCP unchanged.


Decisions (locked)
==================

* Driver runs ``-np 1`` (the work is in the engine; likely never more).
* Launch logic goes in ``_execute_single_sim`` (where the calculation is done),
  not a separate method.
* Consumer precedence: **if ``_model_chemistry`` exists use it; else if
  ``_forcefield`` exists use it** (back-compat with the Forcefield step). See
  Phase D for folding the forcefield into the model chemistry.
* The MDI handshake is already validated by hand (that is how ``mopac_mdi.py``
  was built) -- no standalone smoke test needed.


Proven by-hand invocation
=========================

From the ``mopac_mdi.py`` docstring (Paul ran this manually; it works)::

  # engine
  python mopac_mdi.py \
    -mdi "-role ENGINE -name MOPAC -method TCP -port 8021 -hostname localhost" \
    --method PM6-ORG --charge 0 --multiplicity 1
  # driver
  mpirun -np 1 lmp -in in.mopac_nvt \
    -mdi "-role DRIVER -name LAMMPS -method TCP -port 8021"

Explicit matching ``-port`` on both sides (no port-0 negotiation). Charge and
multiplicity come from the configuration object -- LAMMPS ``fix mdi/qm`` does
not send ``>TOTCHARGE`` / ``>ELEC_MULT``, so the engine CLI values are
authoritative.


Contracts consumed
==================

* ``_model_chemistry`` (Phase B dict): ``model_chemistry``, ``program``,
  ``type``, ``method``, ``basis``, ``cutoff``, ``step`` (owning plugin name),
  ``options``.
* ``options`` (from MOPAC discovery): ``mdi_capable``, ``periodic_mdi``,
  ``mdi_method_arg``, ...
* Phase A engine builder (verified in ``mopac_step/mopac_step.py:222``)::

    MOPACStep.get_mdi_engine_command(
        executor, seamm_options, *, method, port, hostname="localhost",
        charge=0, multiplicity=1, engine_name="MOPAC", extra_args=None
    ) -> argv   # render with shlex.join; conda-only (else NotImplementedError)


Implementation steps (lammps_step)
==================================

#. **Detect QM/MDI mode** in ``run()`` (``lammps.py`` ~650): read
   ``_model_chemistry`` first, fall back to ``_forcefield``. Set a flag/handle
   so initialization and execution know this is an MDI-QM run (mutually
   exclusive with a forcefield).
#. **Emit the driver fix** in ``initialization.py`` (~793-820): in QM/MDI mode,
   emit the existing ``fix mdi/qm`` line (the periodic/non-periodic split is
   already there) and no pair_style.
#. **Launch** in ``_execute_single_sim`` (``lammps.py:1124-1162``): when QM/MDI,
   pick a free TCP port, resolve the engine step
   (``self.flowchart.plugin_manager.manager[mc["step"]].obj``), build the engine
   argv via ``get_mdi_engine_command(..., method=mc["method"], port=port,
   charge=configuration.charge, multiplicity=configuration.spin_multiplicity)``,
   write ``run_mdi.sh``, and run it via ``executor.run`` in ``seamm-lammps``
   (the engine line nests its own ``conda run -n seamm-mopac``).
#. **Validate** ``options["mdi_capable"]`` (and ``options["periodic_mdi"]`` for
   periodic systems); raise a helpful error otherwise.
#. **Tests**: assert the QM/MDI branch builds the expected ``run_mdi.sh`` and
   engine argv (mock the engine step); confirm classical-FF runs are unchanged.


run_mdi.sh template
===================

::

  #!/bin/bash
  set -e
  <engine argv via shlex.join> &        # conda run -n seamm-mopac python mopac_mdi.py ...
  ENGINE_PID=$!
  mpirun -np 1 lmp -mdi "-role DRIVER -name LAMMPS -method TCP -port <PORT>" \
    -in input.dat > stdout.txt 2>&1
  wait $ENGINE_PID

Free-port helper::

  import socket
  def _free_tcp_port(hostname="localhost"):
      s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
      try:
          s.bind((hostname, 0)); return s.getsockname()[1]
      finally:
          s.close()


Open risks (low now)
====================

* Concurrent jobs: an unavoidable bind->rebind port race; fine for one job per
  node; add an engine bind-failure retry only if it bites.
* Non-conda installs: ``get_mdi_engine_command`` raises ``NotImplementedError``
  off conda -- inherited limit; document it.
* Multi-rank driver to a single engine: deferred (``-np 1`` by decision).
