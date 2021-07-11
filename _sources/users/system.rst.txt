.. _system:

************************************************
Systems: Molecules, Crystal, Fluids and all that
************************************************

In computational molecular/materials science (CMS), systems made of atoms are often
investigated. Such systems might consist of one to many molecules in crystalline,
amorphous, or liquid forms or even some combination of them. Unfortunately, we don't 
have a commonly used or general term to describe such atomistic systems. 
"Atomistic system" is a reasonable term but a bit cumbersome. Thus, in this documentation,
we will simply use the term "system" in order to refer to the collection of atoms 
under the study. This usage is not too far from the idea of a `thermodynamic system`_::

   A thermodynamic system is a body of matter and/or radiation, confined in space by
   walls, with defined permeabilities, which separate it from its surroundings. The
   surroundings may include other thermodynamic systems, or physical systems that are
   not thermodynamic systems. A wall of a thermodynamic system may be purely notional,
   when it is described as being 'permeable' to all matter, all radiation, and all
   forces. A thermodynamic system can be fully described by a definite set of
   thermodynamic state variables, which always covers both intensive and extensive
   properties.

   --Wikipedia

In the present context, a system is either 0, 1, 2, or 3-dimensional, and effectively infinite
in size which occupies the entire space. For example, a molecule is usually described as
being isolated in a vacuum which is notionally infinite in size. Similarly, a crystal is
represented as a 3-dimensional unit cell which infinitely extends in all directions.

Handling in SEAMM
-----------------
SEAMM provides general functionalities for handling a system, for which we need to introduce
some terminology:

System Database
   A system database, which contains all systems used in a flowchart, is stored in the file
   `seamm.db`.

System
   Systems are stored in the system database and can be accessed through indices 1, 2, 3, ...
   or a unique name. A system consists of one more configurations.

Configuration
   Configuration contains the coordinates of the atoms or the cell dimensions corresponding to
   specific molecular topologies and conformers, or periodic system, respectively. Various 
   configurations of a system may have distinct bonds in order to support e.g. reactive
   forcefields such as ReaxFF. Configurations may also have different atoms in order to
   support e.g. grand canonical ensembles.

The configuration object corresponds to what most programs refer to as molecules or
crystals. It consists of atomic symbols and coordinates as well as other parameters 
such as forcefield atom types needed for simulations.

A system contains configurations. Therefore, in an empty system, one can only create 
a configuration. However, the concept of a non-empty system makes it easy to support 
operatios such as conformational searches, where each conformation is saved as a configuration of 
the system. Furthermore, a molecular dynamics trajectory can also be thought of as a set of 
configurations of a system.

When a flowchart starts the system database, it is empty by default. Reading or creating 
a structure using a plug-in gives the option of overwriting the current configuration,
adding a new configuration to the current system, or creating a new system. If the current
system or configuration is overwritten (while neither do exist in the first place), they will be 
automatically created. Therefore, there is often no need to create a new system. For example,
if the first step in a flowchart reads a structure from a file, SEAMM will automatically 
create a system and configuration to hold it because the system database is empty by default.

SEAMM has the concept of the current system and configuration. Thus, one does not need to
specify the system and configuration all the time. Typically, the current system and
configuration are the last objects being created. However, plug-ins may provide the user with
the option to change the default system or configuration, or temporarily override the default.
The `System Step`_ also allows the users to create and copy the systems and configurations, modify
or update them etc.

The aforementioned approach, which may seem a bit complicated at first, makes it easy to handle
multiple systems. For example, if a flowchart loops over a number of structures in different files,
one can choose to overwrite the previous one(s), resulting in only
one system with one configuration. However, one can choose to read each structure into a new system,
allowing for comparison or switch among the systems.

The `Loop Step`_ can loop over structures or configurations. Thus, if a number of structures
are loaded or a flowchart is created using an existing system database, it is easy to process
all the structures, simultaneously.

.. _thermodynamic system: https://en.wikipedia.org/wiki/Thermodynamic_system
.. _System Step: https://molssi-seamm.github.io/system_step/index.html
.. _Loop Step: https://molssi-seamm.github.io/loop_step/index.html
