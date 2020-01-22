.. _for_users:

*********
For Users
*********

What is SEAMM?
--------------
SEAMM is a user-friendly environment for computational molecular and
materials science, using plug-ins to provide a wide range of building,
simulation and analysis tools. SEAMM handles the entire range of
atomic, molecular, crystalline, amorphous, and fluid systems that are
described at the level of atoms and electrons.  SEAMM provides three
important capabilities:

* :ref:`productivity`: The computational tools are wrapped with plug-ins that
  adapt them to SEAMM and provide graphical interfaces (GUIs) that help
  you set up calculations without editing complex input files and
  structures by hand.
* :ref:`reproducibility`: Computational protocols are
  captured as shareable graphical flowcharts. You can create your own,
  or start with ones created by experts in a particular domain, tweaking
  them to fit your problem.


Getting Oriented
----------------


SEAMM comprises six components:

1. A :ref:`graphical user interface` (GUI) for creating and editing flowcharts.
#. A :ref:`serializable implementation of a flowchart` that contains all of
   the information needed to run the workflow and to reproduce it at a
   later time. 
#. An :ref:`Flowchart Interpreter` that executes the flowchart.
#. A :ref:`Job Manager` to manage jobs and run tasks via a queueing
   system (in design). 
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
    installation/index
    using_seamm/index
    
