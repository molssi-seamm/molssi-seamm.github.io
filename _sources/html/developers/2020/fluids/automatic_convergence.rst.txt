.. _automatic_convergence_2020:

******************************
Automatic Convergence in MD/MC
******************************

Goals and Motivation
--------------------
The `LAMMPS plug-in`_ already has excellent capabilities for
statistical analysis of data generated during MD simulations. However,
it is currently used for analysis after the run, not for control of
the run itself. Typically there are two phases for any MD or MC
calculation being used to calculate numerical properties. The first is
an initial equilibration of the system, which is followed by a
"production" run during which the properties of interest are sampled
periodically. Statistical analysis of these samples provides the
average value and error bars for each property.

The goal of this part of the project is to automate both parts of the
simulation. This will make it easier for users to run simulations
because they will not have to decide *a priori* how long the
equilibration and production phases should be. It will also help
ensure the quality of the results and should provide warnings or
errors if the results are not accurate. This automation is critical
for high-throughput production of properties for large numbers of
molecules, particularly those for diverse sets of molecules, which
tend to require different relaxation and sampling times.

Tasks:
------
1. Design, prototype and test protocols for ensuring convergence of given
   properties during the equilibration phase of the simlation.
#. Design, prototype and test protocols for ensuring convergence of given
   properties to given statistical error bars during the production
   phase of the simulation.
#. Implement any needed statistical analysis methods in the
   `SEAMM utility library`_.
#. Add the protocols chosen from those tested in steps 1 & 2 to the
   `LAMMPS plug-in`_, adding the appropriate user controls to the GUI.
#. Document both the new code and the new functionality in the user
   manual.
#. Create both unit and functional tests for the new functionality.

Results and Discussion
----------------------

.. _LAMMPS plug-in: https://github.com/molssi-seamm/lammps_step
.. _SEAMM utility library: https://github.com/molssi-seamm/seamm_util
   
