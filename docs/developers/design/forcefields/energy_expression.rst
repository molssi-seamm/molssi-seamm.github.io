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
