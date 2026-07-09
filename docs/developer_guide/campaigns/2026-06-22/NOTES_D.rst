.. _notes-mdi-lammps-phase-d:

=====================================================================
Phase D (sketch) -- Forcefield handling folded into Model Chemistry
=====================================================================

:Author: Paul Saxe (with Claude)
:Date: 2026-06-24
:Status: Design sketch only -- not started
:Campaign: LAMMPS + MOPAC/xTB QM-MD via MDI


Goal
====

Subsume the Forcefield step into the Model Chemistry step and **deprecate** the
former (keep it for back-compat). Replace the three overloaded workspace
variables -- ``_forcefield`` (string ``"OpenKIM"`` / string ``"PyTorch"`` / a
``seamm_ff_util.Forcefield`` object), ``_OpenKIM_Potential``, ``_pytorch_model``
-- with the single structured ``_model_chemistry`` wrapper. Consumers prefer
``_model_chemistry`` and fall back to ``_forcefield`` (the Phase C precedence
rule).


Type vocabulary
===============

.. list-table::
   :header-rows: 1
   :widths: 12 38 26 24

   * - Type
     - Meaning
     - Example
     - Compute path
   * - SQM
     - semiempirical QM
     - ``MOPAC:SQM@PM6-ORG``
     - MDI engine
   * - DFT
     - density functional
     - ``Psi4:DFT@B3LYP/def2-SVP``
     - engine
   * - VFF
     - valence (classical) forcefield
     - ``Forcefield:VFF@OPLS-AA``
     - native pair_style
   * - ReactiveFF
     - reactive forcefield (ReaxFF-style)
     - ``Forcefield:ReactiveFF@<n>``
     - native (pair_style reaxff)
   * - IP
     - interatomic potential (EAM/MEAM, via OpenKIM)
     - ``OpenKIM:IP@<KIM-ID>``
     - native (pair_style kim)
   * - MLFF
     - machine-learned forcefield
     - ``MACE:MLFF@<model>`` / ``mliap:MLFF@<model>``
     - MDI (MACE) or native (mliap)

VFF vs ReactiveFF is decided by ``Forcefield.ff_form`` (``"reaxff"`` ->
ReactiveFF, otherwise VFF). Native vs MDI is ``options["mdi_capable"]`` -- the
consumer branches on that single flag, the same one MOPAC already uses.


Provider (decision: DU1 = (b))
==============================

The deprecated Forcefield step grows a ``get_model_chemistry_options()``
classmethod and is **discovered like any other provider**; the Model Chemistry
step stays a pure aggregator (no special-casing). The classical
``seamm_ff_util.Forcefield`` object rides inside ``options`` for native
VFF/ReactiveFF, so ``seamm_ff_util`` stays the engine and the consumer calls
``energy_expression(config, style)`` as it does today. OpenKIM carries its KIM
id; MLFF carries the model path plus real type metadata (framework, cutoff)
instead of filename-sniffing.


KEY OPEN ISSUE -- atom-type assignment
======================================

The Forcefield step also performs "assign forcefield to structure": typing atoms
and assigning charges via ``Forcefield.assign_forcefield(configuration)`` (used
downstream alongside ``energy_expression``). This is a **stateful** operation on
the configuration with **no QM analogue**, and is the part that does not map
cleanly onto "a model chemistry is just a recorded choice." Must be designed
before building the VFF/ReactiveFF providers:

* Does selecting a VFF/ReactiveFF model chemistry trigger atom typing, or is it a
  separate action/task (as the Forcefield step's "assign forcefield to
  structure" task is today)?
* Where is ``assign_forcefield`` invoked -- in the Model Chemistry step's
  ``run()``, or on demand by the consumer (e.g. LAMMPS during input generation)?
* How does charge/type state interact with re-running or changing the structure?


Consumer pattern
================

::

  if self.variable_exists("_model_chemistry"):
      mc = self.get_variable("_model_chemistry")
      if mc["options"]["mdi_capable"]:
          ... launch engine + fix mdi/qm (Phase C path) ...
      else:
          ... native pair_style: VFF/ReactiveFF via the FF object, IP via
              pair_style kim, mliap via pair_style mliap ...
  elif self.variable_exists("_forcefield"):
      ... existing Forcefield-step handling (back-compat) ...
