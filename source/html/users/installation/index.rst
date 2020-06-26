.. _installation:

****************
Installing SEAMM
****************

The graphical part of SEAMM is installed in the **seamm** conda
environment. If you do not have conda (or anaconda) installed, head
over to Miniconda_ or Anaconda_ and grab the installer, following
their directions. Miniconda_ is a small, stripped down version, which
is perfectly fine for our use. Anaconda_ comes with many packages
preinstalled and also a graphical interface, so if you plan to use it
for your own work it might be more useful. But Anaconda_ is more than
is needed for SEAMM.

Once you have conda installed, get the `seamm.yml`_ file from the
`conda_environments/`_ subfolder of the `molssi-seamm/misc`_ GitHub
project. You can download it from GitHub (right-click here_ and select
download) or just clone this entire repository. Either way, once you
have it run the conda command to create the environment::

  conda env create -f seamm.yml

If you prefer a name other than the default of **seamm** for the
environment, add that name like this::

  conda env create -f seamm.yml -n <name>

Once the environment is installed, activate it with::

  conda activate seamm

If you chose a different name, use that instead of **seamm**.

You can start the flowchart editor by typing::

  seamm

There are some sample flowcharts in `misc/flowcharts`_ to help you get
started.

Installing the Compute Engines
------------------------------
**N.B. Currently only Linux and MacOS versions of Packmol and LAMMPS
are supported by conda-forge. So, at the moment, these instructions
will not work under Windows.**

The :term:`plug-ins<plug-in>` in SEAMM use a number of external
executables to accomplish their tasks.

   - **seamm_util** and **from_smiles_step** use parts of OpenBabel
   - **packmol_step** uses Packmol to build fluid systems
   - **lammps_step** uses LAMMPS and OpenMPI
   - **mopac_step** uses MOPAC

Installing LAMMPS, OpenBabel and Packmol
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
If you want to run flowcharts using these plug-ins, you will need to
install the correct executables. All of these except MOPAC can be
installed using the conda environment specified in
`seamm-compute.yml`_ (right-click to download_)::

  conda env create -f seamm-compute.yml
  
Of course, if you want a name other than the default **seamm-compute**
you can override the default with the -n option.

Installing MOPAC
~~~~~~~~~~~~~~~~
Head to the MOPAC_ homepage and click on one of the download links in
the section on MOPAC2016. MOPAC is free for academics, so if you are
at a university or school you can request a copy and license. Follow
the instructions included with the download for installing MOPAC and
activating MOPAC.

The path to the MOPAC executable is stored in the next step in the
file ~/.seamm/mopac.ini. If MOPAC is not in your path you can have the
script create the file, then edit ~/.seamm/mopac.ini to put in the
correct path -- usually /opt/mopac/MOPAC2016.exe on Linux or Windows.

Finishing Up
~~~~~~~~~~~~
After the installation completes, activate the environment::

  conda activate seamm-compute

There is one more step needed to let SEAMM know the location of the
executables. Execute the script `find_executables.py`_ (`right-click
this to download`_) in the **seamm-compute** environment::

  ./find_executables.py

The script may ask you some questions, but normally it will just run
to completion, telling you that it created *~/.seamm/packmol.ini*,
*~/.seamm/openbabel.ini* and *~/.seamm/lammps.ini*. The hidden
directory *~/.seamm* is where SEAMM expects to find configuration
files.

Installing the Dashboard and JobServer
--------------------------------------
.. WARNING::
   At the moment there is not a packaged installation for
   the Dashboard. Shortly the JobServer will be integrated into the
   DashBoard, with a simpler installation.

For the time being you will need to clone the GitHub repository and
create the environment for the dashboard. By far the easiest way to do
this is clone the `molssi-seamm/misc`_ repository::

  git clone https://github.com/molssi-seamm/misc.git

Use the `Makefile` at the top-level of the misc/ directory to clone
the two directories::

  (base) psaxe@molssi10:~/Work/SEAMM$ make -f misc/Makefile seamm_dashboard
  cloning seamm_dashboard
  Cloning into 'seamm_dashboard'...
  remote: Enumerating objects: 363, done.        
  remote: Counting objects: 100% (363/363), done.        
  remote: Compressing objects: 100% (189/189), done.        
  remote: Total 3697 (delta 225), reused 261 (delta 169), pack-reused 3334        
  Receiving objects: 100% (3697/3697), 7.35 MiB | 24.74 MiB/s, done.
  Resolving deltas: 100% (1719/1719), done.
  cloning seamm_jobserver
  (base) psaxe@molssi10:~/Work/SEAMM$ 

Running the Dashboard
~~~~~~~~~~~~~~~~~~~~~
Now prepare the Conda environment for the Dashboard::

  (base) psaxe@molssi10:~/Work/SEAMM$ make dashboard_env
  make[1]: Entering directory '/home/psaxe/Work/SEAMM/seamm_dashboard'
  Creating the Conda/pip environment. This will take some time!

  Collecting package metadata (repodata.json): done
  Solving environment: done

  Downloading and Extracting Packages
  certifi-2020.6.20    | 156 KB    | ################################################################################################################################################################ | 100%
  pip-20.1.1           | 1.7 MB    | ################################################################################################################################################################ | 100%
  setuptools-47.3.1    | 515 KB    | ################################################################################################################################################################ | 100%
  Preparing transaction: done
  ... lots more test ...
  To use the environment, type
     conda activate seamm-dashboard
  make[1]: Leaving directory '/home/psaxe/Work/SEAMM/seamm_dashboard'
  (base) psaxe@molssi10:~/Work/SEAMM$ 

To run the Dashboard you need to follow the direction just above, and
activate the seamm-dashboard environment::

  (base) psaxe@molssi10:~/Work/SEAMM$ conda activate seamm-dashboard

Then run the dashboard::

  (seamm-dashboard) psaxe@molssi10:~/Work/SEAMM/seamm_dashboard$ ./results_dashboard.py 
  dashboard:INFO:Logging to the console at level INFO.
  dashboard:INFO:Logging to /home/psaxe/Jobs/logs/dashboard.log at level INFO.
  dashboard:INFO:
  dashboard:INFO:Where options are set:
  dashboard:INFO:------------------------------------------------------------
  dashboard:INFO:Config File (/home/psaxe/.seamm/seamm.ini):
  dashboard:INFO:  datastore:         /home/psaxe/Jobs
  dashboard:INFO:  project:           psaxe
  ... lots more output ...

You can access the Dashboard using your browser at this address `http://localhost:5000`_

The Dashboard will be accessible for as long as you leave it
running. However, if you logout it will probably be killed. If you
want it to reamin running, use `nohup`::

  (seamm-dashboard) psaxe@molssi10:~/Work/SEAMM/seamm_dashboard$ nohup ./results_dashboard.py &
  nohup ./results_dashboard.py &
  [1] 9431
  (seamm-dashboard) psaxe@molssi10:~/Work/SEAMM/seamm_dashboard$ nohup: ignoring input and appending output to 'nohup.out'

Running the JobServer
~~~~~~~~~~~~~~~~~~~~~

The JobServer is part of the main release and was installed when you
created the `seamm` environment. To run the JobServer, simply activate
the SEAMM environment and run the command `jobserver`::

  (seamm) psaxe@molssi10:~/Work/SEAMM/seamm_jobserver$ conda activate seamm
  (seamm) psaxe@molssi10:~/Work/SEAMM/seamm_jobserver$ jobserver
  WARNING:seamm_jobserver.jobserver:Starting job 4
  WARNING:seamm_jobserver.jobserver:Submitted job 4
  WARNING:seamm_jobserver.jobserver:Running job 4
  WARNING:seamm_jobserver.jobserver:Completed job 4
  WARNING:seamm_jobserver.jobserver:Task finished, result = {'task': 'ran job', 'job_id': 4}
  WARNING:seamm_jobserver.jobserver:Job 4 finished.

Don't be concerned about the warnings! You won't see any
immediately. They are just telling you that jobs are being run, so
every time you run something new lines of output will appear.

As with the Dashboard, you can leave the JobServer running using
`nohup`::

  (seamm) psaxe@molssi10:~/Work/SEAMM/seamm_jobserver$ conda activate seamm  
  (seamm) psaxe@molssi10:~/Work/SEAMM/seamm_jobserver$ nohup jobserver &
  [1] 11475
  (seamm) psaxe@molssi10:~/Work/SEAMM/seamm_jobserver$ nohup: ignoring input and appending output to 'nohup.out'

As it let's you know, the output will be put in nohup.out.

.. _Miniconda: https://docs.conda.io/en/latest/miniconda.html
.. _Anaconda: https://www.anaconda.com/distribution
.. _MOPAC: http://openmopac.net	      
.. _seamm.yml: https://github.com/molssi-seamm/misc/blob/master/conda_environments/seamm.yml
.. _here: https://raw.githubusercontent.com/molssi-seamm/misc/master/conda_environments/seamm.yml
.. _conda_environments/: https://github.com/molssi-seamm/misc/conda_environnments/
.. _molssi-seamm/misc: https://github.com/molssi-seamm/misc/
.. _misc/flowcharts: https://github.com/molssi-seamm/misc/flowcharts/
.. _seamm-compute.yml: https://github.com/molssi-seamm/misc/conda_environments/seamm-compute.yml
.. _download: https://raw.githubusercontent.com/molssi-seamm/misc/master/conda_environments/seamm-compute.yml
.. _find_executables.py: https://github.com/molssi-seamm/misc/scripts/find_executables.py
.. _right-click this to download: https://raw.githubusercontent.com/molssi-seamm/misc/master/scripts/find_executables.py
.. _http://localhost:5000: http://localhost:5000
