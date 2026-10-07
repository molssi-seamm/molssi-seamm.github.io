.. _dev-installation:

**************************************************
Setting Up the Development Installation
**************************************************

To work on SEAMM or a plug-in you need somewhere to run your changes that is not your
everyday installation. The SEAMM Manager keeps a *development installation* in
``~/SEAMM_DEV``, beside the production one in ``~/SEAMM``: its own Python environment
with the development tools, its own JobServer and web interface, its own jobs, and the
source checkouts you are working on.

This page assumes that ``uv`` and the SEAMM Manager are installed and that ``~/SEAMM``
is set up (:ref:`seamm-manager-installation`).

Creating it
-----------

::

  seamm-manager --development install --all development
  seamm-manager --development update --all --latest

``--development`` is shorthand for ``--root ~/SEAMM_DEV``; ``install ... development``
adds the development tools (black, flake8, pytest, sphinx and the documentation
themes, build, twine, ...). The second command takes the newest releases from PyPI,
including any made today; without it you get the tested set published each night.

The development installation shares ``~/SEAMM``'s codes: installing a plug-in copies
``~/SEAMM``'s ``<code>.ini`` into ``~/SEAMM_DEV`` so that it runs MOPAC, LAMMPS, Psi4
and the rest from the same conda environments, and it never creates or updates a conda
environment. So nothing you do here can change the codes your production installation
uses. If you are working on a code's installation itself and need your own copies, use
``install --code-environments prefixed`` instead, which gives ``~/SEAMM_DEV`` its own
environments named ``seamm-SEAMM_DEV-<code>``.

Services and apps
-----------------

::

  seamm-manager --development install seamm-webui
  seamm-manager --development services create jobserver
  seamm-manager --development services create webui --webui-host 127.0.0.1 --port 55155
  seamm-manager --development apps create

This gives:

* a JobServer ``jobserver-SEAMM_DEV`` for the development jobs, which run from
  ``~/SEAMM_DEV/venv`` with ``~/SEAMM_DEV``'s configuration;
* its web interface ``webui-SEAMM_DEV`` at http://localhost:55155 (leave out ``--port``
  to take the first free port instead);
* desktop apps ``SEAMM (SEAMM_DEV)`` and ``SEAMM-Manager (SEAMM_DEV)``.

On macOS the services show up in Activity Monitor as ``SEAMM-JobServer-SEAMM_DEV`` and
``SEAMM-WebUI-SEAMM_DEV``. ``seamm-manager services status --all`` lists them beside
production's. To send development jobs to a cluster as well as run them locally, give
the JobServer queues in ``~/SEAMM_DEV/<host name>.ini`` (see :ref:`jobserver-queues`
for the file and its keys).

Working on a package
--------------------

Activate the development environment in the terminal you work in, then use the
package's ``Makefile`` from its checkout::

  source ~/SEAMM_DEV/venv/bin/activate
  cd ~/Work/SEAMM/mopac_step
  make format lint install test

``make install`` installs your checkout into ``~/SEAMM_DEV/venv`` (entry points, data
files and all), so the development GUI, ``run_flowchart`` and the development
JobServer's jobs all use it; ``make test``, ``make lint`` and ``make html`` use the same
environment. For a package you change constantly, an editable install saves the
reinstall::

  uv pip install --python ~/SEAMM_DEV/venv/bin/python -e ~/Work/SEAMM/seamm_bsse

Keep ``~/SEAMM_DEV/venv`` off your ``PATH`` otherwise, and don't activate it in the
terminal you use for production, so that each terminal clearly uses one installation.

Keeping it up to date
---------------------

::

  seamm-manager --development update --all --latest

This updates the released packages and the development tools. A checkout you installed
is replaced only if a newer release appears; run ``make install`` in it again
afterwards if you are still working on it.

Moving an older conda-based ~/SEAMM_DEV
---------------------------------------

Before the SEAMM Manager, the development installation was the conda environment
``seamm-dev`` with services named ``dev_jobserver``, ``dev_webui`` and
``dev_dashboard``. Its jobs, projects and queue configuration in ``~/SEAMM_DEV`` are
kept. The steps:

#. Make sure no development jobs are running.

#. Back up the jobs database::

     cp -p ~/SEAMM_DEV/Jobs/seamm.db ~/SEAMM_DEV/Jobs/seamm.db.bak

#. Older databases were never brought under schema migrations. Check::

     sqlite3 ~/SEAMM_DEV/Jobs/seamm.db "select version_num from alembic_version"

   If that reports ``no such table``, mark the database with the version its tables
   already have, so the installation can migrate it the rest of the way. For a
   database whose ``flowcharts`` table has a ``flowchart_metadata`` column and no
   ``path`` column -- check with
   ``sqlite3 ~/SEAMM_DEV/Jobs/seamm.db "pragma table_info(flowcharts)"`` -- that is::

     seamm-manager --development environment create
     uv pip install --python ~/SEAMM_DEV/venv/bin/python seamm-datastore
     cd $(~/SEAMM_DEV/venv/bin/python -c "import seamm_datastore, pathlib; print(pathlib.Path(seamm_datastore.__file__).parent / 'database')")
     ~/SEAMM_DEV/venv/bin/alembic -x uri=sqlite:///$HOME/SEAMM_DEV/Jobs/seamm.db stamp 7b24598d1fee

   Ask on the forum if your database looks different.

#. Create the installation, its services and apps as above. Creating the services
   stops and replaces the old ``dev_jobserver`` and ``dev_webui`` automatically, since
   they ran the same root; the web interface keeps the old port.

#. Install the checkouts you had installed in ``seamm-dev`` into the new environment.

#. Once you are satisfied, remove the old pieces: the ``dev_dashboard`` service (if you
   still ran the old Dashboard), the ``SEAMM-dev`` and ``SEAMM-Installer-dev`` apps, and
   the conda environment (``conda env remove -n seamm-dev``).
