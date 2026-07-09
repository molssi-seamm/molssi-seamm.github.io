2026-06-26 Long-Range Electrostatics for Short-Range MLFFs
==========================================================

Goal
----

Give short-range MLFFs (MACE first) a physically correct long-range electrostatic
tail, using a range-separation / delta-learning scheme: predict per-atom charges,
compute the long-range Coulomb energy and forces from them, subtract that baseline
from the DFT training data, fit the MLFF to the short-range remainder, and add the
identical baseline back at inference. The motivating application is reliable
condensed-phase and interfacial MD where the bare short-range cutoff of MACE is not
enough.

This is decomposed into a sequence of **subcampaigns**, each a discrete, separately
landable piece (reference charges via DDEC6/Bader, the charge model, the baseline,
the MACE charge head, the MDI-engine electrostatics, and validation). They are
intended to be tackled one at a time, in roughly dependency order, and each can be
validated standalone before the next begins.

This campaign builds directly on the MDI engine work from the 2026-06-19 and
2026-06-22 campaigns: production MD runs MACE as an **MDI engine** driven by LAMMPS,
which is what makes the electrostatics implementation tractable (see the plan).

Contents:

.. toctree::
   :glob:
   :maxdepth: 2

   PLAN*
   NOTES*
