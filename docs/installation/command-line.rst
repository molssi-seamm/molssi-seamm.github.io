.. _`command line installation`:

*************************
Command Line Installation
*************************


SEAMM should be installed in the **seamm** conda environment. Open a terminal 
and run the following commands::

  conda create -n seamm -c conda-forge seamm seamm-installer

Once the environment is in place, you can activate it as prompted::

  conda activate seamm

You can choose a different name for your SEAMM environment by replacing
the ``<name>`` argument in the ``-n <name>`` option with your preferred title.

To start, let's find what is already installed and which plug-ins are available::

  % seamm-installer --nw show

  Finding all the packages that make up SEAMM. This may take several minutes.
  ..................................................................................................................................................
  Wrote the package database to /Users/psaxe/Library/Application Support/seamm-installer/downloads.json.

  Showing the modules in SEAMM:
  ...........................
  Core modules of SEAMM
  ╒══════════╤═══════════════════╤═════════════╤═════════════╤═════════════════════════════════════════════════╕
  │   Number │ Component         │ Installed   │ Available   │ Description                                     │
  ╞══════════╪═══════════════════╪═════════════╪═════════════╪═════════════════════════════════════════════════╡
  │        1 │ *seamm-dashboard  │ --          │ 2022.3.30   │ The Web Dashboard for SEAMM (Simulation         │
  │          │                   │             │             │ Environment for Atomistic and Molecular         │
  │          │                   │             │             │ Simulations).                                   │
  ├──────────┼───────────────────┼─────────────┼─────────────┼─────────────────────────────────────────────────┤
  │        2 │ *seamm-jobserver  │ --          │ 2022.6.9    │ seamm_jobserver                                 │
  ├──────────┼───────────────────┼─────────────┼─────────────┼─────────────────────────────────────────────────┤
  │        3 │ molsystem         │ 2022.7.24   │ 2022.7.24   │ molsystem                                       │
  ├──────────┼───────────────────┼─────────────┼─────────────┼─────────────────────────────────────────────────┤
  │        4 │ reference-handler │ 0.9.1       │ 0.9.1       │ no description given                            │
  ├──────────┼───────────────────┼─────────────┼─────────────┼─────────────────────────────────────────────────┤
  │        5 │ seamm             │ 2022.7.25   │ 2022.7.25   │ The core of the SEAMM environment and graphical │
  │          │                   │             │             │ interface.                                      │
  ├──────────┼───────────────────┼─────────────┼─────────────┼─────────────────────────────────────────────────┤
  │        6 │ seamm-datastore   │ 2022.6.28   │ 2022.6.28   │ seamm_datastore                                 │
  ├──────────┼───────────────────┼─────────────┼─────────────┼─────────────────────────────────────────────────┤
  │        7 │ seamm-ff-util     │ 2022.5.29   │ 2022.5.29   │ seamm_ff_util                                   │
  ├──────────┼───────────────────┼─────────────┼─────────────┼─────────────────────────────────────────────────┤
  │        8 │ seamm-installer   │ 2022.7.29.1 │ 2022.7.29.1 │ The installer/updater for SEAMM (Simulation     │
  │          │                   │             │             │ Environment for Atomistic and Molecular         │
  │          │                   │             │             │ Simulations).                                   │
  ├──────────┼───────────────────┼─────────────┼─────────────┼─────────────────────────────────────────────────┤
  │        9 │ seamm-util        │ 2022.7.24   │ 2022.7.24   │ seamm_util                                      │
  ├──────────┼───────────────────┼─────────────┼─────────────┼─────────────────────────────────────────────────┤
  │       10 │ seamm-widgets     │ 2022.7.29   │ 2022.7.29   │ seamm_widgets                                   │
  ╘══════════╧═══════════════════╧═════════════╧═════════════╧═════════════════════════════════════════════════╛

  MolSSI plug-ins
  ╒══════════╤══════════════════════════╤═════════════╤═════════════╤════════════════════════════════════════════════════╕
  │   Number │ Plug-in                  │ Installed   │ Available   │ Description                                        │
  ╞══════════╪══════════════════════════╪═════════════╪═════════════╪════════════════════════════════════════════════════╡
  │        1 │ *control-parameters-step │ --          │ 2022.6.6    │ A SEAMM plug-in for defining command-line          │
  │          │                          │             │             │ parameters for a flowchart.                        │
  ├──────────┼──────────────────────────┼─────────────┼─────────────┼────────────────────────────────────────────────────┤
  │        2 │ *crystal-builder-step    │ --          │ 2022.7.31   │ A SEAMM plug-in for creating crystals from         │
  │          │                          │             │             │ prototypes, including Strukturbericht              │
  │          │                          │             │             │ designations.                                      │
  ├──────────┼──────────────────────────┼─────────────┼─────────────┼────────────────────────────────────────────────────┤
  │        3 │ *custom-step             │ --          │ 2021.11.27  │ A SEAMM plug-in for custom Python scripts in a     │
  │          │                          │             │             │ flowchart.                                         │
  ├──────────┼──────────────────────────┼─────────────┼─────────────┼────────────────────────────────────────────────────┤
  │        4 │ *dftbplus-step           │ --          │ 2022.7.24   │ A SEAMM plug-in for DFTB+, a fast quantum          │
  │          │                          │             │             │ mechanical simulation code.                        │
  ├──────────┼──────────────────────────┼─────────────┼─────────────┼────────────────────────────────────────────────────┤
  │        5 │ *forcefield-step         │ --          │ 2022.5.29   │ A SEAMM plug-in for setting up a forcefield or EAM │
  │          │                          │             │             │ potentials for subsequent simulations.             │
  ├──────────┼──────────────────────────┼─────────────┼─────────────┼────────────────────────────────────────────────────┤
  │        6 │ *from-smiles-step        │ --          │ 2021.10.13  │ A SEAMM plug-in for creating structures from a     │
  │          │                          │             │             │ SMILES string.                                     │
  ├──────────┼──────────────────────────┼─────────────┼─────────────┼────────────────────────────────────────────────────┤
  │        7 │ *lammps-step             │ --          │ 2022.5.31   │ A SEAMM plug-in for LAMMPS, a forcefield-based     │
  │          │                          │             │             │ molecular dynamics code.                           │
  ├──────────┼──────────────────────────┼─────────────┼─────────────┼────────────────────────────────────────────────────┤
  │        8 │ *loop-step               │ --          │ 2022.1.16   │ A SEAMM plug-in which provides loops in            │
  │          │                          │             │             │ flowcharts.                                        │
  ├──────────┼──────────────────────────┼─────────────┼─────────────┼────────────────────────────────────────────────────┤
  │        9 │ *mopac-step              │ --          │ 2022.5.23   │ A SEAMM plug-in to setup, run and analyze          │
  │          │                          │             │             │ semiempirical calculations with MOPAC              │
  ├──────────┼──────────────────────────┼─────────────┼─────────────┼────────────────────────────────────────────────────┤
  │       10 │ *packmol-step            │ --          │ 2022.5.31   │ A SEAMM plug-in for building periodic boxes of     │
  │          │                          │             │             │ fluid using Packmol                                │
  ├──────────┼──────────────────────────┼─────────────┼─────────────┼────────────────────────────────────────────────────┤
  │       11 │ *psi4-step               │ --          │ 2021.10.13  │ A SEAMM plug-in to setup, run and analyze quantum  │
  │          │                          │             │             │ chemistry calculations using Psi4                  │
  ├──────────┼──────────────────────────┼─────────────┼─────────────┼────────────────────────────────────────────────────┤
  │       12 │ *rdkit-step              │ --          │ 2022.1.11.1 │ A SEAMM plugin for A SEAMM plug-in for RDKit       │
  ├──────────┼──────────────────────────┼─────────────┼─────────────┼────────────────────────────────────────────────────┤
  │       13 │ *read-structure-step     │ --          │ 2022.7.20   │ A SEAMM plug-in to read common formats in          │
  │          │                          │             │             │ computational chemistry                            │
  ├──────────┼──────────────────────────┼─────────────┼─────────────┼────────────────────────────────────────────────────┤
  │       14 │ *set-cell-step           │ --          │ 2021.10.14  │ A SEAMM plug-in for setting the periodic (unit)    │
  │          │                          │             │             │ cell.                                              │
  ├──────────┼──────────────────────────┼─────────────┼─────────────┼────────────────────────────────────────────────────┤
  │       15 │ *supercell-step          │ --          │ 2021.10.14  │ A SEAMM plug-in for building supercells of         │
  │          │                          │             │             │ periodic systems.                                  │
  ├──────────┼──────────────────────────┼─────────────┼─────────────┼────────────────────────────────────────────────────┤
  │       16 │ *table-step              │ --          │ 2021.12.22  │ A SEAMM plug-in for data tables in a flowchart.    │
  ╘══════════╧══════════════════════════╧═════════════╧═════════════╧════════════════════════════════════════════════════╛

  3rd-party plug-ins
  ╒══════════╤══════════════╤═════════════╤═════════════╤═══════════════════════════════════════════════════╕
  │   Number │ Plug-in      │ Installed   │ Available   │ Description                                       │
  ╞══════════╪══════════════╪═════════════╪═════════════╪═══════════════════════════════════════════════════╡
  │        1 │ *pyxtal-step │ --          │ 2021.7.29   │ A SEAMM plugin for PyXtal for building atomic and │
  │          │              │             │             │ molecular crystals.                               │
  ╘══════════╧══════════════╧═════════════╧═════════════╧═══════════════════════════════════════════════════╛
  * indicates the component is not up-to-date.

All of the core modules of SEAMM other than the Dashboard and JobServer were installed
when you created the environment, and are up-to-date. None of the plug-ins have been
installed yet.

.. note::
   You can always get help on the command line by using the ``--help`` (or ``-h``)
   option::

     % seamm-installer --nw --help

     usage: seamm-installer [-h] [--log-level {NOTSET,DEBUG,INFO,WARNING,ERROR,CRITICAL}] [--development] [-n] [--root ROOT]
			    {refresh-cache,datastore,install,show,uninstall,update,apps,services} ...

     positional arguments:
       {refresh-cache,datastore,install,show,uninstall,update,apps,services}

     optional arguments:
       -h, --help            show this help message and exit
       --log-level {NOTSET,DEBUG,INFO,WARNING,ERROR,CRITICAL}
			     The level of informational output, defaults to 'WARNING'
       --development         Work with the development environment, not the production one.
       -n, --nw              No GUI, just commandline.
       --root ROOT

   If you want help on e.g. installation, put the ``--help`` after the ``install``
   keyword::

       seamm-installer --nw install --help
    
Installing SEAMM and Plug-ins
-----------------------------

Now run the SEAMM Installer to install both the SEAMM environment and the available
plug-ins::

  seamm-installer --nw install --all

This will install all of SEAMM plus all the plug-ins created by the MolSSI. If you wish
to install all 3rd party plug-ins as well, add the ``--third-party`` flag::

  seamm-installer --nw install --all --third-party

If you need more control, you can also list the names of the plug-ins to install on the
command line. For example::

  seamm-installer --nw install from-smiles-step mopac-step

Depending on your internet connection, computer, and the plug-ins selected, the
installation can take up to 10 or 20 minutes.  This is because many of the plug-ins also
install additional software such as LAMMPS, Psi4, Packmol, and DFTB+, and some of these
packages are quite large and take time to install.

After the Installer finishes, you can check on the created environments using the
following command::

  conda info -e

which generates output like this::

  # conda environments:
  #
  base                     /Users/tester/opt/miniconda3
  seamm                 *  /Users/tester/opt/miniconda3/envs/seamm
  seamm-dftbplus           /Users/tester/opt/miniconda3/envs/seamm-dftbplus
  seamm-lammps             /Users/tester/opt/miniconda3/envs/seamm-lammps
  seamm-packmol            /Users/tester/opt/miniconda3/envs/seamm-packmol
  seamm-psi4               /Users/tester/opt/miniconda3/envs/seamm-psi4

The extra software needed by individual plug-ins is installed in separate conda
environments to avoid conflicts between packages.

You can start the SEAMM GIUI from the command line by typing::

  seamm

Naturally this will only work if you have a windowing system installed so that you can
use graphics on the machine.

Installing Shortcuts
--------------------
Even though you are installing from the command line, you can create shortcuts to
make it easier to start SEAMM if you are using a windowing system::

  seamm-installer --nw apps create

will create the shortcuts and::

  % seamm-installer --nw apps show

  ╒═════════════════╤════════════════════════════════════╕
  │ App             │ Path                               │
  ╞═════════════════╪════════════════════════════════════╡
  │ SEAMM           │ ~/Applications/SEAMM.app           │
  ├─────────────────┼────────────────────────────────────┤
  │ SEAMM-Installer │ ~/Applications/SEAMM-Installer.app │


will show you where the created shortcuts are. Depending on your windowing system,
you can drag the shortcuts to the desktop, launcher, or dock so that you can easily
start SEAMM and the Installer.

Installing the Services
-----------------------

If you plan to run jobs on the machine, you should install the services for the
Dashboard and JobServer, so that they remain running even when you are not logged in. To
do so use the following command::

  % seamm-installer --nw services create

  Created and started the service dashboard
  Created and started the service jobserver

To check on the status of the services::

  % seamm-installer --nw services status
  
  ╒═══════════╤══════════╤═════════╤════════╕
  │ Service   │ Status   │ Root    │ Port   │
  ╞═══════════╪══════════╪═════════╪════════╡
  │ dashboard │ running  │ ~/SEAMM │ 55055  │
  ├───────────┼──────────┼─────────┼────────┤
  │ jobserver │ running  │ ~/SEAMM │ ---    │
  ╘═══════════╧══════════╧═════════╧════════╛

This shows that both services are running and that you can access the Dashboard at port
55055 (the default).


