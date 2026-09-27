.. _trial-installation:

*******************************************
Trying a New Release Beside Production
*******************************************

You can try new versions of SEAMM and its plug-ins without touching the installation
you use every day. The SEAMM Manager can keep any number of installations side by
side, each in its own directory (its *root*), with its own Python environment,
configuration, jobs, background services and desktop apps. Your everyday installation
is ``~/SEAMM``; here the trial is ``~/SEAMM_NEW``, but any name works.

Setting up the trial
--------------------

::

  seamm-manager --root ~/SEAMM_NEW install --all
  seamm-manager --root ~/SEAMM_NEW update --all --latest
  seamm-manager --root ~/SEAMM_NEW install seamm-webui
  seamm-manager --root ~/SEAMM_NEW services create jobserver
  seamm-manager --root ~/SEAMM_NEW services create webui --webui-host 127.0.0.1
  seamm-manager --root ~/SEAMM_NEW apps create

The second command takes the newest releases from PyPI, even ones made today; the
first alone gives the tested set published each night.

What you get:

* A JobServer service named ``jobserver-SEAMM_NEW`` and a web interface
  ``webui-SEAMM_NEW`` on the next free port -- 55056 if production's is on 55055.
  ``seamm-manager services status --all`` lists both installations' services.
* Desktop apps ``SEAMM (SEAMM_NEW)`` and ``SEAMM-Manager (SEAMM_NEW)``.
* Its own jobs in ``~/SEAMM_NEW/Jobs``, and its own copies of the codes'
  configuration files.

The trial uses the same codes as ``~/SEAMM`` -- MOPAC, LAMMPS, Psi4 and so on -- from
their existing conda environments. It copies ``~/SEAMM``'s configuration for each code
and never creates, updates or removes a conda environment, so nothing you do in the
trial can change the codes your production installation uses. (To test new versions
of the codes themselves, install the trial with ``--code-environments prefixed``,
which gives it its own copies.) Reference data such as forcefields and the VASP
potentials also come from ``~/SEAMM`` unless the trial has its own.

Using the trial
---------------

Start the trial's app, or open its web interface at http://localhost:55056, and submit
jobs to it as usual. From a terminal, activate its environment first::

  source ~/SEAMM_NEW/venv/bin/activate

Everything run from that environment uses the trial installation.

Removing the trial
------------------

::

  seamm-manager --root ~/SEAMM_NEW services delete jobserver webui
  seamm-manager --root ~/SEAMM_NEW apps delete
  seamm-manager --root ~/SEAMM_NEW environment remove
  rm -rf ~/SEAMM_NEW

``environment remove`` removes only the Python environment; the last command removes
everything else, including the trial's jobs, so copy out any you want to keep first.
