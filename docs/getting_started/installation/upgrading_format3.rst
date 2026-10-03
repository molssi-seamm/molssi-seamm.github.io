.. _upgrading-format3:

************************************
Upgrading to flowchart format 3.0
************************************

SEAMM 2026.10 changes the format of flowchart (``.flow``) files from 2.0, a JSON file,
to 3.0, a short YAML file that lists only the settings that differ from the defaults.
The new files are easier to read, compare and write by hand or with tools, and each one
carries a digest so that SEAMM can tell when two flowcharts are the same calculation.

You need to do two things when you update:

  #. **Convert the jobs.** Every job directory holds a copy of the job's flowchart, and
     the jobs database keeps a record of each flowchart. ``seamm-manager flowcharts
     migrate`` converts both in one step and keeps the originals.
  #. **Convert your own flowcharts**, the ``.flow`` files you keep outside the jobs.
     You can leave this for later: SEAMM still reads format 2.0, and the editor saves
     in 3.0 the next time you save a file.

Nothing about the calculations changes. A converted flowchart runs exactly as it did
before.

.. contents:: On this page
   :local:
   :depth: 1

Which versions read and write which format
==========================================

=====================  ==============  ==============
SEAMM (``seamm``)      Reads           Writes
=====================  ==============  ==============
before 2026.10.1       1.0, 2.0        2.0
2026.10.1              1.0, 2.0, 3.0   2.0
2026.10.2 and later    1.0, 2.0, 3.0   3.0
=====================  ==============  ==============

So **an installation older than 2026.10.1 cannot read a 3.0 flowchart**. This matters
when several machines work together (see `Several machines`_). It also matters when you
send a flowchart to someone else.

Before you start
================

* **Wait until no jobs are running** on the installation. The conversion stops the
  JobServer and the web interface for a minute or two.

* **Back up the** ``Jobs`` **directory**, or at least its flowcharts and the database.
  The conversion makes its own backup of the database and keeps every original
  flowchart, but a copy of your own costs little. ``Jobs`` is usually ``~/SEAMM/Jobs``.
  The following keeps just the parts that change, and works with directory names that
  contain spaces:

  .. code-block:: console

     $ cd ~/SEAMM
     $ find Jobs -name flowchart.flow -print0 | \
           tar --null -czf ~/SEAMM-flowcharts-backup.tgz -T - Jobs/seamm.db

* If you still use the old conda-based *SEAMM Installer* (``seamm-installer``), move to
  the SEAMM Manager first. :ref:`migrating-from-seamm-installer` explains how.

Step 1: Update SEAMM
====================

.. code-block:: console

   $ seamm-manager update --all

This updates the manager itself, then SEAMM, the plug-ins and the web interface, and
restarts the services. When it finds jobs whose flowcharts are still in format 2.0, it
ends with:

.. code-block:: text

   This installation has job flowcharts in the old format 2.0. To convert them and the
   datastore to 3.0 (with a backup):
       seamm-manager flowcharts migrate

The updated installation keeps working without the conversion. It reads the old job
flowcharts. But until you convert them, the web interface and the database treat the
old and the new copies of the same flowchart as different flowcharts.

.. note::
   **If the update stops with an error about the manager itself.** Versions of the
   manager older than 2026.9.29.2 could damage themselves while upgrading if they were
   installed on a network filesystem (NFS or GPFS), which is common on clusters. If
   ``seamm-manager`` is missing or broken after the update, reinstall it and run the
   update again:

   .. code-block:: console

      $ uv tool install --force seamm-manager
      $ seamm-manager update --all

   On a cluster, first load or source whatever puts ``uv`` on your path.

.. note::
   Versions of the manager older than 2026.10.1.1 did not update the web interface.
   The updated manager does. If ``seamm-manager update --all`` upgraded an old manager,
   run it a second time so that the new manager updates the web interface.

Step 2: Convert the jobs
========================

First see how many job flowcharts need converting:

.. code-block:: console

   $ seamm-manager flowcharts status
   552 job flowcharts in /Users/you/SEAMM are in the old format 2.0. Convert them with
   'seamm-manager flowcharts migrate'.

Then convert them:

.. code-block:: console

   $ seamm-manager flowcharts migrate

``migrate`` works in two stages.

**First it reports what it would do, without changing anything.** You see the numbers
of flowcharts and database rows that it would convert, what the converter noticed (see
`Messages you may see`_), and any files it cannot convert. To see this report on its
own, use ``seamm-manager flowcharts migrate --dry-run``.

**Then it asks whether to go ahead.** If you answer ``y``, it

  #. stops the JobServer and the web interface;
  #. copies the jobs database to ``Jobs/seamm.db.bak-<date>-before-format3``;
  #. in each job directory, renames the original ``flowchart.flow`` to
     ``flowchart.v2.flow``, unchanged, and writes the converted ``flowchart.flow``
     beside it;
  #. converts the database's records of the flowcharts in one transaction. Jobs whose
     flowcharts were identical share one record, as before;
  #. writes a list of every file it changed to
     ``Jobs/format3-migration-<date>.json``;
  #. starts the services again.

It ends with:

.. code-block:: text

   Datastore backup: /Users/you/SEAMM/Jobs/seamm.db.bak-2026-10-01-153534-before-format3
   Manifest of file changes: /Users/you/SEAMM/Jobs/format3-migration-2026-10-01-153534.json
   The flowcharts and the datastore are now in format 3.0.

How long it takes depends on the number of jobs: a few seconds for hundreds of jobs and
several minutes for tens of thousands. ``seamm-manager flowcharts status`` should then
say that all the job flowcharts are in format 3.0. ``--yes`` skips the question, for
use in scripts.

Running the migration a second time is harmless. It converts only what is left, for
instance the flowcharts of jobs that were still running the first time.

.. warning::
   **Do not delete the jobs database to "start fresh".** If ``seamm.db`` is moved aside,
   the web interface builds a new one from the job directories, but that is not a
   conversion. The new database has no user accounts and converts nothing.
   ``seamm-manager datastore rebuild`` keeps the accounts and owners, but it also
   converts nothing. Use ``seamm-manager flowcharts migrate``.

Messages you may see
--------------------

The report lists what the converter noticed, grouped by kind and counted. None of
these messages stops the conversion:

``left out ..., which are not settings but a cache or run-time state`` (in SEAMM 2026.10.2 and earlier, ``dropped attributes ...``)
   Old versions of some plug-ins stored extra information in the flowchart beside the
   settings. One example is a cached copy of the VASP potential list. This information
   is not a setting, and the plug-in rebuilds it when it needs it, so the converter
   leaves it out. The message looks alarming, but it is expected.

``has no parameters but has settings as attributes (a legacy file); the step's defaults will apply``
   Very old flowcharts, from before about 2021, stored some settings in a form that
   is no longer recognized. The converter maps the ones it knows, such as the old
   LAMMPS settings. For any others, the step uses its defaults. These are only the
   records of old finished jobs; nothing is rerun.

``... (not in the datastore): ConversionError: This is not a MolSSI file.``
   The ``flowchart.flow`` in that job directory is empty or is not a flowchart at all,
   usually because the job failed before it started. The file is left exactly as it
   is.

``... exists; not converting ...``
   The job directory already has a ``flowchart.v2.flow``, so it has been converted
   already. The converter leaves it alone rather than overwrite the original.

Undoing the conversion
----------------------

You should not need to, but everything can be put back. Stop the services, copy the
database backup over ``seamm.db``, and rename the originals back using the manifest:

.. code-block:: console

   $ seamm-manager services stop
   $ cd ~/SEAMM/Jobs
   $ cp seamm.db.bak-<date>-before-format3 seamm.db
   $ ~/SEAMM/venv/bin/python -c \
         "from seamm.migrate3 import undo_files; undo_files('format3-migration-<date>.json')"
   $ seamm-manager services start

Converting your own flowcharts
==============================

Your own flowcharts are the ``.flow`` files you keep outside the job directories, for
example in ``~/SEAMM/flowcharts`` or in a project folder. They are not converted
automatically, and they do not need to be: SEAMM 2026.10 reads format 2.0. Convert them
whenever is convenient.

**With the editor.** Open the flowchart in the SEAMM editor and save it. From SEAMM
2026.10.2 on, the editor saves in format 3.0.

**From the command line.** ``seamm-flowchart convert`` writes a flowchart in format
3.0, by default to the screen, or with ``-o`` to a file:

.. code-block:: console

   $ seamm-flowchart convert old.flow -o new.flow

To convert every flowchart in a directory in place, keeping each original as
``<name>.v2.flow``:

.. code-block:: console

   $ cd ~/SEAMM/flowcharts
   $ for f in *.flow; do
   >     case "$f" in *.v2.flow) continue;; esac
   >     mv "$f" "${f%.flow}.v2.flow" &&
   >         seamm-flowchart convert "${f%.flow}.v2.flow" -o "$f"
   > done

``seamm-flowchart`` is in the SEAMM environment. If it is not on your path, use
``~/SEAMM/venv/bin/seamm-flowchart``.

Flowcharts that you have published, for instance on Zenodo, keep working: SEAMM reads
them in either format.

Several machines
================

When you run the GUI on your own computer and submit jobs to a server, **update the
server first**, then the computers that submit jobs to it. An updated GUI sends
flowcharts in format 3.0, and a server older than 2026.10.1 cannot read them. Those jobs
are refused or fail at once, before anything runs. Each installation is converted separately: run
``seamm-manager flowcharts migrate`` on every machine that has jobs.

If you have to keep writing format 2.0 for a while, for example for colleagues who have
not updated yet, set the environment variable ``SEAMM_FLOWCHART_FORMAT``:

.. code-block:: console

   $ export SEAMM_FLOWCHART_FORMAT=2.0    # the editor and tools write format 2.0

or convert a single file with ``seamm-flowchart convert --format 2.0 new.flow -o
old.flow``. Format 2.0 is temporary: a later release of SEAMM will stop reading and
writing it, so convert your flowcharts and update every machine before then.

More about format 3.0
=====================

`Flowcharts without the editor`_, in the SEAMM user guide, describes format 3.0 in
detail. It also covers the ``seamm-flowchart`` command, writing a flowchart as a short
YAML specification, and using SEAMM's tools from an AI assistant. The `SEAMM Manager
documentation`_ describes ``seamm-manager`` and its commands.

.. _Flowcharts without the editor: https://molssi-seamm.github.io/seamm/user_guide/flowcharts_without_the_editor.html
.. _SEAMM Manager documentation: https://molssi-seamm.github.io/seamm_manager/index.html
