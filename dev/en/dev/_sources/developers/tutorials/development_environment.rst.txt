**************************************
Installing the Development Environment
**************************************

SEAMM provides a lot of help for developing with the SEAMM environment, but expects a
fairly specific set of tools. The SEAMM Installer automatically installs the development
tools if the Conda environment contains "dev" -- typically we use the "seamm-dev"
environment. Creating the environment is almost identical to installing the normal SEAMM
environment except for the name of the environment::

  conda create -c conda-forge -n seamm-dev seamm seamm-installer python=3.9

.. note::
   When this was written, we are in the process of migrating to Python 3.10, but it is
   possible that there may be some issues. So the above command insists on Python 3.9 to
   be safe. Shortly we will remove this restriction.

Once the environment is created, activate it and run the Installer::

  conda activate seamm-dev
  seamm-installer

When the GUI appears switch to the **Components** tab and install the rest of the SEAMM
core plus any other plug-ins that you will need to run and test your work. Usually this
means installing basic packages such as **Read Structure** and **From Smiles**. Unless
you are worried about disk space it is simplest to install everything you watn to use,
though you can always rerun the Installer and add more plug-ins.

After the installer installs the packages that you have requested it will automatically
install the packages need for development -- things like **black**, **flake8**, and
**sphinx**. This will take several minutes, so be patient!

After the installation is complete you may wish to install the shortcuts for easy access
to the Installer and SEAMM, as well as the DashBoard and JobServer services. See the
normal installation `documentation <../../installation/graphical>`_ for instructions.

.. note::
   The development environmment is separate from the production SEAMM environment. You
   can safely install both, including shortcuts and services. The development versions
   will have "-dev" appended to the name, e.g. SEAMM-dev. The DashBoard will be
   installed in ~/SEAMM_DEV rather than ~/SEAMM, so the jobs you run in the development
   environment are separated from your production environment.

   The environments for the plug-in specific codes, which are usually the executables,
   are shared, e.g. there will only be one **seamm-lammps** environment, and both the
   production environment and development environment will use the LAMMPS executables in
   that environment, by default.

You should rerun the Installer occasionally and update the environment. This will update
both the packages that you select as well as the development environment itself.
