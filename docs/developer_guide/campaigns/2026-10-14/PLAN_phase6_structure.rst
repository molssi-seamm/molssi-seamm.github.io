Phase 6: the structure of liquids and solutions
================================================

Status: **implemented** (2026-10-16) as ``liquid_structure_step`` (local commit 03c88b5; the GitHub repository is not created yet). Differences from the plan: the g(r) are the step's own code (MDAnalysis ``capped_distance``) rather than ``InterRDF``, which gives the block errors directly and also the counts without a cell; the solvation shells are the step's own code (see the revision below); shells and ion pairing use the heavy atoms of each species, so a molecule is in a shell when its coordinating atoms are. Checked on 1 molal NaCl in SPC/E water; the real-data check against science's run 12197 is still to do.

Goal
----

Bring the structural analysis that science and mlff now do in scripts into a SEAMM
analysis step: partial radial distribution functions, coordination numbers, ion
pairing (contact, solvent-separated and aggregated pairs), the composition of
solvation shells, and residence times -- with errors, graphs and stored results.
The design document's table of analysis steps describes it as "Structure: partial
g(r) and coordination numbers (MDAnalysis ``InterRDF``); solvation shells, ion
pairing and residence times through SolvationAnalysis", reading positions sampled
about every 0.5-1 ps.

What it replaces today (campaign 2026-10-16, section 3.4): ``analyze_liquid.py``
(g(r)), ``goo.py`` (O-O peaks and n_OO), ``analyze_nacl_md.py`` and ``cip_fixed.py``
(coordination numbers; CIP/SSIP with a fixed 3.5 Å cutoff, because the automatic
first minimum picked the solvent-shared peak at 5.21 Å when one was present).

1. The step
-----------

A new plug-in made from the cookiecutter, in the *Analysis* group, built like the
Viscosity step:

- **Where the MD comes from** (``md source``): its own MD in a sub-flowchart, run
  as replicas (mode A), or the MD that ran before it in the flowchart: the last run
  or all runs since a given step (mode B), read through ``_md_runs`` and
  ``md.h5md``.
- **What it needs** (``md_requirements``): atomic positions sampled at least every
  1 ps (by default; the residence times need finer frames, see 5), and a periodic
  system for the parts that need a density (g(r), SolvationAnalysis). In mode A it
  turns the sampling on itself; in mode B the flowchart check reports what is
  missing before the MD runs, as for Viscosity.
- **Name:** "Structure" is taken by ``structure_step`` (energy-optimized
  structures), so a new name is needed; see *Decisions*.

2. What to analyse: species and sites
--------------------------------------

The MDAnalysis ``Universe`` comes from ``MDData.universe(configuration)``
(seamm_md_analysis), which has the molecules as residues. The step names each
species by its formula as SEAMM finds the molecules (``H2O``, ``Li``, ``BF4``,
``C3H4O3``), and a **site** is an element of a species (``O in H2O``, ``Li``,
``F in BF4``) or, for anything else, an MDAnalysis selection string.

- **Pairs for g(r):** by default every pair of elements; or a table of pairs of
  sites.
- **Solute and solvents** for shells and pairing: by default every monatomic ion
  is a solute and every other species a solvent; or given in a table.

3. Radial distribution functions and coordination numbers
---------------------------------------------------------

- Partial g(r) by MDAnalysis ``InterRDF`` for each pair, from 0 to the smaller of
  12 Å and half the shortest cell width, in bins of 0.02 Å, over the production
  frames, excluding pairs within the same molecule.
- Errors from blocks of frames (five by default), shown as a band on the graph.
- For each pair: the first peak (position and height), the first minimum, and the
  coordination number n(r) integrated up to the minimum, with its error. Each pair
  can be given a **fixed cutoff** instead, and the step warns when the automatic
  minimum lies beyond the second peak's usual range (the case that misled
  ``analyze_nacl_md.py``).
- Graphs: g(r) and n(r) per pair; a table of peaks, minima and coordination
  numbers.

4. Ion pairing
--------------

For each cation-anion pair, every cation in every frame is classified, by the
anions within the contact cutoff (r1, the first minimum of their g(r), or given)
and within the solvent-separated cutoff (r2, the second minimum, or given):

- **free:** no anion within r2;
- **SSIP:** none within r1, at least one within r2;
- **CIP:** exactly one within r1, and that anion bound to no other cation;
- **AGG:** an anion within r1 that is also within r1 of another cation.

The fractions are averaged over the frames, with errors from blocks. This is the
step's own code (MDAnalysis ``capped_distance``), so it works for non-periodic
systems too (clusters), and it follows science's practice of fixed cutoffs where
the automatic ones mislead.

5. Solvation shells and residence times (SolvationAnalysis)
------------------------------------------------------------

For each solute, through SolvationAnalysis's ``Solution`` (its shell cutoffs from
the g(r) minima, or given):

- **coordination numbers** of each solvent in the first shell;
- **speciation:** the fraction of solutes with each shell composition (for
  example Li(EC)\ :sub:`3`\ (BF\ :sub:`4`) 41 %), the top few printed and all
  stored;
- **pairing:** the fraction of solutes with at least one of each solvent;
- **residence times** of each solvent in the shell, off by default: they need
  frames every 0.1 ps or so, ten times the default sampling, and the step then asks
  for it.

5 is offered only for periodic systems, since SolvationAnalysis finds its cutoffs
from ``InterRDF``, which fails without a cell.

6. Results
----------

Printed tables and ``.graph`` files as in the other analysis steps, and results for
variables and tables: per pair, the first peak and minimum and the coordination
number (with errors); per cation-anion pair, the pairing fractions; per solute, the
coordination numbers and the speciation (as JSON, like Diffusivity's per-species
results). The coordination numbers and pairing fractions can be stored as
properties of the configuration, ``CN O-Li#Structure#<model>`` and so on.

7. Non-periodic systems
-----------------------

A cluster has no density, so g(r) and SolvationAnalysis are not offered; the step
reports coordination numbers within fixed cutoffs and the ion pairing (4), which use
only distances. The step checks the input's periodicity before any MD runs (mode A)
or before the MD before it runs (mode B), as the other analysis steps do.

8. Dependencies and memory
--------------------------

- ``seamm-md-analysis[structure]`` (MDAnalysis 2.10) and ``solvation-analysis``
  (0.4.2: numpy ≥ 2.2, pandas, rdkit, statsmodels, plotly -- all already in SEAMM
  installations, which have numpy 2.5, pandas 3 and RDKit 2026.09). Neither becomes
  a dependency of core SEAMM.
- Frames are streamed from ``md.h5md`` by MDAnalysis; nothing holds the trajectory
  in memory. The g(r) accumulate over frames.

9. Tests
--------

- **Synthetic, with known answers:** an ideal gas (g(r) = 1 within its noise); a
  simple cubic lattice (peaks at a, √2 a, √3 a and coordination numbers 6, 12, 8);
  hand-built cation-anion arrangements, one per class (free, SSIP, CIP, AGG), in
  periodic and non-periodic cells.
- **H5MD round trip:** the lammps_step test data (64 waters), through
  ``MDData.universe``.
- **GUI:** the dialog built headlessly and ``reset_dialog`` run over every choice.
- **Run path:** a small LAMMPS run of NaCl in water (locally), in both modes.
- **Real data:** science's NaCl(aq) run 12197 (CIP fraction 0.04 with the 3.5 Å
  cutoff; Na-O CN 5.52, Cl-O CN 6.58) and the G7 water g_OO, against
  ``analyze_nacl_md.py``/``cip_fixed.py`` and ``goo.py``.

10. Releases
------------

seamm-md-analysis first if shared code goes there (the pairing classification and
the block errors of a histogram, which the dielectric step may reuse); then the new
step's first release, with its docs and its entries on the main documentation site
(the *Analysis* plug-ins page and the status badges).

Revision (Paul, 2026-10-16, during implementation)
-----------------------------------------------------

SolvationAnalysis turned out to be GPL-3 (MDAnalysis has been LGPL-3 since 2.8, which
is fine for a BSD-3 plug-in). Paul chose to write the solvation-shell analysis in the
step instead -- per-solvent coordination numbers, shell compositions, pairing and
residence times, on the same distance code as the ion pairing -- so the step has no
GPL dependency. Section 5 and decision 5 below are superseded; the shells also work
for non-periodic systems when the cutoffs are given.

Decisions (Paul, 2026-10-16: the recommendations below)
-------------------------------------------------------

#. **The name.** "Structure" is taken. Recommended: **Liquid Structure**
   (``liquid_structure_step``), which says what it is for; or **Structural
   Analysis**, or reviving the 2021 ``trajectory_analysis_step`` stub (never
   released) under its name.
#. **Comparing with X-ray data** at the experiment's resolution (science's
   ``skinner_same_resolution.py``: S(Q) to Q_max 21.8 Å⁻¹ with a variable Lorch
   window, so g_OO is broadened as in the measurement): in this phase, or a
   follow-on option of the g(r)? Recommended: a follow-on, since it needs reference
   data and a choice of window per experiment.
#. **Ion pairing:** the step's own classification by cutoffs (4), recommended,
   since it works for clusters and matches science's practice; SolvationAnalysis
   keeps the shells and residence times (5).
#. **Residence times** in this phase, off by default (recommended), or later?
#. **solvation-analysis as a hard dependency** of the step (recommended: everything
   it pulls in is already installed), or optional with that part hidden when it is
   missing?
