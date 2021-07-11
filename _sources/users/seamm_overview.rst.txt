.. _seamm_overview:

*****************
Overview of SEAMM
*****************

What is SEAMM?
--------------
SEAMM is a user-friendly environment for computational molecular and
materials science, using :term:`plug-ins<plug-in>` to provide a wide
range of building, simulation and analysis tools. SEAMM handles the
entire range of atomic, molecular, crystalline, amorphous, and fluid
systems that are described at the level of atoms and electrons.  SEAMM
provides three important capabilities:

* :ref:`productivity`: The computational tools are wrapped with plug-ins that
  adapt them to SEAMM and provide graphical interfaces (GUIs) that help
  you set up calculations without editing complex input files and
  structures by hand.
* :ref:`reproducibility`: Computational protocols are
  captured as shareable graphical :term:`flowcharts<flowchart>`. You
  can create your own, or start with ones created by experts in a
  particular domain, tweaking them to fit your problem.


Getting Oriented
----------------

SEAMM comprises six components:

1. A :ref:`graphical user interface` (GUI) for creating and editing flowcharts.
#. A serializable implementation of a :ref:`flowchart<Flowchart>` that
   contains all of the information needed to run the workflow and to
   reproduce it at a later time.
#. A :ref:`Flowchart Interpreter` that executes the flowchart.
#. A :ref:`Job Manager` to manage :term:`jobs<job>` and run
   :term:`tasks<task>` via a queueing system (in design).
#. A :ref:`Job Datastore` to hold the jobs -- the flowchart, inputs
   and outputs.
#. A :ref:`Dashboard` for managing and viewing the jobs in the
   datastore.

shown in this diagram, which also shows the flow of data between
the components.

.. image:: /images/SEAMM\ Components.png
	    :align: center
	    :alt: Overview of SEAMM
  
Next steps
----------
* :ref:`installation`
* :ref:`using seamm`  

.. toctree::
    :maxdepth: 5
    :titlesonly:
    :hidden:

    productivity
    reproducibility
    seamm_description/gui
    seamm_description/flowchart
    seamm_description/flowchart_interpreter
    seamm_description/job_manager
    seamm_description/job_datastore
    seamm_description/dashboard
    using_seamm/index
