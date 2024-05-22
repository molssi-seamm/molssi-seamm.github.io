:html_theme.sidebar_secondary.remove:

.. _`command line installation`:

*************************
Command Line Installation
*************************


SEAMM should be installed in the **seamm** conda environment. Download
:download:`seamm.yml <./seamm.yml>` and save it in a known location. Then open a
terminal window and run the following commands::

  conda env create --file <path to seamm.yml>

Once the environment is in place, activate it::

  conda activate seamm

To start, let's find what is already installed and which plug-ins are available::

  % seamm-installer show

  Showing the modules in SEAMM:
  ......................................
  Core modules of SEAMM
  ╒══════════╤═══════════════════╤═════════════╤═════════════╤═════════════════════════════════════════════════╕
  │   Number │ Component         │ Installed   │ Available   │ Description                                     │
  ╞══════════╪═══════════════════╪═════════════╪═════════════╪═════════════════════════════════════════════════╡
  │        1 │ molsystem         │ 2024.5.8    │ 2024.5.8    │ molsystem                                       │
  ├──────────┼───────────────────┼─────────────┼─────────────┼─────────────────────────────────────────────────┤
  │        2 │ reference-handler │ 0.9.1       │ 0.9.1       │ no description given                            │
  ├──────────┼───────────────────┼─────────────┼─────────────┼─────────────────────────────────────────────────┤
  │        3 │ seamm             │ 2024.5.3.1  │ 2024.5.3.1  │ The core of the SEAMM environment and graphical │
  │          │                   │             │             │ interface.                                      │
  ├──────────┼───────────────────┼─────────────┼─────────────┼─────────────────────────────────────────────────┤
  │        4 │ seamm-dashboard   │ 2024.3.27   │ 2024.3.27   │ The Web Dashboard for SEAMM (Simulation         │
  │          │                   │             │             │ Environment for Atomistic and Molecular         │
  │          │                   │             │             │ Simulations).                                   │
  ├──────────┼───────────────────┼─────────────┼─────────────┼─────────────────────────────────────────────────┤
  │        5 │ seamm-datastore   │ 2024.3.13   │ 2024.3.13   │ seamm_datastore                                 │
  ├──────────┼───────────────────┼─────────────┼─────────────┼─────────────────────────────────────────────────┤
  │        6 │ seamm-exec        │ 2024.4.25.3 │ 2024.4.25.3 │ Classes to execute background codes for SEAMM   │
  ├──────────┼───────────────────┼─────────────┼─────────────┼─────────────────────────────────────────────────┤
  │        7 │ seamm-ff-util     │ 2023.8.27   │ 2023.8.27   │ seamm_ff_util                                   │
  ├──────────┼───────────────────┼─────────────┼─────────────┼─────────────────────────────────────────────────┤
  │        8 │ seamm-installer   │ 2024.4.22   │ 2024.4.22   │ The installer/updater for SEAMM (Simulation     │
  │          │                   │             │             │ Environment for Atomistic and Molecular         │
  │          │                   │             │             │ Simulations).                                   │
  ├──────────┼───────────────────┼─────────────┼─────────────┼─────────────────────────────────────────────────┤
  │        9 │ seamm-jobserver   │ 2024.3.12   │ 2024.3.12   │ The JobServer for the SEAMM environment.        │
  ├──────────┼───────────────────┼─────────────┼─────────────┼─────────────────────────────────────────────────┤
  │       10 │ seamm-util        │ 2024.4.30   │ 2024.4.30   │ seamm_util                                      │
  ├──────────┼───────────────────┼─────────────┼─────────────┼─────────────────────────────────────────────────┤
  │       11 │ seamm-widgets     │ 2024.5.1    │ 2024.5.1    │ seamm_widgets                                   │
  ╘══════════╧═══════════════════╧═════════════╧═════════════╧═════════════════════════════════════════════════╛

  MolSSI plug-ins
  ╒══════════╤════════════════════════════╤═════════════╤═════════════╤════════════════════════════════════════════════════╕
  │   Number │ Plug-in                    │ Installed   │ Available   │ Description                                        │
  ╞══════════╪════════════════════════════╪═════════════╪═════════════╪════════════════════════════════════════════════════╡
  │        1 │ *control-parameters-step   │ --          │ 2023.11.15  │ A SEAMM plug-in for defining command-line          │
  │          │                            │             │             │ parameters for a flowchart.                        │
  ├──────────┼────────────────────────────┼─────────────┼─────────────┼────────────────────────────────────────────────────┤
  │        2 │ *crystal-builder-step      │ --          │ 2022.7.31   │ A SEAMM plug-in for creating crystals from         │
  │          │                            │             │             │ prototypes, including Strukturbericht              │
  │          │                            │             │             │ designations.                                      │
  ├──────────┼────────────────────────────┼─────────────┼─────────────┼────────────────────────────────────────────────────┤
  │        3 │ *custom-step               │ --          │ 2023.12.12  │ A SEAMM plug-in for custom Python scripts in a     │
  │          │                            │             │             │ flowchart.                                         │
  ├──────────┼────────────────────────────┼─────────────┼─────────────┼────────────────────────────────────────────────────┤
  │        4 │ *dftbplus-step             │ --          │ 2024.4.24   │ A SEAMM plug-in for DFTB+, a fast quantum          │
  │          │                            │             │             │ mechanical simulation code.                        │
  ├──────────┼────────────────────────────┼─────────────┼─────────────┼────────────────────────────────────────────────────┤
  │        5 │ *diffusivity-step          │ --          │ 2023.9.4    │ A SEAMM plug-in for Diffusivity                    │
  ├──────────┼────────────────────────────┼─────────────┼─────────────┼────────────────────────────────────────────────────┤
  │        6 │ *fhi-aims-step             │ --          │ 2024.1.19   │ A SEAMM plug-in for FHI-aims                       │
  ├──────────┼────────────────────────────┼─────────────┼─────────────┼────────────────────────────────────────────────────┤
  │        7 │ *forcefield-step           │ --          │ 2024.1.10   │ A SEAMM plug-in for setting up a forcefield or EAM │
  │          │                            │             │             │ potentials for subsequent simulations.             │
  ├──────────┼────────────────────────────┼─────────────┼─────────────┼────────────────────────────────────────────────────┤
  │        8 │ *from-smiles-step          │ --          │ 2023.11.10  │ A SEAMM plug-in for creating structures from a     │
  │          │                            │             │             │ SMILES string.                                     │
  ├──────────┼────────────────────────────┼─────────────┼─────────────┼────────────────────────────────────────────────────┤
  │        9 │ *gaussian-step             │ --          │ 2024.5.8    │ A SEAMM plugin for A SEAMM plug-in for Gaussian    │
  ├──────────┼────────────────────────────┼─────────────┼─────────────┼────────────────────────────────────────────────────┤
  │       10 │ *geometry-analysis-step    │ --          │ 2023.1.14   │ A SEAMM plug-in for analysis of the geometry of    │
  │          │                            │             │             │ particularly small molecules                       │
  ├──────────┼────────────────────────────┼─────────────┼─────────────┼────────────────────────────────────────────────────┤
  │       11 │ *lammps-step               │ --          │ 2024.3.22   │ A SEAMM plug-in for LAMMPS, a forcefield-based     │
  │          │                            │             │             │ molecular dynamics code.                           │
  ├──────────┼────────────────────────────┼─────────────┼─────────────┼────────────────────────────────────────────────────┤
  │       12 │ *loop-step                 │ --          │ 2023.11.9   │ A SEAMM plug-in which provides loops in            │
  │          │                            │             │             │ flowcharts.                                        │
  ├──────────┼────────────────────────────┼─────────────┼─────────────┼────────────────────────────────────────────────────┤
  │       13 │ *mopac-step                │ --          │ 2024.5.14.2 │ A SEAMM plug-in to setup, run and analyze          │
  │          │                            │             │             │ semiempirical calculations with MOPAC              │
  ├──────────┼────────────────────────────┼─────────────┼─────────────┼────────────────────────────────────────────────────┤
  │       14 │ *packmol-step              │ --          │ 2024.3.20.2 │ A SEAMM plug-in for building periodic boxes of     │
  │          │                            │             │             │ fluid using Packmol                                │
  ├──────────┼────────────────────────────┼─────────────┼─────────────┼────────────────────────────────────────────────────┤
  │       15 │ *properties-step           │ --          │ 2023.7.31   │ A SEAMM plug-in for Properties                     │
  ├──────────┼────────────────────────────┼─────────────┼─────────────┼────────────────────────────────────────────────────┤
  │       16 │ *psi4-step                 │ --          │ 2024.3.17   │ A SEAMM plug-in to setup, run and analyze quantum  │
  │          │                            │             │             │ chemistry calculations using Psi4                  │
  ├──────────┼────────────────────────────┼─────────────┼─────────────┼────────────────────────────────────────────────────┤
  │       17 │ *qcarchive-step            │ --          │ 2023.3.30   │ A SEAMM plug-in for QCArchive                      │
  ├──────────┼────────────────────────────┼─────────────┼─────────────┼────────────────────────────────────────────────────┤
  │       18 │ *quickmin-step             │ --          │ 2024.5.7    │ A SEAMM plug-in for simple, quick minimization     │
  ├──────────┼────────────────────────────┼─────────────┼─────────────┼────────────────────────────────────────────────────┤
  │       19 │ *rdkit-step                │ --          │ 2023.2.22   │ A SEAMM plugin for A SEAMM plug-in for RDKit       │
  ├──────────┼────────────────────────────┼─────────────┼─────────────┼────────────────────────────────────────────────────┤
  │       20 │ *read-structure-step       │ --          │ 2023.11.16  │ A SEAMM plug-in to read common formats in          │
  │          │                            │             │             │ computational chemistry                            │
  ├──────────┼────────────────────────────┼─────────────┼─────────────┼────────────────────────────────────────────────────┤
  │       21 │ *set-cell-step             │ --          │ 2021.10.14  │ A SEAMM plug-in for setting the periodic (unit)    │
  │          │                            │             │             │ cell.                                              │
  ├──────────┼────────────────────────────┼─────────────┼─────────────┼────────────────────────────────────────────────────┤
  │       22 │ *strain-step               │ --          │ 2022.11.7   │ A SEAMM plug-in for straining periodic systems     │
  ├──────────┼────────────────────────────┼─────────────┼─────────────┼────────────────────────────────────────────────────┤
  │       23 │ *supercell-step            │ --          │ 2023.11.5   │ A SEAMM plug-in for building supercells of         │
  │          │                            │             │             │ periodic systems.                                  │
  ├──────────┼────────────────────────────┼─────────────┼─────────────┼────────────────────────────────────────────────────┤
  │       24 │ *table-step                │ --          │ 2023.11.10  │ A SEAMM plug-in for data tables in a flowchart.    │
  ├──────────┼────────────────────────────┼─────────────┼─────────────┼────────────────────────────────────────────────────┤
  │       25 │ *thermal-conductivity-step │ --          │ 2024.3.22   │ A SEAMM plug-in for Thermal Conductivity           │
  ├──────────┼────────────────────────────┼─────────────┼─────────────┼────────────────────────────────────────────────────┤
  │       26 │ *torchani-step             │ --          │ 2024.5.12.1 │ A SEAMM plug-in for TorchANI                       │
  ╘══════════╧════════════════════════════╧═════════════╧═════════════╧════════════════════════════════════════════════════╛

  3rd-party plug-ins
  ╒══════════╤══════════════╤═════════════╤═════════════╤═══════════════════════════════════════════════════╕
  │   Number │ Plug-in      │ Installed   │ Available   │ Description                                       │
  ╞══════════╪══════════════╪═════════════╪═════════════╪═══════════════════════════════════════════════════╡
  │        1 │ *pyxtal-step │ --          │ 2021.7.29   │ A SEAMM plugin for PyXtal for building atomic and │
  │          │              │             │             │ molecular crystals.                               │
  ╘══════════╧══════════════╧═════════════╧═════════════╧═══════════════════════════════════════════════════╛
  * indicates the component is not up-to-date.

All of the core modules of SEAMM were installed when you created the environment, and
are up-to-date. None of the plug-ins have been installed yet.

.. note::
   The plug-ins and versions in the list you get may be different (newer!) than those
   shown above because the documentation is not updated for every change in SEAMM.
       
Installing SEAMM and Plug-ins
-----------------------------

Now run the SEAMM Installer to install both the SEAMM environment and the available
plug-ins::

  seamm-installer install --all

This will install all of SEAMM plus all the plug-ins created by the MolSSI. If you wish
to install all 3rd party plug-ins as well, add the ``--third-party`` flag::

  seamm-installer install --all --third-party

If you need more control, you can also list the names of the plug-ins to install on the
command line. For example::

  seamm-installer install from-smiles-step mopac-step

Depending on your internet connection, computer, and the plug-ins selected, the
installation can take up to 10 or 20 minutes.  This is because many of the plug-ins also
install additional software such as LAMMPS, Psi4, Packmol, and DFTB+, and some of these
packages are quite large and take time to install. 

.. note::
   You can always get help on the command line by using the ``--help`` (or ``-h``)
   option::

     % seamm-installer --help

     usage: seamm-installer [-h] [--version] 
     [--log-level {NOTSET,DEBUG,INFO,WARNING,ERROR,CRITICAL}] [--development] 
     [--root ROOT] {refresh-cache,datastore,install,show,uninstall,update,apps,services} ...
     
     positional arguments:
       {refresh-cache,datastore,install,show,uninstall,update,apps,services}
     
     options:
       -h, --help            show this help message and exit
       --version             show program's version number and exit
       --log-level {NOTSET,DEBUG,INFO,WARNING,ERROR,CRITICAL}
                             The level of informational output, defaults to 'WARNING'
       --development         Work with the development environment, not the production one.
       --root ROOT
     
     If no positional argument is given, the GUI will appear.
     
   If you want help on e.g. installation, put the ``--help`` after the ``install``
   keyword::

       seamm-installer install --help

.. note ::
  You can also install only the packages that are necessary for the GUI if you do not
  intend to run calculations on this machine, but just create flowcharts and submit jobs
  to remote Dashboards::

    seamm-installer install --gui-only --all

After the Installer finishes, you can check on the created environments using the
following command::

  conda info -e

which generates output like this::

  # conda environments:
  #
  base                     /Users/psaxe/miniconda3
  seamm                    /Users/psaxe/miniconda3/envs/seamm
  seamm-dev                /Users/psaxe/miniconda3/envs/seamm-dev
  seamm-dftbplus           /Users/psaxe/miniconda3/envs/seamm-dftbplus
  seamm-lammps             /Users/psaxe/miniconda3/envs/seamm-lammps
  seamm-mopac              /Users/psaxe/miniconda3/envs/seamm-mopac
  seamm-packmol            /Users/psaxe/miniconda3/envs/seamm-packmol
  seamm-psi4               /Users/psaxe/miniconda3/envs/seamm-psi4
  seamm-torchani           /Users/psaxe/miniconda3/envs/seamm-torchani

The extra software needed by individual plug-ins is installed in separate conda
environments to avoid conflicts between packages.

You can start the SEAMM GUI from the command line by typing::

  seamm

Naturally this will only work if you have a windowing system installed so that you can
use graphics on the machine.

Installing Shortcuts
--------------------
Even though you are installing from the command line, you can create shortcuts to
make it easier to start SEAMM if you are using a windowing system::

  seamm-installer apps create

will create the shortcuts and::

  % seamm-installer apps show

  ╒═════════════════╤════════════════════════════════════╕
  │ App             │ Path                               │
  ╞═════════════════╪════════════════════════════════════╡
  │ SEAMM           │ ~/Applications/SEAMM.app           │
  ├─────────────────┼────────────────────────────────────┤
  │ SEAMM-Installer │ ~/Applications/SEAMM-Installer.app │
  ╘═════════════════╧════════════════════════════════════╛

will show you where the created shortcuts are. Depending on your windowing system,
you can drag the shortcuts to the desktop, launcher, or dock so that you can easily
start SEAMM and the Installer.

Installing the Services
-----------------------

If you plan to run jobs on the machine, you should install the services for the
Dashboard and JobServer, so that they remain running even when you are not logged in. To
do so use the following command::

  % seamm-installer services create

  Created and started the service dashboard
  Created and started the service jobserver

To check on the status of the services::

  % seamm-installer services status
  
  ╒═══════════╤══════════╤═════════╤════════╕
  │ Service   │ Status   │ Root    │ Port   │
  ╞═══════════╪══════════╪═════════╪════════╡
  │ dashboard │ running  │ ~/SEAMM │ 55055  │
  ├───────────┼──────────┼─────────┼────────┤
  │ jobserver │ running  │ ~/SEAMM │ ---    │
  ╘═══════════╧══════════╧═════════╧════════╛

This shows that both services are running and that you can access the Dashboard at port
55055 (the default).

Congratulations! SEAMM is fully installed and ready to go. The
:doc:`../tutorials/index` is a good place to start.


