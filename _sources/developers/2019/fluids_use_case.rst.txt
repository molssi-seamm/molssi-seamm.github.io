.. _2019_fluids_use_case:

*********************************
Use Case: Fluid Properties (2019)
*********************************

Goals and Motivation
--------------------
Starting initially with LAMMPS_, this project intends to develop the
use case of calculating properties of fluids to

1. Create, test and refine :term:`flowcharts<flowchart>` for
   predicting the density and cohesive energy of organic liquids.
#. Develop the capabilities of the `LAMMPS plug-in`_ as needed for the
   flowcharts.
#. Create or enhance any other :term:`plug-ins<plug-in>` needed.

While there are a large number of fluid properties that can be
calculated, and a wide range of different types of fluids, this first
phase will concentrate mostly on the plug-ins and flowcharts, and hence
uses on two simple properties, density and cohesive energy, for
straighforward organic liquids such as benzene, toluene, alkanes,  and
alcohols.

The density is perhaps the simplest property of a fluid, and
calculating any other fluid property will require equilibrating the
fluid, so density is a natural first step. The cohesive energy, or
equivalently the enthalpy of vaporization, is an example of a
different class of properties which require periodically sampling a
different property while propagating a normal dynamics trajectory. In
order to calculate the cohesive energy it is necessary to calculate
the intermolecular energy, i.e. the electrostatic and van der Waals
energy *between* molecules.

Tasks:
------
1. Develop a robust workflow and calculate the density and cohesive
   energy of 50 fluids using LAMMPS, with no more than 2 failures.

Accomplishments
---------------
1. Developed a flowchart for calculating the `density of Ar`_, and then
   extended to handle organic liquids.
#. Installed SEAMM on the NewRiver cluster at ARC, and learnt how to
   submit SEAMM workflows to the PBS queueing system.
#. Performed initial testing of the statistical analysis of the
   trajectory information and found reasonable agreement. However,
   much more needs to be done in order to have confidence in the error
   bars.
#. Calculated the density for 8 fluids using the PCFF2018 forcefield
   implemented in SEAMM. See table below

.. tabularcolumns: |l|c|c|c|

====================	  =========  =========  ==========
Compound     	    	 	  rho(g/ml)
--------------------	  --------------------------------
\       		  exp        calc	error
====================	  =========  =========  ==========
hexane	    		  0.65478    0.613	-6.4%
benzene	    		  0.87367    0.744	-14.8%
cyclohexane 		  0.77389    0.710	-8.3%
methanol    		  0.78633    0.763	-3.0%
1-propanol  		  0.8053     0.780	-3.1%
2-propanol  		  0.7850     0.752	-4.2%
pyridine    		  0.978	     0.836	-14.5%
2,2-dimethoxypropane	  0.848	     0.878	3.5%
====================	  =========  =========  ==========

Discussion
----------
Technically this project made reasonable progress during this phase,
and it would have been quite feasible to calculate the densities of 50
fluids by brute force. However, the work to date has raised
significant questions both about the procedure and the results:

1. The current approach, as is typical in MD simulations, forces the
   user to specify the length of the dynamics runs for equilibration
   and data collection. This is not satisfactory for routine
   application, particularly high throughput, since different systems
   have different timescales.
#. The results shown above do not appear credible. The forcefield used
   is similar to the COMPASS_ forcefield, indeed for alkanes it is
   identical, and typically fluid densities predicted with COMPASS are
   within about 1-2% of experiment.
#. In order to have confidence in the results we need to carefully
   determine the effect of system size to ensure the results are
   independent of the chosen system size, and we need to validate the
   calculated error bars in order to do this, or any other calculation
   for that matter.
#. The results need to be validated against known results for the
   COMPASS forcefield, and extended to other forcefields.

Currently it is a considerable amount of manual work to test and
validate items 2-4 above. Addressing item 1 as well as other
cumbersome steps in the workflow will be needed to reasonable address
items 2-4. This is the motivation for the second phase of this
project, :ref:`2020_fluids_use_case`.

..
   .. toctree::
      :glob:

      *

.. _LAMMPS: https://lammps.sandia.gov
.. _LAMMPS plug-in: https://github.com/molssi-seamm/lammps_step
.. _density of Ar: https://github.com/molssi-seamm/misc/blob/master/flowcharts/demos/ar_npt.flow
.. _organic liquids: https://github.com/molssi-seamm/misc/blob/master/flowcharts/demos/ethane_npt.flow
.. _COMPASS: https://doi.org/10.1021/jp980939v
