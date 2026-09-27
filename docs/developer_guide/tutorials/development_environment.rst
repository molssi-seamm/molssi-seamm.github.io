**************************************
Installing the Development Environment
**************************************

SEAMM provides a lot of help for developing with the SEAMM environment, but expects a
fairly specific set of tools. The SEAMM Manager keeps a separate *development*
installation in ``~/SEAMM_DEV``, beside the production one in ``~/SEAMM``, and adds the
development tools -- things like **black**, **flake8**, **pytest** and **sphinx** -- to
it.

If you have not already, install ``uv`` and the SEAMM Manager as described in
:ref:`seamm-manager-installation`. Then create the development installation with SEAMM,
all the MolSSI plug-ins and the development tools::

  seamm-manager --development install --all development

``--development`` makes the manager work in ``~/SEAMM_DEV``, with its Python environment
in ``~/SEAMM_DEV/venv``. You can name individual plug-ins instead of ``--all``; usually
you want at least basic ones such as **Read Structure** and **From Smiles** to run and
test your work. Running ``seamm-manager --development`` with no command opens the
manager's window for the development installation, where the **Components** tab works
as usual.

To work on a package, install your checkout into the development environment. Activate
the environment and use the package's ``Makefile``::

  source ~/SEAMM_DEV/venv/bin/activate
  cd my_step
  make install

``make install`` reinstalls the package from your source, which picks up entry points
and data files that an editable install can miss. ``make test``, ``make lint`` and
``make html`` then use the same environment.

After the installation is complete you may wish to create the shortcuts for easy access
to SEAMM and the SEAMM Manager, and the JobServer and web interface services::

  seamm-manager --development apps create
  seamm-manager --development services create jobserver

See :ref:`command line installation` for the web interface.

.. note::
   The development installation is separate from the production one. You can safely
   install both, including shortcuts and services. The development versions have
   "(Development)" or "dev" in their names, e.g. the ``dev_jobserver`` service, and use
   port 55155 rather than 55055 for the web interface. Jobs you run in the development
   installation go to ``~/SEAMM_DEV/Jobs``, separate from your production jobs.

   The conda environments for the plug-ins' codes, which hold the executables, are
   shared, e.g. there is only one **seamm-lammps** environment, and both installations
   use the LAMMPS in it by default.

Update the development installation now and then::

  seamm-manager --development update --all

This updates the installed packages and the development tools. It does not touch the
packages you installed from your own checkouts unless a newer release is available, so
reinstall your checkout with ``make install`` afterwards if needed.
