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
      The implementation of a step, comprised of a GUI for setting the
      control values for the step, a container to hold the control
      values, and finally the implementation of the functionality of
      the step.

   job
      Execution of a single flowchart. This definition stands in
      contrast with the common  meaning of job as a unit of work
      submitted to a queue for execution. The SEAMM documentation will
      use “batch job” to refer to this second type unless it is clear
      from the context. A flowchart can be run as a single batch job,
      or may result in many batch jobs for individual tasks, or can be
      run directly with no batch job involved.

   task
      A batch process created by a step, often the execution of a
      simulation engine such as LAMMPS, GAMESS, Quantum Espresso,
      etc.

   job datastore
      Is the central place where information about and results of jobs
      are stored -- the flowchart, inputs, and outputs of jobs -- so
      they can be viewed and retrieved later.

   DFT
      Density functional theory is a computational quantum mechanical
      method to approximately solve the Schrödinger equation. DFT is
      very popular because it is simple to use and provides a good
      compromise between cost and accuracy.
    
   dashboard
      The web interface to the Job Datastore and to the jobs that are
      running or have run in the past.

   job manager
      The part of SEAMM that handles running jobs, hiding the messy
      details.

   force-field
      An approximate, parameterized description of the potential energy surface (PES)
      for a system composed of atoms or atom-like entities. A forcefield provides a
      mathematical description of the PES as a function of the coordinates of the atoms,
      using parameters to fit the physical PES. Typically a forcefield is composed of a
      functional form -- Lennard-Jones potentials for the non-bonded (van der Waals)
      interactions between atoms; harmonic or quartic or Morse potentials to describe
      bonds, etc. -- and the parameters for specific interactions, such as the
      Lennard-Jones parameters :math:`\epsilon` (well depth) and :math:`\sigma`
      (particle size). A reference such as "AMBER forcefield" can refer to the
      functional form, or to a specific set of parameters, or to the combination of the
      two depending on the context. Usually it is clear from the context which use is
      intended, but sometimes it can be a bit tricky, so be careful.

      See :doc:`whitepapers/forcefields/overview` for a more complete discussion.

   combining rules
      A rule for how to combine the Lennard-Jones-type parameters for single atoms
      into parameters for the interaction between two atoms. Common rules are
      * geometric
      * arithmetic or Lorentz-Bertholet
      * sixth-power or Waldman-Hagler
      Wikipedia has a useful page describing `combining rules
      <https://en.wikipedia.org/wiki/Combining_rules>`_
