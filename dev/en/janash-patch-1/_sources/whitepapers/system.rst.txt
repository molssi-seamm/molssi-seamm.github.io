.. _system:

************************************************
Systems: Molecules, Crystal, Fluids and all that
************************************************

Computational molecular or materials science (CMS) uses computer simulations to study
systems made of atoms, or perhaps of slightly coarser grained models that group together
a handful of atoms into a large object. These systems might consist of one to many
molecules in crystalline, amorphous, or liquid forms or even some combination of
them. Unfortunately, we don't have a commonly used or general term to describe such
atomistic systems.  "Atomistic system" is a reasonable term but a bit cumbersome.  In
this documentation, we will simply use the term "system" to refer to the collection of
atoms being simulated. This usage is not too far from the idea of a `thermodynamic
system`_::

   A thermodynamic system is a body of matter and/or radiation, confined in space by
   walls, with defined permeabilities, which separate it from its surroundings. The
   surroundings may include other thermodynamic systems, or physical systems that are
   not thermodynamic systems. A wall of a thermodynamic system may be purely notional,
   when it is described as being 'permeable' to all matter, all radiation, and all
   forces. A thermodynamic system can be fully described by a definite set of
   thermodynamic state variables, which always covers both intensive and extensive
   properties.

   --Wikipedia

In SEAMM, a system is either 0, 1, 2, or 3-dimensional. A 0-D system is a molecule or
cluster of atoms and molecules with a finite extent, embedded in an infinite vacuum. 1-,
2-, and 3-D systems are periodic in the directions indicated, meaning that a unit cell
is translated to build an infinite model in the given directions. A crystal such as
table salt (NaCl) can be described as a 3-D system composed of face-centered cubic (fcc)
lattice with two atoms in the unit cell. A 3-D system can also be used to describe a box
of fluid, such as a solvent with solute molecules. Treating the fluid as a "crystal" is
an approximation -- a fluid does not have long range order like a crystal does, but as
long as the cell is large enough, the approximation is very good.

Handling in SEAMM
-----------------
SEAMM provides general functionality for handling systemsLet's start with some terminology:

Configuration
   A configuration contains the atoms and their coordinates for a specific molecular
   topology or conformer. For periodic system, the configuration also contains
   information about the unit cell and spacegroup symmetry. The concept of a
   configuration in SEAMM is more general than that of trajectory frames or conformers
   in most programs. To support reactive forcefields such as ReaxFF, configurations can
   have different bonds and to support e.g. grand canonical simulations, configurations
   may also have different numbers of atoms.

System
   A system contains related configurations, providing a way to group related
   configurations, such as conformers or those in an MD trajectory, together.

System Database
   A database of systems, which by default is stored in the file `seamm.db` at the top
   level of a job.

The configuration object corresponds to what most programs refer to as molecules or
crystals. It consists of atomic symbols and coordinates, and for periodic systems the
cell information, as well as other parameters such as forcefield atom types needed for
specific simulations.

When you start a flowchart running, by default the system database is empty. You can
read structures from files or create them on-the-fly with various plug-ins that read or
write structure files, or build structures from scratch. Any plug-in that reads or
creates new structures has options that let you control whether those structures
overwrite the current one, are added as a new configuration to the current system, or
are put in a new system. SEAMM does the "right thing" if there is no system or
configuration and creates what is needed. 

SEAMM has the concept of the current system and configuration, so you usually don't need to
specify the system and configuration for every step of the flowchart. Usially the current system and
configuration are the last ones created. However, plug-ins may provide options to change
the default system or configuration, or temporarily override the default. The `System
Step`_ also allows the users to create and copy the systems and configurations, modify
or update them etc.

This may seem a bit complicated and confusing, but you will soon find that it is easy to
use and handles most cases automatically -- it does the "right thing" without you
worrying. As you get to more complicated simulations and flowcharts you may need to ask
for specific systems and configurations, but as you get started most things will just work.

The `Loop Step`_ can loop over structures or configurations. Thus, if a number of structures
are loaded or a flowchart is created using an existing system database, it is easy to process
all the structures, or a subset of them.

.. _thermodynamic system: https://en.wikipedia.org/wiki/Thermodynamic_system
.. _System Step: https://molssi-seamm.github.io/system_step/index.html
.. _Loop Step: https://molssi-seamm.github.io/loop_step/index.html
