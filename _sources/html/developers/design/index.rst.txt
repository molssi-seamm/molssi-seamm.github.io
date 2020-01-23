.. _design:

*******************
The Design of SEAMM
*******************

SEAMM comprises six components:

1. A :ref:`graphical user interface` (GUI) for creating and editing
   :term:`flowcharts<flowchart>`. 
#. A serializable implementation of a :ref:`flowchart` that contains all of
   the information needed to run the workflow and to reproduce it at a
   later time. 
#. An :ref:`Flowchart Interpreter` that executes the flowchart.
#. A :ref:`Job Manager` to manage :term:`jobs<job>` and run tasks via
   a queueing system (in design). 
#. A :ref:`Job Datastore` to hold the jobs -- the flowchart, inputs
   and outputs.
#. A :ref:`Dashboard` for managing and viewing the jobs in the
   datastore.

shown in this diagram, which also shows the flow of data between
the components.

.. image:: /images/SEAMM\ Components.png
	    :align: center
	    :alt: Overview of SEAMM

.. toctree::
    :maxdepth: 4
    :hidden:

    plug-ins
