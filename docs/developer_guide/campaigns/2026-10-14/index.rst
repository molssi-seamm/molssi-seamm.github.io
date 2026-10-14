2026-10-14 MD analysis: H5MD output, a shared library and analysis steps
=========================================================================

Goal
----

Bring the analysis that the science and mlff sessions now do in their own scripts
into SEAMM: viscosity, diffusion constants with the Yeh–Hummer correction, the
dielectric constant, radial distribution functions, coordination and ion pairing,
with honest error bars and the results stored as SEAMM properties.

The design rests on three parts:

#. one H5MD file written by each MD step, holding its trajectory and time series;
#. a shared analysis library that the analysis steps are built on;
#. analysis steps that either run their own MD replicas or analyse the MD that came
   before them in the flowchart.

The data contract does not depend on the MD code, so a GROMACS step can feed the same
analysis steps later.

The discussion behind it, 2026-10-14, is in Paul's notes for that day. The
decisions are summarized in the design document.

Contents:

.. toctree::
   :glob:
   :maxdepth: 2

   PLAN*
