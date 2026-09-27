.. _seamm-manager-installation:

************************************
Installing SEAMM with the Manager
************************************

.. attention::
   SEAMM runs on macOS and Linux. On Windows, use the *Windows Subsystem for Linux
   (WSL)*; the installation is identical to that on any Linux system. *Windows 11*
   supports graphical programs in WSL, so the SEAMM GUI works there. *Windows 10* and
   its WSL do not, so on *Windows 10* you can run calculations but not the GUI.

What you need
-------------

**uv.** The SEAMM Manager is installed with `uv`_, a single program with no
dependencies. It also downloads the right version of Python for SEAMM, so you do not
need to install Python yourself. Open a terminal and run::

  curl -LsSf https://astral.sh/uv/install.sh | sh

Then open a new terminal, or run ``source ~/.local/bin/env``, so that ``uv`` is on your
path. No administrator access is needed, so this works in your own account on a cluster
too.

**conda, only for the codes.** SEAMM itself does not use conda. The plug-ins for
external codes -- MOPAC, Psi4, LAMMPS, DFTB+, xTB, Packmol and so on -- each install
their code into a conda environment of its own. If you want to run any of those codes on
this machine, install conda first; we recommend `Miniforge`_. If you only want the GUI,
for instance to submit jobs to a server, you do not need conda at all. If you install a
plug-in whose code needs conda and it is missing, the plug-in's installer tells you, and
you can add conda later and rerun it.

.. note::
   The plug-ins find conda through ``$CONDA_EXE``, the ``PATH`` or the usual
   installation directories (``~/miniforge3``, ``~/miniconda3``, ...), so conda does not
   have to be initialized in your shell.

The SEAMM Manager
-----------------

Install the manager itself as a uv *tool*, in a small environment of its own::

  uv tool install seamm-manager

You can then install SEAMM either with the manager's window, the
:ref:`graphical installation`, or from the terminal, the
:ref:`command line installation`. Both give the same result:

.. code-block:: text

    ~/SEAMM/                 the SEAMM root
    ~/SEAMM/venv/            the Python environment with SEAMM and all plug-ins
    ~/SEAMM/venv-webui/      the web interface's environment (if installed)
    ~/SEAMM/environments/    the lock file and a record of every change
    ~/SEAMM/Jobs/            the jobs and the database of jobs (the datastore)
    ~/SEAMM/*.ini            configuration for SEAMM and each code

The external codes live in conda environments named ``seamm-mopac``, ``seamm-psi4``,
``seamm-lammps``, and so on.

Versions are chosen from a *lock file* that MolSSI publishes nightly: the versions of
SEAMM, every plug-in and every dependency that were resolved and tested together. So
two installations made on the same day are identical, and an update moves you from one
tested set to the next.

.. Table of contents
.. toctree::
    :maxdepth: 5
    :titlesonly:
    :hidden:

    graphical
    command-line
    migrating

.. Link shortcuts and cross-referencing labels
.. _uv: https://docs.astral.sh/uv/
.. _Miniforge: https://github.com/conda-forge/miniforge
