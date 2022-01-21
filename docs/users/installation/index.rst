.. _installation:

****************
Installing SEAMM
****************

There are two parts to SEAMM that you can install:

  * The SEAMM environment and the graphical application for building flowcharts, running
    jobs, etc.
  * The web-based Dashboard, used for exploring the results of jobs.

Both of these rely on having conda installed.  If you do not have
conda (or anaconda) installed, head over to Miniconda_ or Anaconda_
and grab the installer, following their directions. Miniconda_ is a
small, stripped down version, which is perfectly fine for our
use. Anaconda_ comes with many packages preinstalled and also a
graphical interface, so if you plan to use it for your own work it
might be more useful. But Anaconda_ is more than is needed for SEAMM.

.. note::
   A `video of installing conda <https://www.youtube.com/watch?v=FGDpdAiBPrA>`_ is
   available in the `MolSSI SEAMM channel
   <https://www.youtube.com/channel/UCF_5Kr_AN90CYb0fTgYQHzQ>`_

Installing the SEAMM environment and GUI
----------------------------------------

This following steps require use the command-line. If you are running
under Linux, you already know how to do this. On a Mac start the
Terminal (Applications/Utilities/Terminal) and use that window for the
following commands.

.. attention::
   While SEAMM can be installed natively on Windows, significant pieces of functionality
   are missing because 3rd party packages often don't support Windows. However, the
   Windows Subsystem for Linux (WSL) supports running Linux programs, including SEAMM,
   natively. Shortly we'll add instructions for setting up WSL and installing
   SEAMM. With Windows 11 all functionality is available; however, Windows 10 is a bit
   more difficult and we are still working to see how to get all the functionality
   working.

.. note::
   A `video of installing SEAMM <https://www.youtube.com/watch?v=gqWzTvgPM1I>`_ is
   available in the `MolSSI SEAMM channel
   <https://www.youtube.com/channel/UCF_5Kr_AN90CYb0fTgYQHzQ>`_

   This video is slightly out of date. Please note small changes in the next step.

The SEAMM should be installed in the **seamm** conda environment as follows::

  conda create -n seamm -c conda-forge seamm seamm-dashboard seamm-installer
   
Once the environment is installed, activate it with::

  conda activate seamm

If you chose a different name, use that instead of **seamm**. Now run
the SEAMM installer to install both the SEAMM environment and
available plug-ins::

  seamm-installer install

This will take perhaps 25 minutes or even a bit more because not only is it
installing SEAMM and the plug-ins, but it is also installing codes such as LAMMPS, Psi4,
Packmol, and DFTB+ so that they can be used in the SEAMM environment. Some of these
codes are quite large, so particularly if your Internet connection is a bit slow, it may
take longer. Psi4 in particular takes 10 or more minutes to install. Be patient!

You can check on the environments created as follows::

  conda info -e

which will produce an output like this::

  # conda environments:
  #
  base                     /Users/tester/opt/miniconda3
  seamm                 *  /Users/tester/opt/miniconda3/envs/seamm
  seamm-dftbplus           /Users/tester/opt/miniconda3/envs/seamm-dftbplus
  seamm-lammps             /Users/tester/opt/miniconda3/envs/seamm-lammps
  seamm-packmol            /Users/tester/opt/miniconda3/envs/seamm-packmol
  seamm-psi4               /Users/tester/opt/miniconda3/envs/seamm-psi4
   
SEAMM uses individual environments for each simulation engine because they often require
many other tools. Sometimes two different codes require different versions of the same
tool which causes problems unless each installation is kept separate from the others.

You can start the flowchart editor by typing::

  seamm

On either a Mac or Linux machine there will be a user-app named **SEAMM** (or whatever
you named the environment) that you can use to run SEAMM. You can pin this to the Dock
or Task Bar (Launcher).

If you are on a Mac or Linux machine, the installer has also installed user services for
the Dashboard and JobServer. On Linux they should already be running. On a Mac you need
to either log out and log back in to get them started, or follow the instructions that
the installer printed (which requires administrator access to the machine).

You can see that they are running as follows::

  (seamm-dev) psaxe@h80adf301 ~ % ps -eaf | grep seamm
   ps -eaf | grep seamm
     501 16317     1   0  8:58AM ??         0:01.36 /Users/psaxe/opt/miniconda3/envs/seamm/bin/python3.9 /Users/psaxe/opt/miniconda3/envs/seamm/bin/jobserver
     501 16325     1   0  8:58AM ??         0:14.96 /Users/psaxe/opt/miniconda3/envs/seamm/bin/python3.9 /Users/psaxe/opt/miniconda3/envs/seamm/bin/seamm-dashboard
     501 17050 16626   0  9:55AM ttys002    0:00.01 grep seamm

You should see two lines similar to thos above; however paths and versions of Python
might be different.

Installing MOPAC
~~~~~~~~~~~~~~~~
The MolSSI is in the process of taking MOPAC over, and will shortly release it as a
fully open-source code. This will make the installation automatic, like it is for other
codes, but in the meantime, head to the MOPAC_ homepage and click on one of the download
links in the section on MOPAC2016 and follow the instructions included with the download
for installing MOPAC and activating MOPAC.

.. _Miniconda: https://docs.conda.io/en/latest/miniconda.html
.. _Anaconda: https://www.anaconda.com/distribution
.. _MOPAC: http://openmopac.net	      
.. _molssi-seamm/misc: https://github.com/molssi-seamm/misc/
.. _misc/flowcharts: https://github.com/molssi-seamm/misc/flowcharts/
.. _http://127.0.0.1:5000: http://127.0.0.1:5000
