*******************
Running a Flowchart
*******************

If you are working in a new window, activate the **seamm** environment::

  conda activate seamm

You can check the environment that the window is currently using like
this::

  (seamm) pwsmac:~ psaxe$ conda info -e
  # conda environments:
  #
  base                     //miniconda3
  seamm                 *  //miniconda3/envs/seamm
  seamm-compute            //miniconda3/envs/seamm-compute
  seamm-dev                //miniconda3/envs/seamm-dev

The asterisk (*) indicates the active environment. Note that it is
also the first part of the prompt, depending on your setup.

Once you have a flowchart, save it to disk and then execute it::

  flowcharts/mopac.flow --title 'A test of the MOPAC flowchart'

This will run the flowchart from the current directory, making the
current directory a *datastore* if it is not already one. A little
explanation will help! First, let's define some concepts:

Datastore
  A directory on disk for holding the jobs that you run with
  SEAMM. The jobs themselves are stored in
  *datastore*/projects/*project*/ in directories names *Job_XXXXXX*,
  where *XXXXXX* is the job id or number, with leading zeros so that
  directory listings order the jobs in a useful way.

Project
  A place to hold the related jobs needed to address the problem that
  you are tackling, the paper that you are writing, etc. Jobs can be
  in more than one project.

Job
  The execution of and results from a single simulation workflow,
  i.e. a flowchart. It is common usage to say "I am running a job."
  and later refer to the results as "job 53" or "the chloro-benzene
  job".

Job ID
  A short, unique identifier for a job. SEAMM uses integers, starting
  with 1 and incrementing for each job run. This job id is unique
  within a datastore, but different datastores will have duplicate job
  id's.

The command-line options when running a flowchart either directly or
by calling::

  run_flowchart <flowchart>

are as follows:

usage:
  run_flowchart or <flowchart>
  [-h]
  [--seamm-configfile SEAMM_CONFIGFILE]
  [-v]
  [--title TITLE]
  [--datastore DATASTORE]
  [--job_id_file JOB_ID_FILE]
  [--project PROJECTS]
  [--force]
  [--output {files,stdout,both}]
  filename

Execute a SEAMM flowchart Args that start with '--' (eg. -v) can also
be set in a config file (/etc/seamm/seamm.ini or ~/.seamm/seamm.ini or
specified via --seamm-configfile).  Config file syntax allows:
key=value, flag=true, stuff=[a,b,c] (for details, see syntax at
https://goo.gl/R74nmi). If an arg is specified in more than one place,
then commandline values override environment variables which override
config file values which override defaults.

positional arguments:
  filename
    the filename of the flowchart if using *run_flowchart*

optional arguments:
  -h, --help          show this help message and exit
  --seamm-configfile SEAMM_CONFIGFILE  a configuration file to override others [env var: SEAMM_CONFIGFILE]
  -v, --verbose       increases log verbosity for each occurence. [env var: VERBOSE]
  --title TITLE       The title for this run. [env var: SEAMM_TITLE]
  --datastore DATASTORE  The datastore (directory) for this run. [env var: SEAMM_DATASTORE]
  --job_id_file       The job_id file to use. [env var: JOB_ID_FILE]
  --project PROJECTS  The project(s) for this job. [env var: SEAMM_PROJECT]
  --force             Force deleting the directory if it exists [env var: FORCE]
  --output            {files,stdout,both} whether to put the output in files, direct to stdout, or both [env var: OUTPUT]

The default for the datastore is *./*, i.e. the current directory, and
the default projects is *default*. *--job-id-file* defaults to the
file *job.id* in the toplevel datastore directory. You can also set
any of these parameters in the file *~/.seamm/seamm.ini*::

  # Configuration options for SEAMM.
  #
  # Options in this file override those in all other
  # configuration files, but may in turn be overridden
  # by environment variables or commandline options.

  # datastore = ~/SEAMM
  # project = MyProject

The two options, which are commented out in the example above, are the
ones that you are most likely to use. Even if these are set in
*seamm.ini* you can override them on the command line. Also, if you
want the job to be in more than one project, repeat **--project
<project>** for each project.
