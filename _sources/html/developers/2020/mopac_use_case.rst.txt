.. _2020_mopac_use_case:

***********************
 Use Case: MOPAC (2020)
***********************

MOPAC_ has an extensive suite_ for the validation of the semiempirical
Hamiltonions, which have culminated with PM7. Dr. Stewart has
graciously given us the set of datafiles underlying the calculations
presented on the MOPAC website. The initial goals for the project were
to use this large dataset to

1. Facilitate the creation and execution of a single or many
   semi-empirical quantum chemistry calculations using MOPAC. 
#. Serve as a guiding application to develop the necessary
   functionality and infrastructure in SEAMM that execute any
   arbitrary plugin.

This was a very valuable project, in which we made considerable
progress, but also learnt about issues and areas that needed more
work. The goals of this second phase of the project remains the
same. There is more to be done!

Tasks:
------
1. Finalize current MOPAC plugin project (estimated time:)

   a. FINISH CATCHING ERRORS
   #. Plot flowchart energies/enthalpies of vaporization vs reference values 
   #. Explore the extent to which input SMILES strings can be used
      instead of input MOPAC files for running MOPAC calculations.

#. Think about the requirements of SEAMM for automatic execution of
   SEAMM flowcharts in clusters (estimated time:)
#. Investigate which current workflow execution software offers the
   cluster requirements that SEAMM needs (estimated time:)
#. Create ‘mock’ use cases (i.e. without actually writing the plugins)
   to explore the limitations of SEAMM flowcharts. For instance, free
   energy calculations, path sampling methods, flowcharts with ‘IF’
   statements.
#. Design more example flowcharts to keep developing SEAMM internals
   (estimated time:)
#. The next project could be a set of MM high throughput flowcharts
   that compute the following thermodynamic quantities of liquids of
   an existing database, such as

   a. Liquid densities
   #. Surface tension
   #. Volumetric expansion coefficient
   #. Isothermal compressibility
   #. Enthalpy of vaporization
   #. Vapor pressures
   #. Saturated liquid (and vapor) densities
   #. Viscosities

#. This would involve creating the following tools

   a. A plugin that wraps system building tools (Packmol or mBuild for
      liquids, for instance) 
   #. A plugin that automatically wraps existing tools that atom type
      a variety of systems, such as antechamber, foyer, gromacs
      atom-typing tools, amber tools, SEAMM atom-typing tool, etc. 
   #. Make the plugin for LAMMPS (MD code) and Cassandra (MC) more
      robust.
   #. A plugin for each of the desired thermodynamic properties or one
      that encompass several of them.

Potential Issues
----------------
1. Whether and how ions and spin can be handled in SMILES.
   
.. _MOPAC: http://openmopac.net
.. _suite: http://openmopac.net/PM7_accuracy/PM7_accuracy.html
