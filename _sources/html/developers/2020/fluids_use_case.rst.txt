.. _2020_fluids_use_case:

*********************************
Use Case: Fluid Properties (2020)
*********************************

Goals and Motivation
--------------------
As laid out in the initial phase of this project,
:ref:`2019_fluids_use_case`, starting initially with LAMMPS_, this
project intends to develop the use case of calculating properties of
fluids to

1. Create, test and refine flowcharts for predicting the density and
   cohesive energy of organic liquids.
#. Develop the capabilities of the `LAMMPS plugin`_ as needed for the
   flowcharts.
#. Create or enhance any other plugins needed.

The first phase of the project identified the following areas of
difficulties and questions for performing the study:

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

Tasks:
------
1. Enhance the `LAMMPS plugin`_ to automatically equilibrate a system
   until specified variables are converged and to automatically
   determine the length of a simulation to deliver specified
   properties to given error bars. See
   :ref:`automatic_convergence_2020` for more detail.
#. Validate the statistical analysis. See
   :ref:`validation_of_statistical_analysis_2020` for more detail.
#. Determine the effect of fluid system size on resulting properties,
   and produce both flowcharts to automate this determination as well
   as guides to users for reasonable system size. This guidance should
   preferably be embedded in e.g. a fluids plugin or flowcharts. See
   :ref:`system_size_effects_2020` for more detail.
#. Implement one or more other forcefields using the new forcefield
   plugin approach. See :ref:`forcefield_plugins_2020` for details on
   the forcefield plugins.
#. Calculate and analyze the liquid density of 50 compounds, using the
   new protocols and tools.

Discussion
----------

.. toctree::
   :titlesonly:
   :glob:

   fluids/*

.. _LAMMPS: https://lammps.sandia.gov
.. _LAMMPS plugin: https://github.com/molssi-seamm/lammps_step
.. _COMPASS: https://doi.org/10.1021/jp980939v
