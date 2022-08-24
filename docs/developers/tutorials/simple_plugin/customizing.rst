************************************
Customizing the plug-in to run PySCF
************************************

Let's make a very simple interface, with a choice of a few basis sets and whether to
optimize the structure or not. in `pyscf_parameters.py` replace the parameters section
with this::

    parameters = {
        "basis_set": {
            "default": "321g",
            "kind": "string",
            "default_units": "",
            "enumeration": (
                "sto3g",
                "321g",
                "321g*",
                "631g",
                "631g*",
                "631g**",
            ),
            "format_string": "",
            "description": "Basis set:",
            "help_text": "The basis set for the calculation.",
        },
        "optimize": {
            "default": "yes",
            "kind": "string",
            "default_units": None,
            "enumeration": ("yes", "no"),
            "format_string": "",
            "description": "Optimize structure:",
            "help_text": "Whether to optimize the structure.",
        },
    }

For the moment we don't need to make any changes in the GUI. By default it will present
the parameters as a table. With two parameters that is fine.

The only other thing that we need to change is `pyscf.py` to actually run PySCF when
called. Since we are going to run PySCF directly in the plugin, you need to install
PySCF and the optimizer itself in the **seamm-dev** environment::

  pip install 'pyscf[geometry]'
  pip install -U pyberny

installs what we need.

If you want to understand how to run an energy calculation in PySCF the documentation
has a couple relevant sections: 

* `Creating the geometry, basis set, etc. <https://pyscf.org/user/gto.html>`_
* `Calculating the HF energy <https://pyscf.org/quickstart.html#hartree-fock>`_
* `Optimizing the structure <https://pyscf.org/user/geomopt.html#>`_

How to get the energy from the optimizer is a bit more obscure, but an Internet search
quickly turns up the solution:

* `Getting the energy from an optimization <https://github.com/pyscf/pyscf/issues/798>`_

Now on to what we need to do in the code. In `pyscf.py` you need to import the parts of
PySCF that we need::
  
  import logging
  from pathlib import Path
  import pprint  # noqa: F401

  from pyscf import gto, scf                                   <<< add this
  from pyscf.geomopt.berny_solver import optimize as pyberny   <<< add this

  import pyscf_step
  import seamm

and further down, in the **run** method which is what is called when you run the
flowchart, we need to change the code like this, where the first couple lines and last
couple lines are already in the file along with some temporary printing that you need to
remove::

        # Get the current system and configuration (ignoring the system...)  <<< this is in the file already
        _, configuration = self.get_system_configuration(None)               <<< this is in the file already

        # Get the atoms and prepare the PySCF mol structure
        atoms = []
        if configuration.periodicity == 0:
            for symbol, xyz in zip(
                configuration.atoms.symbols,
                configuration.atoms.get_coordinates(fractionals=False),
            ):
                x, y, z = xyz
                atoms.append([symbol, (x, y, z)])

        mol = gto.Mole()
        mol.output = str(directory / "PySCF.out")
        mol.atom = atoms
        mol.basis = P["basis_set"]
        mol.symmetry = True
        mol.build()

        text = (
            "\n\n"
            f"The molecule has {mol.topgroup} symmetry, the calculation will use "
            f"{mol.groupname} symmetry.\n\n"
        )

        if P["optimize"]:
            # Create callback to run at every geometry opt. iteration
            energies = []

            def cb(envs):
                mc = envs["g_scanner"].base
                energies.append(mc.e_tot)

            opt = pyberny(mol, callback=cb)
            E = energies[-1]
            text += (
                f"With the {P['basis_set']} basis set, the optimization converged in "
                f"{len(energies)} steps to an energy of {E:.6f} E_h"
            )
            configuration.atoms.set_coordinates(opt.atom_coords())
        else:
            mf = scf.RHF(mol)
            E = mf.kernel()
            text += (
                f"The SCF energy of the structure using the {P['basis_set']} "
                f"basis set is {E:.6f} E_h"
            )

        printer.normal(__(text, indent=self.indent + 4 * " "))

        # Analyze the results    <<< this is in the file already
        # self.analyze()         <<< this is in the file already, but comment it out

Note that the `self.analyze` is commented out, since we aren't using it and it prints a
message telling you to update it, which we don't need.

These are all the changes to the code needed to get started. Check the cood and install
it ("compile" it)::

  make lint install test

Hopefully that worked with no problem, but if there were error messages read them and
fix the problems.

The next step is to create a small flowchart and test that your plug-in works!

