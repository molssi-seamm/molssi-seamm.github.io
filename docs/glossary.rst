.. _glossary:

********
Glossary
********

.. glossary::
   :sorted:
      
   flowchart
      A graphical representation of a multi-step simulation
      protocol. See :ref:`flowchart`

   step
      A step in the simulation protocol, typically representing a
      single piece of work. Represented in a flowchart by a box, steps
      are implemented by plug-ins.

   plug-in
      The implementation of a workflow, comprised of a GUI for setting
      the control values for all steps, a container to hold the control
      values, and finally the implementation of the functionality of
      every step.

   job
      Execution of each flowchart which is in contrast to the common 
      meaning of a job as a unit of work submitted to a queue for execution.
      The SEAMM documentation will use **batch job** to refer to latter
      type unless it is clear from the context. A flowchart can be executed
      as a single batch job, may generate many batch jobs for individual
      tasks or can be executed directly with no batch job involved.

   task
      A batch process created by a step, often the execution of a
      simulation engine such as `LAMMPS`, `GAMESS`, `Quantum Espresso`,
      etc.

   job datastore
      is the central place where information about the jobs and their
      corresponding results such as the flowchart, inputs, and outputs
      are stored. This information can be inspected, monitored and queried.

   DFT
      Density functional theory is a quantum mechanical method 
      that is based on the electron density as the central quantity instead of
      wave functions. DFT has become very popular during the past few decades
      because it is simple to use and provides a good compromise between the
      computational cost and accuracy.
    
   dashboard
      The web interface to the Job Datastore responsible for monitoring
      and managing the executed jobs.

   job manager
      The part of SEAMM that handles running jobs.

   force-field
      An approximate, parameterized description of the potential energy surface (PES)
      for a system composed of (quasi-)atoms. A forcefield provides a mathematical
      description of the PES as a function of the coordinates of the atoms, using
      parameters to fit the physical PES. Typically, a forcefield is composed of a
      functional form (such as Lennard-Jones potentials for the non-bonded (van der Waals)
      interactions between atoms, harmonic or quartic or Morse potentials to describe
      bonds, etc.) and the parameters for specific interactions [such as the
      Lennard-Jones parameters :math:`\epsilon` (well depth) and :math:`\sigma`
      (particle size)]. A reference such as **AMBER forcefield** can refer to the
      functional form, to a specific set of parameters or to the combination of the
      two depending on the context.

      See :doc:`whitepapers/forcefields/overview` for a more complete discussion.

   combining rules
      A rule for how to combine the Lennard-Jones-type parameters for single atoms
      into parameters for the interaction between two atoms. Common rules are
      ``geometric``, ``arithmetic`` or ``Lorentz-Bertholet``, ``sixth-power`` or 
      ``Waldman-Hagler``. Wikipedia has a useful page describing `combining rules
      <https://en.wikipedia.org/wiki/Combining_rules>`_.
