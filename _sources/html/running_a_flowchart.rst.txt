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

