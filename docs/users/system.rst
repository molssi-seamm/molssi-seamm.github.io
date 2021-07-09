.. _system:

************************************************
Systems: Molecules, Crystal, Fluids and all that
************************************************

In computational molecular science (CMS) or computational materials science (also CMS!)
we want to examine a system made of atoms. It might be a molecule or several molecules,
a crystalline or amorphous material, a fluid -- or some combination of
them. Unfortunately, we don't have a commonly used, general term to describe such
atomistic systems. "Atomistic system" is a reasonable term, but a bit cumbersome, so in
this documentation we will simply use the term "system" to refer to the collection of
atoms that we are simulating, editing, analyzing or otherwise operating on. This usage
is not too far from the idea of a `thermodynamic system`_::

   A thermodynamic system is a body of matter and/or radiation, confined in space by
   walls, with defined permeabilities, which separate it from its surroundings. The
   surroundings may include other thermodynamic systems, or physical systems that are
   not thermodynamic systems. A wall of a thermodynamic system may be purely notional,
   when it is described as being 'permeable' to all matter, all radiation, and all
   forces. A thermodynamic system can be fully described by a definite set of
   thermodynamic state variables, which always covers both intensive and extensive
   properties.

   --Wikipedia

In our context a system is 0, 1, 2, or 3-dimensional and effectively is infinite,
covering all space. For example, a molecule is usually described as being isolated in a
vacuum, which notionally extends forever. Similarly, a crystal is represented as a 3-D
unit cell, again extended infinitely in all directions so there is no edge to the crystal.

Handling in SEAMM
-----------------
SEAMM provides quite general functionality for handling system, so we need to introduce
some terminology:

System Database
   A database containing all the systems used in a flowchart, stored in the file
   `seamm.db`.

System
   A system, as described above, stored in the system database. Systems can be accessed
   by index (1,2, ...) or by a unique name. A system consists of one more configurations
   (next).

Configuration
   A specific configuration or conformer of a system. The configuration contains the
   coordinates of the atoms, and for periodic system the cell dimensions. Different
   configurations of a system may have different bonds in order to support e.g. reactive
   forcefields such as ReaxFF. Configurations may also have different atoms in order to
   support e.g. grand canonical ensembles.

The configuration corresponds to what most programs think of as the molecule or
crystal. It has atoms, coordinates, and other parameters such as forcefield atom types
needed for simulations.

A system contains configurations. There is not much you can do with a system that has no
configurations, other than create a configuration. However, this concept of a system
containing configurations makes it easy to support e.g. conformational searches where
each conformation is saved as a configuration of the system. A molecular dynamics
trajectory can be thought of as a set of configurations of a system.

When a flowchart starts the system database is empty by default. When you read a
structure or create one using a plug-in, it will give you the option of overwriting the
current configuration, adding a new configuration to the current system, or creating a
new system. If you overwrite the current system or configuration, and the system or
configuration does not exist, they will be automatically created, so you usually needn't
worry about creating a new system. For example, if the first step in your flowchart
reads a structure from a file SEAMM will automatically create a system and configuration
to hold it since by default the system database is empty.

SEAMM has the concept of the current system and configuration so you don't need to
specify the system and configuration all the time. Typically the current system and
configuration are the last ones you created, although plug-ins may allow you to change
the default system or configuration, or temporarily override the default. The `System
Step`_ lets you create and copy systems and configurations, change which are the
default, etc.

This approach, which may seem a bit complicated at first, makes it easy to handle
multiple systems or conformers. For example, if you flowchart loops over a number of
structures in different files you can choose to overwrite the previous one, in which
case there will only be one system with one configuration. However you can choose to read
each structure into a new system, allowing you to compare them or quickly switch.

The `Loop Step`_ can loop over structures or configurations, so if you have loaded a
number of structures, or started a flowchart using an existing system database, it is
easy to process all the structures.

.. _thermodynamic system: https://en.wikipedia.org/wiki/Thermodynamic_system
.. _System Step: https://molssi-seamm.github.io/system_step/index.html
.. _Loop Step: https://molssi-seamm.github.io/loop_step/index.html
