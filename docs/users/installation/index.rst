.. _installation:

****************
Installing SEAMM
****************

The installation process in SEAMM involves two main parts:

  * SEAMM core environment consisting of the GUI for creating flowcharts,
    submitting jobs, publishing results etc., and

  * Web-based dashboard responsible for monitoring jobs, managing the
    job directories and analyzing the results.

Both parts rely on having *conda* installed on the host system. Installers 
for `Miniconda`_ or `Anaconda`_ can be found in their hosting websites. 
For the minimalists, `Miniconda`_, which can be considered as a reduced-size
version of `Anaconda`_, will be sufficient for the sole purpose of working 
with SEAMM.

.. note::
   A `video of installing conda <https://www.youtube.com/watch?v=FGDpdAiBPrA>`_ is
   available on the `SEAMM YouTube channel`_.

SEAMM Core Installation
-----------------------

.. attention::
   Although in principle, SEAMM would be natively installable on Windows, its key 
   third-party dependencies could not supported by this operating system. However,
   the *Windows Subsystem for Linux (WSL)* supports SEAMM and its dependencies. 
   The corresponding instructions for setting up a WSL environment for SEAMM
   installation is under preparation. While *Windows 11* provides full support 
   for the SEAMM requirements, handling *Windows 10* appears to be more complicated
   and we are currently working on addressing this case.

.. note::
   A `video of installing SEAMM <https://www.youtube.com/watch?v=gqWzTvgPM1I>`_ is
   available in the `SEAMM YouTube channel`_. Please note that this video is slightly
   out of date and there might be small differences between what you read here and 
   watch there.

The SEAMM should be installed in the **seamm** conda environment. Open a terminal 
and run the following commands::

  conda create -n seamm -c conda-forge seamm seamm-dashboard seamm-installer

Once the environment is in place, you can activate it as prompted::

  conda activate seamm

You can choose a different name for your SEAMM environment by replacing
the ``<name>`` argument in the ``-n <name>`` option with your preferred title.

Now run the *seamm_installer* to install both the SEAMM environment and the available
plug-ins::

  seamm-installer install

Depending on your internet connection and processing power, the execution will probably 
take a while (~10-20 min) to finish. The reason is that the aforementioned command not 
only installs SEAMM and its core plug-ins but also additional software packages such as
LAMMPS, Psi4, Packmol, and DFTB+ all withing their exclusive conda environments. 
As the installation of some of the large-size packages such as Psi4 can be time-consuming
process, it might be a good time to sit back and take some rest, do other tasks or grab
a cup of coffee!

After the `seamm_installer` finishes its process, you can check on the created environments
using the following command::

  conda info -e

which generates the proceeding output::

  # conda environments:
  #
  base                     /Users/tester/opt/miniconda3
  seamm                 *  /Users/tester/opt/miniconda3/envs/seamm
  seamm-dftbplus           /Users/tester/opt/miniconda3/envs/seamm-dftbplus
  seamm-lammps             /Users/tester/opt/miniconda3/envs/seamm-lammps
  seamm-packmol            /Users/tester/opt/miniconda3/envs/seamm-packmol
  seamm-psi4               /Users/tester/opt/miniconda3/envs/seamm-psi4

The GUI and the main program can be fired up by running::

  seamm

.. note::
  On Linux and Macintosh operating systems, the `seamm_installer` creates a user-app 
  called **SEAMM** (or whatever you named your main conda environment) that can be 
  used for running the SEAMM. You can pin the SEAMM app icon to your desktop Dock or Taskbar
  (Launcher) for convenient access. On the aforementioned operating systems, the installer
  also installs the user services for the Dashboard and JobServer. On Linux, they should 
  already be running behind the scene. On the Mac system, however, you will need to either
  log out and log back in to your machine user account to get them started or follow the
  instructions that the installer printed (which requires administrator access to the 
  hosting machine you are working on). The running processes for the Jobserver and the 
  Dashboard can be traced by using the following command::

   ps -eaf | grep seamm
  
  which yields the following output::

   501 16317     1   0  8:58AM ??         0:01.36 /Users/psaxe/opt/miniconda3/envs/seamm/bin/python3.9 /Users/psaxe/opt/miniconda3/envs/seamm/bin/jobserver
   501 16325     1   0  8:58AM ??         0:14.96 /Users/psaxe/opt/miniconda3/envs/seamm/bin/python3.9 /Users/psaxe/opt/miniconda3/envs/seamm/bin/seamm-dashboard
   501 17050 16626   0  9:55AM ttys002    0:00.01 grep seamm

  You should see two lines similar to those presented above; however, the paths and the versions of 
  your python might be different.

Installing MOPAC
~~~~~~~~~~~~~~~~
Recently, MolSSI has taken the ownership of the MOPAC and became responsible for its
development and maintenance within an open-source public repository. The MOPAC installation
will be automatic similar to other interoperable software packages such as LAMMPS and DFTB+.
The users can check the `MOPAC homepage <http://openmopac.net>`_ for further details.
Currently, *MOPAC2016* can be downloaded, installed and activated on a local machine 
following the instructions provided in the `Downloads page 
<http://openmopac.net/Downloads/Downloads.html>`_.

.. Link shortcuts and cross-referencing labels
.. _Miniconda: https://docs.conda.io/en/latest/miniconda.html
.. _Anaconda: https://www.anaconda.com/distribution
.. _molssi-seamm/misc: https://github.com/molssi-seamm/misc/
.. _misc/flowcharts: https://github.com/molssi-seamm/misc/flowcharts/
.. _http://127.0.0.1:5000: http://127.0.0.1:5000
.. _SEAMM YouTube channel: https://www.youtube.com/channel/UCF_5Kr_AN90CYb0fTgYQHzQ