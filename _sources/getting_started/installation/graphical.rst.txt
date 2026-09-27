.. _`graphical installation`:

**********************
Graphical Installation
**********************

The SEAMM Manager has a window for installing SEAMM, creating shortcuts and managing the
background services. Once you have installed ``uv`` and the manager
(:ref:`seamm-manager-installation`), the steps are:

#. Open a terminal and start the manager with no arguments::

     seamm-manager

   You will see a window like this:

   .. figure:: images/initial.png
      :align: center
      :alt: The initial window of the SEAMM Manager

      The initial window of the SEAMM Manager

   .. note::
      The screenshots on this page were taken with the SEAMM Installer, which the SEAMM
      Manager replaces. The window is the same apart from its title.

#. Click on the second tab **Components**. The manager fetches the list of SEAMM
   packages and plug-ins and examines the installation, which can take a little while.
   A small dialog in front of the window shows the progress. When it is done the window
   looks like this:

   .. figure:: images/components.png
      :align: center
      :alt: The initial Components tab.

      The initial Components tab.

   The lines in green show components or plug-ins that are installed and up-to-date.
   Black indicates that the item is not installed, and red indicates items that are
   installed but out-of-date.

   Select the plug-ins that you want, or select everything using the ``Select all``
   button, then click ``Install selected``. The first time, the manager creates the
   Python environment in ``~/SEAMM/venv``, downloading Python if needed, and installs
   SEAMM and the plug-ins into it; this takes a minute or so. Plug-ins for external codes
   such as LAMMPS, Psi4, Packmol and DFTB+ then install their codes with conda, which
   can take 10 or 20 minutes depending on your internet connection and the codes
   selected. If conda is not installed, those plug-ins report it and are installed
   without their code; see :ref:`seamm-manager-installation`.

   When the installation is done, the window updates with the current status. You can
   select more packages and repeat the process at any time.

   .. note::
      If you plan to only use the GUI on this machine, and submit jobs to other machines,
      select the **GUI only** checkbox. This installs only what the SEAMM GUI needs, and
      none of the codes such as LAMMPS. It is faster, keeps the installation small, and
      does not need conda.

#. Once you are happy with the installation, go to the next tab, **Shortcuts**, to
   create shortcuts for starting SEAMM and the SEAMM Manager. It looks like this:

   .. figure:: images/shortcuts.png
      :align: center
      :alt: The initial Shortcuts tab.

      The initial Shortcuts tab.

   Select the applications that you want, and click ``Create selected apps``. On a Mac
   the shortcuts, ``SEAMM.app`` and ``SEAMM-Manager.app``, are in ``~/Applications``,
   i.e. the Applications folder under your home directory, not the main
   ``/Applications`` folder. On Linux, they are in ``~/.local/share/applications``. You
   can usually drag the shortcuts to the desktop, dock, launcher or similar place for
   easy access; the details depend on your OS and desktop.

#. If you want to run jobs on this machine, go to the last tab, **Services**, and create
   the JobServer service so that it is always running, even when you are logged out:

   .. figure:: images/services.png
      :align: center
      :alt: The initial Services tab.

      The initial Services tab.

   Select the JobServer and click ``Create selected services``. The buttons beside it
   let you stop and start the services later if you need to.

#. The web interface, where you follow jobs and look at their results, has its own
   environment and is set up from the terminal. For a personal machine, where only you
   use it, run::

     seamm-manager install seamm-webui
     seamm-manager services create webui --webui-host 127.0.0.1

   and open http://localhost:55055 in your browser. For a server that other people or
   machines reach, leave out ``--webui-host 127.0.0.1``; the web interface then listens
   on the network, uses HTTPS and asks each user to log in. See
   :ref:`command line installation` for details.

Congratulations! SEAMM is fully installed and ready to go. The
:doc:`../tutorials/index` is a good place to start.

Keeping SEAMM up to date
------------------------

Run the SEAMM Manager every few weeks. On the **Components** tab, packages with updates
are shown in red; select them and click ``Update selected``. From the terminal,
``seamm-manager update --all`` does the same for everything; see
:ref:`command line installation`.
