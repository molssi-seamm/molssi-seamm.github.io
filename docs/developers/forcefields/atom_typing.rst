***********
Atom Typing
***********

Each forcefield plug-in must provide a method to set the atom types for a system,
sotring them in the `atom_types_{forcefield name}` field of the atoms. By default the
main system should be used, but optionally the calling code can pass a handle to the
system it wants typed. If the system cannot be typed successfully, the code should not
change the existing atom type attribute of the atoms for the forcefield, nor should it
create a partial or empty attribute. If there are any errors or it is not possible to
atom type the system, an error should be raised.
