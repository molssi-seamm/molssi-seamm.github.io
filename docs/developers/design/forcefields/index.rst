.. _forcefields:

********************************************************
Handling Forcefields and Interatomic Potentials in SEAMM
********************************************************

This section provides guidance for implementing a new forcefield or interatomic
potential in SEAMM as well as for implementing a forcefield-based code.  If you need a
refressher about forcefields, or need to understand the terms used in this documentation
to refer apects of forcefields, please see this section in the user manual
:doc:`../../../users/forcefields/overview` for an introduction. As noted there, forcefields and
interatomic potentials are essentially the same thing, so we will tend to use the term
'forcefield' throughout.

In order to use a forcefield in a simulation the following steps are needed in general:

#. The user selects the forcefield or interatomic potentials to use.
#. The system is 'atom typed', i.e. atom types are associated with each relevant atom in
   the system.
#. The energy expression for the system is created and passed to the simulation code
   along with the system itself.

Occasionally the second step, atom typing, is not needed

.. toctree::
    :maxdepth: 4
    :hidden:


    
