.. _migrating-from-seamm-installer:

********************************
Moving from the SEAMM Installer
********************************

Before the SEAMM Manager, SEAMM was installed into a conda environment, usually called
``seamm``, with the SEAMM Installer (``seamm-installer``). Such an installation keeps
working, but it reads a package list that is no longer updated, so it receives no new
versions of SEAMM or the plug-ins.

Moving to the SEAMM Manager is quick and leaves your work where it is. The jobs in
``~/SEAMM/Jobs``, the configuration in ``~/SEAMM/*.ini`` and ``~/.seamm.d``, and the
conda environments of the codes (``seamm-mopac``, ``seamm-lammps``, ...) are shared by
both, and the manager uses them as they are.

#. Install ``uv`` and the SEAMM Manager (:ref:`seamm-manager-installation`)::

     curl -LsSf https://astral.sh/uv/install.sh | sh
     uv tool install seamm-manager

#. Install SEAMM into the new environment ``~/SEAMM/venv``::

     seamm-manager install --all

   or ``install --gui-only --all`` if the machine only runs the GUI. The plug-ins' own
   installers find the codes' conda environments already in place and leave them be.

#. If you had shortcuts, recreate them so that they start SEAMM from the new
   environment::

     seamm-manager apps create

#. If you ran the JobServer as a service, recreate it the same way, once no jobs are
   running::

     seamm-manager services create --force jobserver

#. The web interface replaces the old Dashboard. If you ran the Dashboard as a service,
   stop it and set up the web interface on the same port::

     seamm-manager services stop dashboard
     seamm-manager install seamm-webui
     seamm-manager services create webui

   Add ``--webui-host 127.0.0.1`` on a personal machine; see
   :ref:`command line installation`. The web interface shows the same jobs and projects,
   since it reads the same database.

#. Check that you can run a flowchart and see it in the web interface. Once you are
   satisfied, remove the old pieces::

     conda env remove -n seamm

   and delete the old ``SEAMM-Installer`` shortcut if you have one.

.. note::
   If you have several SEAMM installations, for instance a production one in ``~/SEAMM``
   and a development one in ``~/SEAMM_DEV``, move each separately. ``--root`` chooses
   the root and ``--development`` is shorthand for ``~/SEAMM_DEV``.
