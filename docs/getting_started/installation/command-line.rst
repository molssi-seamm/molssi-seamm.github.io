:html_theme.sidebar_secondary.remove:

.. _`command line installation`:

*************************
Command Line Installation
*************************

Once you have installed ``uv`` and the SEAMM Manager (:ref:`seamm-manager-installation`),
install SEAMM with all the plug-ins created by MolSSI::

  seamm-manager install --all

This creates the SEAMM root ``~/SEAMM``, downloads Python 3.12 if needed, creates the
Python environment ``~/SEAMM/venv`` and installs SEAMM and the plug-ins into it from
PyPI, using the versions in the published lock file. That part takes a minute or so.
The plug-ins for external codes such as LAMMPS, Psi4, Packmol and DFTB+ then install
their codes into conda environments, which can take 10 or 20 minutes depending on your
internet connection. The installation also creates the database of jobs under
``~/SEAMM/Jobs``.

To also install the plug-ins written by other groups, add ``--third-party``::

  seamm-manager install --all --third-party

If you need more control, list the plug-ins to install instead::

  seamm-manager install from-smiles-step mopac-step

.. note ::
  If you do not intend to run calculations on this machine, but just create flowcharts
  and submit jobs to a server, install only the packages the GUI needs. This is quicker
  and does not need conda::

    seamm-manager install --gui-only --all

To see what is installed, and which versions are available::

  seamm-manager show

and to see the environment itself::

  % seamm-manager environment show

  Environment: /Users/you/SEAMM/venv
  Python:      /Users/you/SEAMM/venv/bin/python (3.12.14)
  Packages:    175 installed, 16 SEAMM

The codes live in conda environments named ``seamm-mopac``, ``seamm-psi4``,
``seamm-lammps``, and so on, so that they cannot conflict with each other or with SEAMM.

.. note::
   You can always get help on the command line with the ``--help`` (or ``-h``) option,
   either for the manager as a whole or for one command::

     seamm-manager --help
     seamm-manager install --help

Running SEAMM from the terminal
-------------------------------

You never need to activate the environment: the shortcuts and services use it directly.
To run SEAMM's commands, such as ``seamm`` for the GUI or ``run_flowchart``, from a
terminal, either activate it for that terminal::

  source ~/SEAMM/venv/bin/activate
  seamm

or put it on your path permanently by adding this line to ``~/.zshrc`` or
``~/.bashrc``::

  export PATH="$PATH:$HOME/SEAMM/venv/bin"

The GUI needs a windowing system, so it only works where you can use graphics on the
machine.

Installing Shortcuts
--------------------
To make it easy to start SEAMM and the SEAMM Manager from your desktop::

  % seamm-manager apps create
  % seamm-manager apps show

  ╒═══════════════╤══════════════════════════════════╕
  │ App           │ Path                             │
  ╞═══════════════╪══════════════════════════════════╡
  │ SEAMM         │ ~/Applications/SEAMM.app         │
  ├───────────────┼──────────────────────────────────┤
  │ SEAMM-Manager │ ~/Applications/SEAMM-Manager.app │
  ╘═══════════════╧══════════════════════════════════╛

Depending on your windowing system, you can drag the shortcuts to the desktop, launcher,
or dock.

Installing the Services
-----------------------

If you plan to run jobs on the machine, create the JobServer service, so that it keeps
running even when you are not logged in::

  seamm-manager services create jobserver

The web interface, where you follow jobs and look at their results, is installed into an
environment of its own and then run as a service. On a personal machine, where only you
use it::

  seamm-manager install seamm-webui
  seamm-manager services create webui --webui-host 127.0.0.1

It is then at http://localhost:55055, with no login. On a server that other people or
machines reach, leave out ``--webui-host 127.0.0.1``. The web interface then listens on
the network, serves HTTPS with a self-signed certificate, and asks each user to log in.
The installation creates an ``admin`` account with the password ``admin``; change it
straight away (see :ref:`dashboard-management`). ``--port`` chooses a port other than
55055.

To check on the services::

  % seamm-manager services status

  ╒═══════════╤═════════════╤═════════════════╤════════╤════════╕
  │ Service   │ Status      │ Root            │ Port   │ Name   │
  ╞═══════════╪═════════════╪═════════════════╪════════╪════════╡
  │ jobserver │ running     │ /Users/you/SEAMM│ ---    │ ---    │
  ├───────────┼─────────────┼─────────────────┼────────┼────────┤
  │ webui     │ running     │ /Users/you/SEAMM│ 55055  │ ---    │
  ╘═══════════╧═════════════╧═════════════════╧════════╧════════╛

``seamm-manager services stop``, ``start`` and ``restart`` control them. On a Mac they
are launchd agents and on Linux systemd user services.

Congratulations! SEAMM is fully installed and ready to go. The
:doc:`../tutorials/index` is a good place to start.

Keeping SEAMM up to date
------------------------

::

  seamm-manager update --all

updates the manager itself, then every installed package to the newest tested set, and
restarts the JobServer if it needs to be. The package list and lock file are refreshed
nightly, so a release made today appears tomorrow; ``update --latest`` asks PyPI
directly if you need it today.

After every change the manager writes the full list of installed versions to
``~/SEAMM/environments``, so you can always see what changed and when.

If the environment is ever damaged::

  seamm-manager environment recreate

deletes and rebuilds it and reinstalls the packages that were in it, in well under a
minute. Your jobs, configuration and the codes' conda environments are not touched.

.. note::
   When a plug-in updates its code's conda environment, Python packages that its
   environment file names without a version are installed only if missing and otherwise
   left alone. So a build you installed by hand, for instance PyTorch for your GPU's
   CUDA driver, survives updates. To change it, reinstall it by hand in that environment.
