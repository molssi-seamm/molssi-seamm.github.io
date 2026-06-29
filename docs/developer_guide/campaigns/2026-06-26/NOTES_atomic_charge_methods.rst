.. _notes-atomic-charge-methods:

==========================================================
Notes: Atomic Charge Methods and MLFF Long-Range Prior Art
==========================================================

:Date: 2026-06-26
:Status: Reference material supporting
   :ref:`plan-long-range-electrostatics-mlff`. Background, not a
   work plan.

.. contents:: Contents
   :depth: 2
   :local:


The one distinction that matters: what the scheme consumes
==========================================================

Atomic charges are not quantum observables -- there is no unique way to partition the
electron density among atoms, hence the zoo of schemes. For this campaign the
reliability question and the molecular-vs-periodic question collapse onto a single
axis: **what input does the scheme consume?**

* **Basis-/wavefunction-based** schemes are tied to a molecular code's internal data
  and (mostly) to localized basis sets -> molecular codes only.
* **Real-space density-grid** schemes consume a charge density on a grid (or a
  cube/wfx), which every code can emit and which is periodicity-agnostic -> they work
  identically for VASP and for molecular codes.

The grid-based methods are therefore both the more transferable/reliable choice *and*
the ones that work for periodic systems -- which is why DDEC6 and Bader anchor
Subcampaign 1 of the plan.


Method landscape
================

.. list-table::
   :header-rows: 1
   :widths: 16 16 10 30 22

   * - Method
     - Input
     - Periodic?
     - Reliability / use
     - Code
   * - Mulliken / Löwdin
     - basis
     - molecular
     - Basis-set unstable; do not trust quantitatively
     - native everywhere
   * - NPA (NBO)
     - basis
     - molecular
     - Stable, good *chemical* charges; not ESP-faithful
     - NBO (Gaussian/Orca/Psi4 iface)
   * - CHELPG / Merz-Kollman / **RESP**
     - ESP on grid (vacuum)
     - molecular only
     - ESP-faithful -> force-field charges; buried-atom & conformer issues
     - native (Gaussian/Orca/Psi4)
   * - Hirshfeld
     - density grid
     - **yes**
     - Small / underestimated charges
     - Multiwfn, Critic2, native
   * - Hirshfeld-I (iterative)
     - density grid
     - **yes**
     - Much better than Hirshfeld; captures charge transfer
     - Multiwfn, HORTON, Critic2
   * - **CM5**
     - density (Hirshfeld + params)
     - yes (mol. mainly)
     - Cheap, good dipoles, general-purpose molecular
     - native (Gaussian/Psi4), Multiwfn
   * - **MBIS**
     - density grid
     - yes
     - Modern stockholder; favored for FF/ML (OpenFF)
     - Psi4 (native), HORTON, GPU4PySCF
   * - **Bader / QTAIM**
     - density grid
     - **yes**
     - Rigorous, basis-independent; charges exaggerated but consistent
     - Henkelman ``bader`` (CHGCAR), Critic2, Multiwfn
   * - **DDEC6**
     - density grid (+ core)
     - **yes, incl. metals/MOFs**
     - ESP-faithful **and** chemically meaningful **and** transferable
     - **Chargemol** (VASP, Gaussian, Orca, …)
   * - REPEAT
     - periodic ESP
     - yes
     - Periodic analog of CHELPG
     - a few codes / scripts


Recommendations
===============

* **One method to span everything: DDEC6 (Chargemol).** The only widely-used scheme
  that simultaneously reproduces the ESP, gives transferable chemical charges, and is
  designed for molecular *and* periodic systems including metals. It also solves the
  "ESP charges for VASP" problem that CHELPG/MK cannot (no vacuum region) -- so REPEAT
  is not separately needed. **This is the training target for the charge model.**
* **Bader (Henkelman)** as the robust, well-understood grid companion, especially for
  solid-state users who expect it. Charges run large/ionic and are not ESP-faithful,
  so it is a companion, not the MLFF training target.
* **RESP / CHELPG** remain the molecular force-field path; **MBIS** is the rising
  FF/ML choice and Psi4 does it natively.
* Treat **Mulliken / Löwdin** as diagnostics only.


Bader vs DDEC6 (why both, and how they differ)
==============================================

Both consume the same density grid, both are periodic- and molecular-capable, and
both need the same density export from the QM step -- which is why they share
Subcampaign 1 of the plan.

* **Bader / QTAIM** partitions real space into **basins** separated by **zero-flux
  surfaces** (where :math:`\nabla\rho\cdot\mathbf{n}=0`); each basin holds one nucleus,
  and integrating :math:`\rho` over it gives the atom's electron count, so
  :math:`q_A = Z_A - N_{\text{basin}}`. No basis functions are involved, so it is
  basis-robust and code-agnostic, and it is the solid-state standard. But the charges
  are **not** fit to the electrostatic potential and come out **large / very ionic**
  (e.g. water O near -1.1 to -1.2). Good for charge-transfer / oxidation-state-style
  analysis, less ideal as force-field point charges.
* **DDEC6** is a stockholder-type partition whose weights are optimized so the charges
  *simultaneously* approximate the ESP and stay chemically transferable -- the "best
  of both" you want for FF/ML charges.

**Density export caveat (both methods).** For VASP they need the **all-electron**
density, not just the pseudized valence ``CHGCAR``: set ``LAECHG=.TRUE.`` to also write
``AECCAR0`` (core) and ``AECCAR2`` (valence). Without the core density the basins /
weights are misassigned around nuclei. Molecular codes export ``.wfx`` / cube / molden.


MLFF long-range prior art
=========================

The range-separation / delta-learning scheme in the plan is well-precedented:

* **DPLR (Deep Potential Long Range)** -- predicts charges (via Deep Wannier
  centroids), computes the long-range Ewald energy from *spread (Gaussian)* charges so
  the subtracted term is smooth, subtracts it from the DFT data, fits the short-range
  model to the remainder, and adds it back. Implemented in DeePMD-kit + LAMMPS. This is
  the closest precedent to the plan's scheme.
* **4G-HDNNP** (Ko, Finkler, Goedecker, Behler) -- a fourth-generation HDNNP using
  charge equilibration for non-local charge transfer; the reference point for "do the
  charges right, then the electrostatics."
* **Latent Ewald Summation (LES) / CACE-LR** (Cheng group) -- learns latent charges and
  adds an Ewald term, *without* needing reference charges; already coupled to MACE.
  An alternative worth knowing, though this campaign deliberately uses physical DDEC6
  charges for interpretability and reusable, inspectable charge sets.

Two design points that fall out of the prior art and are load-bearing for the plan
(stated in full there): **range-separate** the subtracted Coulomb so only the smooth
long-range part is removed (DPLR uses Gaussian-spread charges for exactly this), and
keep **train-subtract identical to inference-add** (same charge model, same Ewald
routine) -- trivially satisfied by doing the electrostatics in the MDI engine with a
single shared torch-pme routine.


References
==========

* :ref:`plan-long-range-electrostatics-mlff`
* DDEC6: Manz & Limas, "Introducing DDEC6 atomic population analysis: part 1.
  Charge partitioning theory and methodology," *RSC Adv.* **6**, 47771 (2016),
  doi:10.1039/C6RA04656H. (Part 2, doi:10.1039/C6RA05507A, covers periodic and
  nonperiodic materials.) DDEC6 is the method; *Chargemol* is the program implementing it.
* Bader analysis on grids: Henkelman group ``bader`` code; Critic2; Multiwfn (tools, no
  single canonical paper -- cite the specific code's own reference when used)
* DPLR: Zhang, Wang, Muniz, Panagiotopoulos, Car & E, "A deep potential model with
  long-range electrostatic interactions," *J. Chem. Phys.* **156**, 124107 (2022);
  arXiv:2112.13327
* 4G-HDNNP: Ko, Finkler, Goedecker & Behler, "A fourth-generation high-dimensional
  neural network potential with accurate electrostatics including non-local charge
  transfer," *Nat. Commun.* **12**, 398 (2021), doi:10.1038/s41467-020-20427-2
* LES: B. Cheng, "Latent Ewald summation for machine learning of long-range
  interactions," *npj Comput. Mater.* (2025), doi:10.1038/s41524-025-01577-7;
  arXiv:2408.15165. CACE (Cartesian Atomic Cluster Expansion), the MLIP it is coupled
  with, is at https://github.com/BingqingCheng/cace
* ``torch-pme`` -- differentiable PME/Ewald in PyTorch (lab-cosmo / COSMO @ EPFL;
  metatensor ecosystem): https://github.com/lab-cosmo/torch-pme
