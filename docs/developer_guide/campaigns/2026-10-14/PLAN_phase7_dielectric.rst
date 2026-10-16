Phase 7: the dielectric constant and the ionic conductivity
============================================================

Status: **proposed** (2026-10-16), for Paul's review. Nothing is implemented.

Goal
----

The static dielectric constant of liquids and of the solvent in electrolyte
solutions, and the ionic conductivity of electrolytes, from equilibrium MD, with
errors, graphs and stored results -- what science now computes in scripts
(``mlff_dipoles.py``, ``eps_both.py``; campaign 2026-10-16, section 3.4) for
classical forcefields.

The design document's table says: "Dielectric constant: our own code. MDAnalysis's
``DielectricConstant`` assumes no free charges, so it cannot be used for
electrolytes. For an electrolyte, use the dipole of the neutral molecules or
separate out the ionic current; which one is to be settled in that phase." Ionic
conductivity (Nernst–Einstein and the full Einstein form, as in mdgo) follows.

1. The physics
--------------

**Dielectric constant.** With Ewald or PPPM electrostatics and conducting
("tin-foil") boundary conditions, as LAMMPS uses, the static dielectric constant of
a periodic cell of volume V at temperature T is

.. math::

   \varepsilon = 1 + \frac{\langle \mathbf{M}^2 \rangle - \langle \mathbf{M} \rangle^2}
                        {3 V \varepsilon_0 k_B T}

with M the dipole of the cell, Σ qᵢ rᵢ over the atoms of whole molecules. It
converges slowly -- the dipole decorrelates over picoseconds and its fluctuations
need nanoseconds -- so the errors come from blocks or independent runs, and a
graph of the running estimate shows the convergence.

- **A neutral liquid** (water, carbonates): M over every molecule.
- **An electrolyte**: the ions carry a current, not a bounded dipole, so M over the
  whole cell grows without limit. The step uses the dipole of the **neutral
  molecules** only, which gives the dielectric constant of the solvent in the
  presence of the ions -- the quantity usually reported for electrolyte
  solutions (the dielectric decrement). It leaves out the ion-solvent cross term,
  which a rigorous treatment separating the ionic current would include; that is a
  later option (see *Decisions*).
- **Molecular ions** (BF4⁻, PF6⁻) are ions: they are left out of M like monatomic
  ones. Molecules are classified by their total charge; one that is neither
  neutral nor an integer charge (a model artefact) is reported.

**Ionic conductivity.**

- *Nernst–Einstein*, from the self-diffusion coefficients of the ions:
  σ_NE = e² / (V k_B T) Σ_species N_s z_s² D_s.
- *Einstein–Helfand*, from the collective displacement of the charges,
  σ = lim_{t→∞} ⟨|Σᵢ qᵢ (rᵢ(t) − rᵢ(0))|²⟩ / (6 V k_B t), which includes the
  correlations between ions (ion pairing lowers it).
- Their ratio, the *ionicity* σ/σ_NE.

The collective form is noisy; it needs long runs and several runs or blocks, as
for the viscosity. The Yeh–Hummer finite-size correction applies to the
self-diffusion coefficients (it can use the viscosity from a Viscosity step, as
Diffusivity does).

2. Where the dipole and the displacements come from
----------------------------------------------------

**From the trajectory**, not from sampling in LAMMPS: the positions in ``md.h5md``
are unwrapped, so molecules stay whole, and the forcefield charges are stored
there too. The same frames give M(t) and the ions' displacements, for any MD
code that writes the file, with no change to the LAMMPS step. Frames every
0.1-0.5 ps are enough (the step asks for them in mode A and checks for them in mode
B, as the other analysis steps do); the dipole decorrelates over picoseconds.

**Charges.** Only fixed charges, from the forcefield, are supported. A
machine-learned forcefield has no fixed charges in the file, so the steps refuse
MLFF runs with a clear message. Charges from the MLFF engine (over MDI) wait on
whether the LES models' latent charges give usable dipoles (science, 2026-10-14).

**Electrostatics.** The formula above holds for Ewald or PPPM with tin-foil
boundary conditions. The LAMMPS H5MD writer records the kspace style in the run's
parameters, and the step warns when it is anything else (a cutoff or
reaction-field treatment needs a different formula).

3. The steps
------------

Two steps, built like Viscosity and Liquid Structure (their own MD as replicas, or
the MD before them), sharing a new library module:

- **Dielectric Constant**: ε with its error, the running estimate, the
  autocorrelation of M and its correlation time; for an electrolyte, which
  molecules made up M. Results: ε, its error, and for each run the volume,
  temperature and ⟨M²⟩.
- **Ionic Conductivity**: σ (Einstein–Helfand) and σ_NE with their errors, the
  ionicity, the self-diffusion coefficient of each ion (with Yeh–Hummer when a
  viscosity is available), the Helfand moment and MSD graphs. Results in S/m.

Both need a periodic system and fixed charges; both check, before the MD runs,
that positions are sampled often enough.

4. The library: ``seamm_md_analysis.electric``
-----------------------------------------------

- ``molecule_charges(configuration)`` and the classification (neutral molecules,
  ions, others);
- ``cell_dipole(frames, atoms, charges)``: M(t) from positions, streamed;
- ``dielectric_constant(M, V, T, blocks)``: ε, its error, the running estimate;
- ``charge_displacement(frames, ions, charges)``: the collective translational
  dipole of the ions, for the Helfand moment; the existing
  ``fit_helfand_moment`` and ``msd_by_species`` do the rest;
- ``nernst_einstein(D, counts, charges, V, T)``.

Released first, then the two steps, as in the earlier phases.

5. Tests and validation
-----------------------

- **Synthetic, with known answers:** N fixed dipoles of moment μ oriented at random
  each frame (⟨M²⟩ = Nμ², so ε is known); independent random walks of charges
  (σ = σ_NE exactly, ionicity 1); perfectly paired ions moving together (σ = 0).
- **Charges:** neutral molecules, monatomic and molecular ions, and a non-integer
  molecule reported.
- **H5MD round trip** from the LAMMPS writer, including the recorded kspace style.
- **GUI** over every layout; **run path** with a small LAMMPS run locally.
- **Real data:** SPC/E water against the published value for the model (about 70);
  1 molal NaCl in SPC/E for the dielectric decrement and the conductivity, against
  published values for the same models and science's ``eps_both.py``.

6. Decisions for Paul
---------------------

#. **Electrolytes: the dipole of the neutral molecules** (recommended), with a later
   option to separate the ionic current rigorously (including the ion-solvent cross
   term) -- or do the rigorous treatment now?
#. **The dipole from the trajectory** (recommended), rather than sampling it in
   LAMMPS (``compute dipole``), which would need an MD-step change and a group of
   the neutral molecules.
#. **Two steps**, Dielectric Constant and Ionic Conductivity (recommended, in line
   with one analysis per step), or one step with both?
#. **MLFFs refused** until their engines supply charges (recommended), rather than
   accepting per-species charges given by the user.
#. **Nernst–Einstein from the step's own MSD of the ions** (recommended: one step,
   one run, consistent frames), or from a preceding Diffusivity step's results?
