.. _2019_plans:

**************************
Development Plans for 2019
**************************

These are the plans for the development of SEAMM in the last half
of 2019.

Goals
_____
The overall goals for SEAMM are

#. Create an easy-to-use productivity environment for users of
   computational molecular and materials codes (CMS), with a wide
   range of tools for building, simulation and analysis of molecular,
   fluid and crystalline materials.
#. Provide developers an easy-to-use, well-defined plugin framework
   for integrating their codes in the SEAMM environment so that users
   can use their code. 
#. Provide system managers and support staff an easier, more
   productive way to provide CMS functionality to end users. 

The goals for this first six-month phase of the project, starting July
2019, are

#. To establish a development process in accord with MolSSI best practices.
#. To develop enough of the SEAMM framework to be useful
#. To create sufficient plugins to run realistic, useful simulations
   with both forcefield and quantum methods.
#. To use the MOPAC validation suite case as a use case to
   improve and test  the overall functionality of SEAMM and of the
   MOPAC plugin.
#. To use the predicition of fluid properties as a use case to
   improve and test  the overall functionality of SEAMM and of the
   LAMMPS plugin.
   

Discussion and Achievements
---------------------------
1. The goal was to Implement a continuous integration system based on
   MolSSI best-practices, with testing and documentation covering 50%
   of the non-GUI code. Investigate ways to automate testing of GUI
   code, which at the moment is an unknown.

   This was partially acoomplished. Of a total of 18 repositories (6
   for the core of SEAMM, 9 plugins, the dashboard, a cookiecutter,
   the website and a miscellaneous directory of support files) for a
   total of 12,479 lines of code, 40% of the nongraphical code is
   currently tested automatically. All of the core and plugins have
   documentation at ReadTheDocs, and there is a beginning of user
   documentation at https://molssi-seamm.github.io/

#. Design and implement a reference management system suitable for the
   requirements and use cases in SEAMM. Add the appropriate citations for
   all the modules and plugins.

   Mostly Achieved: Developed MolSSI/reference_handler and added 53
   references for MOPAC -- though this is not yet the full number
   needed for the functionality covered in the plugin. Have not yet
   added references to the other plugins, though most should be
   simple. LAMMPS, however, will be considerable work, like MOPAC.

#. Work out and implement a scheme to archive versions of the code
   with DOI’s using, for example Zenodo.

   This task was postponed.

#. Learn about web design and programming in order to implement a
   :term:`Dashboard` fronting a datastore for :term:`jobs<job>` run
   using SEAMM.

   Achieved: Jessica has done an excellent job learning about web
   technology and has an impressive prototype dashboard, including a
   preliminary display of :term:`flowcharts<flowchart>`. A database
   for storing job, project, and flowcharts is implemented in
   SQLAlchemy. The front end uses flask and a web template from
   CoreUI. We have basic CI which builds an environment for the
   dashboard using Travis CI.  This can be found at
   https://github.com/molssi-seamm/seamm_dashboard.

#. Develop a robust workflow and calculate the density and cohesive
   energy of 50 fluids using LAMMPS, with no more than 2 failures.
   
   Partly Achieved: Accomplished most of this goal, developing an
   effective, robust workflow to predict the fluid density starting
   with a SMILES string representing the compound, and finished
   calculations on 9 fluids with no issues. However, it became clear
   that the standard approach of running “long enough” was not
   satisfactory for high throughput calculations, and that it would be
   straightforward to extend the plugin to target an accuracy rather
   than the number of steps. This is proposed for the next project
   period, at which time the full 50 calculations will be
   completed. Also, it will require a minor modification to LAMMPS to
   calculate the cohesive energy, which has not yet been accomplished
   and fed back into the LAMMPS source.

#. At least 200 comparisons of heat of formation with NIST WebBook and
   MOPAC, with no more than 2% failures and 2% incorrect conformations
   starting from SMILES.
   
   Achieved: Eliseo went far beyond the initial scope, running all
   8,000+ structures in the MOPAC validation set. Several systematic
   problems were encountered and some of them fixed, including charges
   on systems and systems containing lanthanides, which require
   special treatment in MOPAC. Outstanding issues revolve around the
   definition of open-shell systems, and bugs in MOPAC and OpenBabel
   which are being investigated. There was one small change to the
   plan: rather than start with SMILES we started with structure
   files, but will move to SMILES files next iteration of the
   project. 


.. toctree::
   :titlesonly:
   :glob:

   [a-h]*
   [j-z]*
   
