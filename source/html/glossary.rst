********
Glossary
********

.. glossary::
   :sorted:
      
   flowchart
      A graphical representation of a multistep simulation protocol.

   step
      A step in a flowchart, represented visually by a box with lines
      connecting it to other steps. Steps are implemented by
      plug-ins.

   plug-in
      The implementation of a step, comprised of a GUI for setting the
      control values for the step, a container to hold the control
      values, and finally the implementation of the functionality of
      the step.

   job
      Execution of a single flowchart. Job is also widely used as the
      unit of work submitted for execution to e.g. a queueing system
      on a computer, which can be confusing. The SEAMM documentation
      will use “batch job” to refer to this second type unless it is
      clear from the context. A flowchart may be executed directly
      with no batch job, as a single batch job, or may result in many
      batch jobs for individual tasks.

   task
      A batch process created by a step, often the execution of a
      simulation engine such as LAMMPS, GAMESS, Quantum Espresso,
      etc. A step need not create tasks, or may create more than one
      task. SEAMM may run tasks directly, or it may submit them as
      batch jobs to a queueing system.

   job datastore
      A database for storing the flowchart, inputs and outputs for
      jobs. The implementation of the datastore may use a traditional
      database, or files on disk, or a combination of a database and
      files, but for practical purposes it appears to be a database.
    
