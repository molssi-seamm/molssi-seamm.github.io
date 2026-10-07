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

The new installation is SEAMM 2026.10 or later, which writes flowcharts in a new
format, 3.0. So the move has two parts: install SEAMM with the manager, then convert
your jobs' flowcharts to the new format. Both are below.

Before you start
================

* **Wait until no jobs are running.** The move recreates the JobServer and the
  conversion stops it for a minute or two.
* **Back up the** ``Jobs`` **directory**, or at least its flowcharts and the database.
  The conversion makes its own backup of the database and keeps every original
  flowchart, but a copy of your own costs little. This keeps just the parts that
  change, and works with directory names that contain spaces:

  .. code-block:: console

     $ cd ~/SEAMM
     $ find Jobs -name flowchart.flow -print0 | \
           tar --null -czf ~/SEAMM-flowcharts-backup.tgz -T - Jobs/seamm.db

* **If several machines work together**, for instance a GUI on your laptop that
  submits jobs to a server, move the **server first**. A new installation sends
  flowcharts in format 3.0, which an old one cannot read.

Moving the installation
=======================

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

#. Check that you can run a flowchart and see it in the web interface.

Converting the jobs' flowcharts
===============================

Every job directory holds a copy of the job's flowchart, and the jobs database keeps a
record of each one, all in the old format 2.0. The new installation reads them, but
until they are converted the web interface treats the old and new copies of the same
flowchart as different flowcharts. ``seamm-manager install`` ends by saying so when it
finds old job flowcharts. Convert them in one step, which keeps the originals and backs
up the database:

.. code-block:: console

   $ seamm-manager flowcharts status     # how many are still in format 2.0
   $ seamm-manager flowcharts migrate    # report, ask, then convert

``migrate`` first reports what it would do, then asks before changing anything.
:ref:`upgrading-format3` explains each stage, the messages you may see, how to undo
it, and how to convert your own flowcharts, the ``.flow`` files you keep outside the
jobs. Those can wait: SEAMM still reads format 2.0, and the editor saves in 3.0 the
next time you save one.

Removing the old installation
=============================

Once you are satisfied, remove the old pieces::

  conda env remove -n seamm

and delete the old ``SEAMM-Installer`` shortcut if you have one.

.. note::
   If you have several SEAMM installations, for instance a production one in ``~/SEAMM``
   and a development one in ``~/SEAMM_DEV``, move each separately, and convert each
   one's jobs with ``seamm-manager --root <root> flowcharts migrate``. ``--root`` chooses
   the root and ``--development`` is shorthand for ``~/SEAMM_DEV``.
