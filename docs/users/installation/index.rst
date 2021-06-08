.. _installation:

****************
Installing SEAMM
****************

There are two parts to SEAMM that you can install:

  * The graphical application and environment, which we tend to call
    SEAMM
    
  * The web-based Dashboard

Both of these rely on having conda installed.  If you do not have
conda (or anaconda) installed, head over to Miniconda_ or Anaconda_
and grab the installer, following their directions. Miniconda_ is a
small, stripped down version, which is perfectly fine for our
use. Anaconda_ comes with many packages preinstalled and also a
graphical interface, so if you plan to use it for your own work it
might be more useful. But Anaconda_ is more than is needed for SEAMM.

Installing the SEAMM environment and GUI
----------------------------------------

This following steps require use the command-line. If you are running
under Linux, you already know how to do this. On a Mac start the
Terminal (Applications/Utilities/Terminal) and use that window for the
following commands.

The graphical part of SEAMM should be installed in the **seamm** conda
environment as follows::

  conda create -n seamm -c conda-forge seamm_installer

Once the environment is installed, activate it with::

  conda activate seamm

If you chose a different name, use that instead of **seamm**. Now run
the SEAMM installer to install both the SEAMM environment and
available plug-ins::

  seamm-installer install

This will take perhaps 10-15 minutes because not only is it installing
SEAMM and the plug-ins, but it is also installed codes such as LAMMPS,
Psi4, Packmol, and DFTB+ so that they can be used in the SEAMM
environment.

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

The reason that SEAMM uses individual environments for each simulation
engine is that it eliminates the version conflicts between the
installations, which otherwise can be very difficult.

You can start the flowchart editor by typing::

  seamm

There are some sample flowcharts in `misc/flowcharts`_ to help you get
started.

Installing MOPAC
~~~~~~~~~~~~~~~~
Head to the MOPAC_ homepage and click on one of the download links in
the section on MOPAC2016. MOPAC is free for academics, so if you are
at a university or school you can request a copy and license. Follow
the instructions included with the download for installing MOPAC and
activating MOPAC.

Installing the Dashboard
--------------------------------------

The Dashboard is installed in its own conda environment to keep its
dependencies separate from those of SEAMM::

  conda create -n seamm-dashboard python=3.9

Once the environment is create, activate it and use `pip` to install
the dashboard::

  conda activate seamm-dashboard
  pip install seamm-dashboard


Running the Dashboard
~~~~~~~~~~~~~~~~~~~~~
To run the Dashboard you need to make sure that you are running in the
correct conda environment. Also, to get started we will run the
dashboard in a window, which it will tie up. So open a new window and
activate the `seamm-dashboard` conda environment::

  conda activate seamm-dashboard

Then run the dashboard::

  (seamm-dashboard) tester@paul ~ % seamm-dashboard
  dashboard:INFO:Logging to the console at level INFO.
  dashboard:INFO:Logging to /Users/tester/SEAMM/logs/dashboard.log at level WARNING.
  dashboard:INFO:
  dashboard:INFO:Where options are set:
  dashboard:INFO:------------------------------------------------------------
  dashboard:INFO:root                default         ~/SEAMM
  dashboard:INFO:datastore           default         ~/SEAMM/Jobs
  ... lots more output ...

You can access the Dashboard using your browser at this address `http://localhost:5000`_

The Dashboard will be accessible for as long as you leave it
running. However, if you logout it will probably be killed. If you
want it to remain running, use `nohup`::

  (seamm-dashboard) tester@paul ~ % nohup seamm-dashboard &
  [1] 10102
  (seamm-dashboard) tester@paul ~ % appending output to nohup.out

  (seamm-dashboard) tester@paul ~ % jobs
  [1]  + running    nohup seamm-dashboard

Since this is the only job running it is job #1 -- that is what `[1]`
indicates. To kill it, you would type `kill %1`, replacing the `1`
with the appropriate job number.

Running the JobServer
~~~~~~~~~~~~~~~~~~~~~

The JobServer is part of the main release and was installed when you
created the `seamm` environment. To run the JobServer, activate
the SEAMM environment and run the command `jobserver`::

  (base) tester@paul ~ % conda activate seamm
  (seamm) tester@paul ~ % jobserver
  The JobServer is starting in /Users/tester
             version = 2021.6.4
           datastore = /Users/tester/SEAMM/Jobs/seamm.db
      check interval = 5
            log file = ~/SEAMM/logs/jobserver.log
  The following .ini files were used:
      /Users/tester/SEAMM/seamm.ini
    
As the JobServer runs jobs it will print information for each one it
runs, so expect to see output slowly accumulate.

As with the Dashboard, you can leave the JobServer running using
`nohup`::

  (seamm) tester@paul ~ % nohup jobserver 2>&1 >jobserver.out &
  [1] 10366

The magic incantation at the end sends any error messages (`2>&1`) and
output (`>jobserver.out`) to the file `jobserver.out`. The final `&`
causes it to run in the background so it doesn't tie up the
terminal. If we didn't redirect the output, it would be automatically
appended to `nohup.out`. There are two problems with this. First, it
is appended, so the file gets bigger every time we run and it is hard
to find the current information; and secondly, if we ran e.g. the
Dashboard and the JobServer in the same directory their output would
be intermingled in `nohup.out`, which is very confusing. So it is
recomended to always redirect the output as above.

.. _Miniconda: https://docs.conda.io/en/latest/miniconda.html
.. _Anaconda: https://www.anaconda.com/distribution
.. _MOPAC: http://openmopac.net	      
.. _molssi-seamm/misc: https://github.com/molssi-seamm/misc/
.. _misc/flowcharts: https://github.com/molssi-seamm/misc/flowcharts/
.. _http://localhost:5000: http://localhost:5000
