.. _design:

*******************
The Design of SEAMM
*******************

SEAMM comprises six components:

1. A :ref:`gui` (GUI) for creating and editing
   :term:`flowcharts<flowchart>`.
#. A serializable implementation of a :ref:`flowchart` that contains all of
   the information needed to run the workflow and to reproduce it at a
   later time. 
#. An :ref:`Flowchart Interpreter` that executes the flowchart.
#. A :ref:`job-manager` to manage :term:`jobs<job>` and run
   :term:`tasks<task>` via a queueing system (in design).
#. A :ref:`job-datastore` to hold the jobs -- the flowchart, inputs
   and outputs.
#. A :ref:`dashboard` for managing and viewing the jobs in the
   datastore.

shown in this diagram, which also shows the flow of data between
the components.

.. image:: /images/SEAMM\ Components.png
	    :align: center
	    :alt: Overview of SEAMM

.. toctree::
    :maxdepth: 2
    :hidden:

    plug-ins
    forcefields/index