.. _installation:

****************
Installing SEAMM
****************

SEAMM has three parts:

  * SEAMM itself, with the plug-ins you need, in a Python environment;

  * The SEAMM GUI for creating flowcharts, submitting jobs, publishing results etc., and

  * The JobServer, which runs jobs in the background, and the web interface, where you
    monitor jobs, browse the job directories and look at the results.

You can install everything on one machine, in which case you can do everything with
SEAMM on that machine. Alternatively you can install the GUI on one machine -- probably
your personal machine -- and the JobServer and web interface on a server, where your
jobs will run. This is the recommended setup for a group of users, as it allows everyone
to submit jobs to the same server and to follow the progress of all jobs. The easiest
way to get started is to install everything on your personal machine so that you can
test and run small jobs locally. Later, you can install SEAMM on any servers you have
available and use the GUI on your personal computer to submit production jobs to them.

SEAMM is installed with the **SEAMM Manager**, a small tool that creates a Python
environment for SEAMM, installs SEAMM and its plug-ins from PyPI, keeps them up to date,
and sets up the desktop shortcuts and background services. It uses `uv`_, a fast
Python package manager that also supplies Python itself, so you do not need Python or
conda to install SEAMM. The plug-ins for external codes such as MOPAC, Psi4, LAMMPS and
DFTB+ install those codes with conda, so you only need conda if you want one of them on
the machine. :ref:`seamm-manager-installation` walks you through it.

SEAMM can also be run with *Docker*, which packages SEAMM and the codes into
self-contained containers. The Docker images are less well tested than the SEAMM
Manager installation at the moment; see :ref:`docker`.

.. note::
   Earlier versions of SEAMM were installed into a conda environment with the *SEAMM
   Installer* (``seamm-installer``). Such installations keep working but no longer
   receive updates. :ref:`migrating-from-seamm-installer` explains how to move to the
   SEAMM Manager.

.. Note::
   When you set up the web interface on a server, change the password of the ``admin``
   account. :ref:`dashboard-management` will walk you through this.


.. Table of contents
.. toctree::
    :maxdepth: 5
    :titlesonly:
    :hidden:

    seamm-manager
    docker
    dashboard_management

.. _uv: https://docs.astral.sh/uv/
