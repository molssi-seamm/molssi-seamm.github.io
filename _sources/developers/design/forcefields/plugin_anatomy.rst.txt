*******************************
Anatomy of a Forcefield Plug-in
*******************************

Namespace
---------

Forcefields advertise themselves to SEAMM in the same way that other plug-ins do;
however, the namespace is different -- `org.molssi.seamm.forcefields` -- as in this
example::

    entry_points={
        'org.molssi.seamm.forcefields': [
            'GAFF = seamm_antechamber:GAFFPlugin',
        ],
    }

The namespace, or entry group in the parlance of the `Python importlib
<https://docs.python.org/3/library/importlib.metadata.html>`_  are listed one or more
forcefields, ``GAFF`` in this example, and a class to load to access the forcefield,
which by convention is the name of the forcefield followed by ``Plugin``.

Plug-in API
-----------
This class is lightweight. It contains a ``description`` method to return metadata about
the forcefield, and a factory method to create the object that handles the forcefield::

    def description(self):
        """Return a description of the forcefield
        """
        return {
	    name: "GAFF",
	    versions: ["1.0"],
	    description: (
	        "GAFF is compatible with the AMBER force field and it has parameters "
		"for almost all the organic molecules made of C, N, O, H, S, P, F, Cl, "
		"Br and I. As a complete force field, GAFF is suitable for study of a "
		"great number of molecules (such as database searching) in an "
		"automatic fashion."
	    ),
	    elements: ["H", "C", "N", "P", "S", "F", "Cl", "Br", "I"],
	    class: ["valence", "all-atom"]
	}

.. todo::
   We need to flesh out the metadata. For instance, should it include the terms
   in the functional form?

The factory method is equally simple::

    def create_atomtyper(self):
        """Create and return the new GAFF forcefield object.

        Parameters
	----------
	None

        Returns
        -------
	GAFF object

        See Also
        --------
        Antechamber

        """
        return seamm_ff_gaff.GAFF()

The SEAMM cookiecutter will create skeletons of this file and the other files needed to
implement a forcefield in SEAMM, so most of this work will be done for you. Of course
you need to give the description of the forcefield.
