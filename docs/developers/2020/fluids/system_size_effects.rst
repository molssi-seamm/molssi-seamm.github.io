.. _system_size_effects_2020:

****************************************
System Size Effects in Fluid Simulations
****************************************

Goals and Motivation
--------------------
Simulation of fluids typically use periodic boundary conditions to
avoide edge effects; however, treating an amorphous fluid or disordered
system as a periodic system introduces possible non-physical
dependencies on the size of the simulation (unit) cell used. Fluid
simulations carried out in small cells emphasize the crystallinity of
the system, effectively raising the freezing point of the system,
reducing mobility such as diffusion, etc.

It is a good practice to determine the convergence of any measured
properties as a function of the cell size. In order to do this we need
good control of the precision of the calculated properties since as
the cell size increases the error decreases, so we are looking for
small differences in values, which will be very difficult if the
statistical uncertainty is large. The
:ref:`automatic_convergence_2020` portion of this subproject should
solve that issue, allowing this part to concentrate on developing
:term:`flowcharts<flowchart>` for determining the size effect,
providing guidance to users, and allowing :term:`plug-in` and
flowchart writers to use reasonable defaults for the system size.

Tasks
-----
1. Develop a general flowchart using LAMMPS for exploring the size
   effect for a specified property. Extend for any other available codes.
#. Explore the size dependency for a number of properties and a diverse
   range of fluids. Document the results, and if possible provide
   "rule of thumb" for default system size.

Results and Discussion
----------------------
