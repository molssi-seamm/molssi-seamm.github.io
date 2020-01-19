**************************
Development Plans for 2020
**************************

These are the plans for the development of SEAMM in the first half
of 2020.

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

The goals for the first six-month phase of the project, starting July
2019, were to establish a development process in accord with MolSSI
best practices; develop enough of the SEAMM framework to be useful;
and create sufficient plugins to run realistic, useful simulations
with both forcefield and quantum methods.

The goals for this next phase of development, running from January
through June 2020, are as follows:

#. To make the installation easier and more robust
#. To track versions of plugins used in a flowchart, and handle using
   either the original versions (for reproducibility) or other
   versions.
#. To add the dashboard as the principal user interface for the jobs
   database.
#. To simplify and streamline the submission of jobs, and have them
   automatically entered in the job database.
#. To build on the first phase of the MOPAC validation use case to
   improve the overall functionality of SEAMM and of the MOPAC plugin
   specifically to simplify such use cases and make more robust.
#. To build on the first phase of the fluid properties use case to
   more completely automate the workflow and to add other properties.
   
Tasks
-----
1. General improvements to installation and usability
#. Switch to the new Molsystem_ object for storing the molecular
   system in SEAMM, moving it to the user space in the process.
#. Finalize the design for and implement the forcefield plugins, along
   with a cookiecutter for forcefield plugins.
#. Develop the `SEAMM Dashboard`_, building on the prototype currently
   in place.
#. Add support for having different versions of plugins, with
   flowcharts able to use specific versions.
#. Improve the job submission process, and integrate it with the
   dashboard.
#. Continue to develop the :ref:`2020_mopac_use_case`, improving SEAMM
   in the process
#. Continue to develop the :ref:`2020_fluids_use_case`, improving SEAMM
   in the process

Results and Discussion
----------------------

.. toctree::
   :titlesonly:

   general_improvements
   molecular_system
   forcefield_plugins
   dashboard
   versions
   job_submission
   mopac_use_case
   fluids_use_case


.. _Molsystem: https://github.com/molssi-seamm/molsystem
.. _SEAMM Dashboard: https://github.com/molssi-seamm/seamm_dashboard
