.. _software-ecosystem:

******************
Software Ecosystem
******************

SEAMM is comprised of six components:

1. A :ref:`graphical user interface` (GUI) which offers a user-friendly environment for the
   creation and design of flowcharts,
#. A :ref:`Dashboard` which allows a high-level management and monitoring the executed
   jobs in the datastore,
#. A :ref:`flowchart` which contains all information pertinent to the workflows for
   reproducibility,
#. A :ref:`Flowchart Interpreter` responsible for executing the flowchart,
#. A :ref:`Job Manager` for managing :term:`jobs<job>` and executing :term:`tasks<task>`
   via a queueing system, and
#. A :ref:`Job Datastore` storing jobs, flowcharts, inputs, outputs and other intermediate
   software-dependent files.

The following diagram illustrates the flow of data among the aforementioned components in 
the SEAMM software ecosystem.

.. image:: /images/SEAMM\ Components.png
	    :align: center
	    :alt: Software ecosystem

.. toctree::
    :maxdepth: 1
    :titlesonly:
    :hidden:
    
    gui
    dashboard
    flowchart
    flowchart_interpreter
    job_manager
    job_datastore