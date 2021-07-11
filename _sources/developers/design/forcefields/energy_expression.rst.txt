*****************
Energy Expression
*****************

In general the forcefield plug-in should combine the forcefield parameters and the
structure to create an energy expression in the general data structures that SEAMM
provides. This may not be possible in all cases, in which case the plug-in should create
the description for the simulation codes it is compatible with.

The advantage of using the structures in SEAMM for the energy expression is that any
plug-in can use the energy expression to calculate the energy, forces, etc. for the
system by translating the generic energy expression to the form needed by a specific
simulation code as long as the simulation code is capable of handling the functional
form of the forcefield.

.. todo::
   We need to add metadata to say whether the plug-in can create the general SEAMM
   energy expression as well as any code-specific implementations, such as the `AMBER
   parameter/topology file <https://ambermd.org/FileFormats.php#topology>`_.

Assuming that the plug-in can create the generic SEAMM energy epxression, the class
needs to provide a method `energy_expression` that creates the energy expression. See
`/XXXX`_ for the documentation of the energy expression within SEAMM.

.. todo::
   We need to bite the bullet and document the energy expression class and perhaps data
   structure, though perhaps it is wiser to hide the implementation using the class to
   access the underlying data.

   If we want to store energy expressions, or think that they might be too large for
   memory, perhaps we should explore on-disk storage such as MDF5 or SQLite.
