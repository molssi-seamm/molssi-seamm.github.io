
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
