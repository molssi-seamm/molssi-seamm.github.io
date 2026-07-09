.. _plan-long-range-electrostatics-mlff:

==========================================================
Plan: Long-Range Electrostatics for Short-Range MLFFs
==========================================================

:Date: 2026-06-26
:Status: Architecture proposed. Subcampaign 1 (atomic charges) in progress.
   2026-06-27: the **molecular DDEC6 path is working end-to-end** -- a Gaussian
   ``.wfx`` -> Chargemol -> parse -> ``charges_DDEC6`` column, validated on
   water (O -0.798, H +0.399, net 0.000). ``gaussian_step`` gained a "save wfx"
   option that writes ``<job>/<step_no>.wfx``; ``atomic_charges_step`` locates,
   runs, parses, and stores. Chargemol was built from source as a native arm64
   binary (not on conda-forge) with the ``atomic_densities`` data installed under
   ``~/SEAMM/atomic_charges``. **The full flowchart now runs through the real
   SEAMM executor** (``from_smiles -> Gaussian(save wfx) -> Atomic Charges``):
   ``charges_DDEC6 = [-0.792, 0.398, 0.394]`` was computed and persisted on the
   water configuration. Two incidental fixes were needed: ``gaussian_step`` now
   falls back to cclib's explicit Gaussian parser when ``ccread`` auto-detection
   returns ``None`` (the local Apple-Silicon G16 RevC.02 output is not recognized
   -- this blocked *all* Gaussian use in SEAMM on this machine), and the
   density-handoff location was corrected (the wfx lands in the Gaussian step's
   own directory, so the charge step searches the previous node's directory).
   (The Gaussian fix was then simplified to call cclib's Gaussian parser
   directly rather than ``ccread``, dropping auto-detection entirely -- the
   program is always Gaussian, so detection only adds a failure mode.)
   Remaining in subcampaign 1: the Bader backend and the VASP CHGCAR/AECCAR
   handoff (deferred -- needs a Linux/VASP machine).
   Subcampaigns 2-6 not started. The MDI-engine electrostatics design
   (subcampaign 5) supersedes an earlier LAMMPS-pair-style sketch -- see
   "Design decision" below.

.. contents:: Contents
   :depth: 3
   :local:


Overview
========

Short-range MLFFs such as MACE are accurate within their cutoff (~5-6 Å) but carry
no explicit long-range electrostatics. The goal of this campaign is to add a
physically correct electrostatic tail by **range separation / delta learning**:

#. Generate reliable reference atomic charges for the training-set frames
   (DDEC6 primarily; Bader as the rigorous topological companion users expect).
#. Train an ML model to predict those charges from structure.
#. Using the *predicted* charges, compute the long-range Coulomb energy and forces
   for each training frame and **subtract** them from the DFT energies/forces.
#. Fit the MLFF to this short-range remainder.
#. At inference, **add the identical long-range term back**, computed the same way
   from the same charge model.

The scheme is well-precedented: it is essentially **DPLR** (Deep Potential Long
Range) and is closely related to **4G-HDNNP** (charge equilibration) and to
**Latent Ewald Summation / CACE-LR** (the latter already coupled to MACE).

The single most important correctness constraint is **consistency**: the long-range
term subtracted during training must be *identical* to the one added at inference --
same charge model, same Ewald routine, same range-separation parameter. Everything
below is organized to make that constraint structural rather than something to be
maintained by hand.


Design decision: electrostatics live in the MDI engine, not in LAMMPS
=====================================================================

Production MD does **not** use a MACE ``pair_style`` in LAMMPS. Per the 2026-06-19 /
2026-06-22 MDI work, LAMMPS is the **MDI driver** (integrator) and
``lammps_step/data/mace_mdi.py`` is an **MDI engine** that returns energy/forces/
stress each step. All the physics already lives in that Python engine, so the
electrostatics belong there too -- not in ``coul/long`` + ``kspace`` on the LAMMPS
side.

This choice dissolves what would otherwise be the hardest problem in the whole
campaign, the **charge-response force term**. Because charges depend on geometry,
:math:`q_i(\mathbf{R})`, the true electrostatic force contains a
:math:`\partial E/\partial q \cdot \partial q/\partial \mathbf{R}` contribution. In
the engine, positions already carry ``requires_grad``; if charges and the long-range
energy are computed in the same torch graph, autograd differentiates through
:math:`q(\mathbf{R})` and that term comes for free::

    q     = charge_model(positions_t, ...)        # q_i(R), differentiable
    E_lr  = ewald(positions_t, cell_t, q)         # long-range Coulomb, torch
    E_tot = out["energy"] + E_lr
    F_tot = -autograd.grad(E_tot, positions_t)    # includes dq/dR automatically

A LAMMPS-side scheme with static per-step charges would silently drop that term and
require compensation; the MDI/torch design makes it automatic. The same applies to
the stress (differentiate w.r.t. strain/cell). Force/stress contributions are
additive, so the long-range part can also be computed separately and summed onto
MACE's outputs.

Consequence: LAMMPS stays exactly as it is -- no pair style, no ``kspace``, no
per-step charge handoff over MDI.


The subcampaigns
================

Each subcampaign is a discrete, separately landable and separately validatable piece.
They are listed in dependency order; the intent is to take them one at a time.

Subcampaign 1 -- Reference atomic charges (DDEC6 / Bader)
---------------------------------------------------------

:Depends on: nothing (start here)
:Delivers: an ``atomic_charges_step`` package + density export from QM steps

A new standalone post-processing step that runs **after** any QM step, reads the
electron density that step produced, and writes per-atom charges back into the
configuration. Both target methods are real-space density-grid partitioning, hence
code- and periodicity-agnostic:

* **DDEC6** (via the **Chargemol** program) -- the recommended general/force-field
  charge: reproduces the electrostatic potential *and* gives transferable chemical
  charges, works molecular and periodic including metals/MOFs. This is the charge
  the rest of the campaign trains against.
* **Bader / QTAIM** (via the Henkelman ``bader`` code) -- rigorous topological
  partition, basis-independent, the charge solid-state users expect. Charges run
  large/ionic and are not ESP-faithful, so it is a companion, not the training
  target.

Storage uses the existing labeled-charge-column pattern (cf.
``seamm_ff_util/forcefield.py``, ``charges_{label}``): write ``charges_DDEC6``,
``charges_Bader``, etc., as configuration-dependent float attributes. No molsystem
schema change is required. Tag with model-chemistry provenance where practical,
consistent with the ``_model_chemistry`` contract from the 2026-06-22 campaign.

Two pieces of glue, the second being the only genuinely per-code work:

* External programs (Chargemol, ``bader``, optionally Multiwfn for Hirshfeld-I /
  MBIS / CM5) wrapped via ``seamm_exec`` and installed via the step's
  ``installer.py`` + ``data/configuration.txt`` seamm.ini section.
* **Density export from the QM steps.** Each QM plugin needs an option to emit its
  density into the job in a known format and advertise the path. VASP first, since
  it benefits most: ``CHGCAR`` **plus** ``AECCAR0``/``AECCAR2`` (``LAECHG=.TRUE.``)
  -- Chargemol and Bader both need the all-electron/core density, not just valence.
  Molecular codes export ``.wfx`` / cube / molden.

:Validation: charges for known systems (e.g. water O ~ -0.6 to -0.8 DDEC6 vs the more
   ionic Bader value); sum of charges equals net charge.

Subcampaign 2 -- Charge prediction model
-----------------------------------------

:Depends on: Subcampaign 1 (DDEC6 reference charges)
:Delivers: a frozen, differentiable charge predictor

Train an ML model to predict the DDEC6 charges from structure. Two architectures,
not mutually exclusive:

* A **standalone torch charge model** (simpler, modular; loaded in the engine via a
  ``SEAMM_CHARGE_MODEL`` env var). Good for the two-stage flow.
* A **second output head on the MACE model** itself -- one forward pass yields both
  short-range energy and charges from shared equivariant features. Cleaner and the
  natural long-term design; deferred to Subcampaign 4 since it couples to MACE
  training.

Hard requirements: the model must be **differentiable** (so the engine gets
charge-response forces) and must **conserve total charge** (subtract mean excess so
:math:`\sum_i q_i` equals the net charge), or periodic Ewald is ill-defined. DDEC6
is *only* the training target -- it never appears in the baseline subtraction itself
(see Subcampaign 3).

:Validation: predicted-vs-DDEC6 parity on held-out frames; total-charge conservation.

Subcampaign 3 -- Electrostatic baseline + training-data correction
------------------------------------------------------------------

:Depends on: Subcampaigns 1, 2
:Delivers: a differentiable torch Ewald routine + corrected (E, F) training targets

Implement the long-range Coulomb energy/force routine **once**, in torch, and reuse
it for both subtraction (here) and addition (Subcampaign 5) -- this is what makes the
consistency constraint structural.

* Recommend **torch-pme** (differentiable PME/Ewald, pairs with ``vesin`` which the
  engine already uses for neighbor lists) rather than hand-rolling Ewald. It gives
  periodic PME with autograd forces and stress and the real/reciprocal split.
* **Range separation (the pitfall to get right):** subtract a *smooth* long-range
  term, not bare singular 1/r. Either subtract the full Gaussian-*smeared*-charge
  Coulomb (DPLR-style, recommended) or only the erf long-range part; in both cases
  let MACE absorb the short-range (erfc) electrostatics. The Gaussian smearing width
  is the knob -- tie it to the MACE cutoff ``r_max`` so the short-range part has
  decayed by the cutoff.
* Build the baseline with the **frozen charge model from Subcampaign 2**, then form
  the corrected targets :math:`E_{\text{DFT}} - E_{lr}`,
  :math:`F_{\text{DFT}} - F_{lr}`. Store as derived properties (datastore /
  ``table_step``).

:Validation: baseline forces match an independent Ewald implementation on a few
   frames; corrected targets are smoother / shorter-ranged than the raw DFT targets.

Subcampaign 4 -- Fit MACE to the short-range remainder
------------------------------------------------------

:Depends on: Subcampaign 3
:Delivers: a MACE model trained on the corrected data (optionally with a charge head)

Train MACE on the corrected :math:`(E, F)`. If pursuing the single-model design,
this is where the charge head from Subcampaign 2 is folded in and the charge target
(DDEC6) and energy target (corrected DFT) are trained jointly. Otherwise the charge
model stays a frozen sidecar.

:Validation: short-range MACE error on corrected data; ensure no electrostatic
   double-counting (the remainder must not still contain the long-range tail).

Subcampaign 5 -- Electrostatics in the MDI engine (inference)
-------------------------------------------------------------

:Depends on: Subcampaigns 2, 3, 4
:Delivers: ``mace_mdi.py`` extended to return the combined short-range + long-range potential

Extend ``calculate()`` in ``lammps_step/data/mace_mdi.py``:

#. **Charges** -- from the MACE charge head (preferred) or the sidecar model.
#. **Neutralize** -- enforce total charge.
#. **Long-range energy** -- call the *same* torch-pme routine from Subcampaign 3
   (full smeared-charge Coulomb periodic; direct Coulomb sum non-periodic).
#. **Combine** -- add ``E_lr``/``F_lr``/``stress_lr`` to MACE's outputs (in eV /
   eV·Å, then the engine's existing Hartree/Bohr conversions) and send the single
   combined potential over MDI.

Because the routine and charge model are identical to Subcampaign 3, the
train-subtract == inference-add constraint holds by construction. LAMMPS is unchanged.

:Validation: a static frame scored by the engine reproduces (corrected MACE) +
   (baseline) = full energy; energy conservation in NVE MD; momentum conservation.

Subcampaign 6 -- End-to-end validation and a worked example
-----------------------------------------------------------

:Depends on: all of the above
:Delivers: a validated workflow + a SEAMM flowchart example

Physical-property validation against DFT/experiment for a system where long-range
electrostatics matter (e.g. an aqueous electrolyte or an ionic interface): dielectric
behavior, ion pairing / RDFs, surface potentials. Compare against the baseline
short-range-only MACE to demonstrate the electrostatics actually buy something.
Package as a documented example flowchart.


SEAMM pipeline (how the subcampaigns compose)
=============================================

As a flowchart, the campaign is roughly:

#. Loop training frames -> QM density (VASP ``LAECHG=.TRUE.``) ->
   ``atomic_charges_step`` (DDEC6) -> ``charges_DDEC6`` column.   *(Subcampaign 1)*
#. Train + freeze the charge model.                               *(Subcampaign 2)*
#. Loop frames -> predicted charges -> torch-pme long-range :math:`(E, F)` ->
   subtract from DFT -> corrected targets.                        *(Subcampaign 3)*
#. Train MACE on corrected targets.                               *(Subcampaign 4)*
#. Production MD: LAMMPS driver + ``mace_mdi.py`` engine returning short-range +
   long-range.                                                    *(Subcampaign 5)*


Open questions carried into this plan
=====================================

* **Charge model architecture** -- standalone sidecar vs a second MACE head. The head
  is cleaner long-term but couples charge and energy training; start with whichever
  unblocks Subcampaign 3 soonest (likely a sidecar trained against DDEC6).
* **Range-separation form** -- full smeared-charge Coulomb (DPLR-style) vs erf-only
  long-range. Recommend the former; confirm empirically that the remainder is
  learnable within ``r_max``.
* **torch-pme** -- confirm it is the right dependency (autograd forces + stress,
  periodic, vesin-compatible) before committing; it is the recommended path but not
  yet trialed in the engine.
* **Charged / non-neutral systems and slabs** -- background-charge and slab
  corrections for Ewald are out of scope for the first pass; note where they would
  enter.
* **Provenance of charge sets** -- how much model-chemistry tagging to bake into the
  ``charges_{label}`` column name vs store alongside; ties to the ``_model_chemistry``
  contract from 2026-06-22.
* **Reuse of the torch electrostatics routine** -- it is deliberately written once and
  shared between the offline baseline (Subcampaign 3) and the engine (Subcampaign 5);
  decide where it physically lives (a small shared module importable by both).


References
==========

Internal / SEAMM
----------------

* :ref:`plan-model-chemistry-step` (the ``_model_chemistry`` contract; MDI engine
  consumption by ``lammps_step``)
* 2026-06-19 campaign -- MDI engine validation (MACE/MOPAC/xTB engines, LAMMPS as driver)
* ``lammps_step/data/mace_mdi.py`` -- the existing MACE MDI engine extended in Subcampaign 5
* ``seamm_ff_util/forcefield.py`` -- the ``charges_{label}`` labeled-column pattern

External tools
--------------

* **DDEC6 / Chargemol**; Henkelman ``bader`` -- reference atomic charges (Subcampaign 1)
* **torch-pme** -- differentiable PME/Ewald, pairs with ``vesin`` (Subcampaign 3)

Literature
----------

Verified citations for the methods this campaign builds on.

* **MACE** (the base short-range potential) -- I. Batatia, D. P. Kovács,
  G. N. C. Simm, C. Ortner, G. Csányi, "MACE: Higher Order Equivariant Message
  Passing Neural Networks for Fast and Accurate Force Fields," *Adv. Neural Inf.
  Process. Syst.* **35** (2022). arXiv:2206.07697.
* **Latent Ewald Summation (LES) / CACE-LR** -- B. Cheng, "Latent Ewald
  summation for machine learning of long-range interactions," *npj Comput.
  Mater.* **11** (2025). doi:10.1038/s41524-025-01577-7; arXiv:2408.15165.
  Range-separated long-range model demonstrated coupled to MACE -- the closest
  prior art to this campaign's approach.
* **4G-HDNNP** (charge equilibration with non-local charge transfer) --
  T. W. Ko, J. A. Finkler, S. Goedecker, J. Behler, "A fourth-generation
  high-dimensional neural network potential with accurate electrostatics
  including non-local charge transfer," *Nat. Commun.* **12**, 398 (2021).
  doi:10.1038/s41467-020-20427-2; arXiv:2009.06484.
* **DPLR (Deep Potential Long Range)** (spherical Gaussian charges + Ewald) --
  L. Zhang, H. Wang, M. C. Muniz, A. Z. Panagiotopoulos, R. Car, W. E, "A deep
  potential model with long-range electrostatic interactions," *J. Chem. Phys.*
  **156**, 124107 (2022). doi:10.1063/5.0083669; arXiv:2112.13327.
* **LODE** (long-distance equivariant descriptors) -- A. Grisafi, M. Ceriotti,
  "Incorporating long-range physics in atomic-scale machine learning,"
  *J. Chem. Phys.* **151**, 204105 (2019). doi:10.1063/1.5128375;
  arXiv:1909.04512.

Recent work (post-dates this plan; not yet vetted in depth)
-----------------------------------------------------------

* MACE-POLAR-1: A Polarisable Electrostatic Foundation Model for Molecular
  Chemistry -- arXiv:2602.19411.
* A foundation machine learning potential with polarizable long-range
  interactions for materials modelling -- arXiv:2410.13820.
* Learning Long-Range Representations with Equivariant Messages -- arXiv:2507.19382.
* Long-range electrostatics in atomistic machine learning: a physical
  perspective -- arXiv:2602.11071; and "Long-range electrostatics for machine
  learning interatomic potentials is easier than we thought" -- arXiv:2512.18029.
