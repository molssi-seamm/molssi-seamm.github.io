2026-06-22 Model Chemistry Step, Metadata Protocol, and MOPAC/xTB via MDI
=========================================================================

Goal
----

As the previous plan 2026-06-19 was developed it became clear the direction needed
substantial changes. This is the result of the knowledge, adding a Model Chemistry Step
modeled after and eventually replacing the Forcefield Step; providing the MDI
capabilities using metadata accesses via Stevedore; and finally the actual MOPAC & xTB
MDI implementations.

Supporting MDI with, initially, MOPAC and xTB as engines for LAMMPS. This will allow us
to use semiempirical methods with MD. This initial phase will build on the work with the
MDI connections for MLFFs, starting with standalone tests and ending with incorporating
the functionality in the LAMMPS step in SEAMM.

Contents:

.. toctree::
   :glob:
   :maxdepth: 2

   PLAN*
   NOTES*
   PROJECT_HANDOFF
