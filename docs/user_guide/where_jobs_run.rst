.. _where-jobs-run:

***************
Where Jobs Run
***************

A SEAMM **job** is one run of a flowchart. The JobServer starts it on its
own machine or, through a queue section, as a batch job on a cluster (see
:ref:`jobserver-queues`). Inside the job, steps hand their calculations --
an ORCA single point, a VASP cell, a MOPAC optimization -- to SEAMM's **task
layer**. Where those *tasks* run is a separate choice: with the flowchart,
sharing its allocation, or packed into batch jobs of their own. This page
explains the choice, the keys that make it, and what happens to a task from
submission to result.

The job and its tasks
=====================

The job's own process is light: it reads the flowchart, builds inputs, and
analyzes outputs. The expense is in the tasks. For a flowchart that runs one
calculation after another, running the tasks where the job runs is simplest
and right. For a flowchart that produces hundreds or thousands of
independent calculations -- labelling a training set, a many-body expansion,
a parallel loop over structures -- the job should run somewhere cheap and
its tasks should go to the cluster as batch jobs, many at a time.

The queue section a job runs under says both things:

``type``
    where the **flowchart** runs: ``local``, as a subprocess on the
    JobServer's machine, or ``queue``, as a batch job on the scheduler named
    by ``scheduler``.
``tasks``
    where its **tasks** run: ``pool``, in the job's own allocation (the
    default, and what a section without ``tasks =`` means); ``taskserver``,
    through the machine's TaskServer; or ``queue``, as batch jobs submitted
    by the task layer.

A task's placement is independent of the job's. A flowchart that is itself a
batch job on the cluster can still send its tasks to the same queue, and that
is the usual arrangement for large campaigns.

Tasks in the job's allocation
=============================

With ``tasks = pool`` the task layer runs the tasks in a pool sized to what
the job has: the cores and memory of its SLURM allocation, or of the machine.
Several tasks run at once when they fit. Nothing is submitted and nothing
copied; each task's directory is under the step's directory in the job.

The TaskServer
==============

A machine without a queueing system -- a laptop, a group's workstation --
can still share its cores and memory fairly among everything SEAMM runs on
it. The TaskServer is a small queue for one machine, driven exactly like
SLURM, with a capacity set in ``<root>/taskserver.ini`` that
``seamm-manager install`` writes with the machine's physical cores and half
its memory. A section with ``tasks = taskserver`` (or ``type = queue`` with
``scheduler = seamm`` for the flowcharts themselves) sends work through it,
so two flowcharts running at once cannot oversubscribe the machine, and a
job asking for more than the machine has is refused rather than run. Its
page in the ``seamm-scheduler`` documentation has the details.

Tasks as batch jobs
===================

With ``tasks = queue`` the task layer submits tasks to the scheduler, in
**bundles**: one batch job that runs several tasks one after another, or
side by side, inside one allocation. The section's submission keys
(``account``, ``partition``, ``qos``, ``constraint``, ``time``, ...) apply to
the bundles, and a few keys shape them:

.. code-block:: ini

    [tinkercliffs_mbe]
    transport = ssh
    host = tinkercliffs
    export = NONE
    remote_root = /projects/seamm/seamm_jobserver_remote_chemai
    remote_run_from_jobserver = /projects/seamm/SEAMM/venv/bin/run_from_jobserver
    account = seamm
    partition = normal_q
    qos = tc_normal_short
    constraint = amd
    nodes = 1
    ntasks = 1
    cpus_per_task = 1
    mem_per_cpu = 8G
    time = 1-00:00:00
    max_concurrent_jobs = 20
    max_resubmits = 3
    # The flowchart runs as a 1-core batch job on the cluster (the keys
    # above); its tasks go to the same cluster's queue as bundles:
    tasks = queue
    scheduler = slurm
    poll_interval = 60

    [tinkercliffs_mbe.limits]
    overridable = time, qos, mem_per_cpu
    time.max = 7-00:00:00
    mem_per_cpu.max = 120G

``tasks = queue``
    Submit the job's tasks as batch jobs.
``scheduler``
    ``slurm`` (default) or ``pbs``.
``bundle_tasks`` or ``bundle_walltime``
    How tasks are packed: a fixed number per bundle, or as many as fit the
    walltime from the tasks' estimated times. Without either, the task layer
    packs by estimate within the section's ``time``.
``max_queued_tasks``
    How many of the user's bundle jobs may be in the queue at once; sites
    cap the number of jobs a user may hold, and several steps submitting at
    once share this count.
``inline_below``
    Tasks estimated to take less than this many seconds (default 60) run
    where the flowchart runs, when their program is installed there, rather
    than paying for a batch job.
``poll_interval``
    Seconds between checks on the bundles' state.
``remote_root``, ``shared_filesystem``
    Without a shared filesystem a task's directory is copied to
    ``remote_root`` before its bundle runs and back after; with
    ``shared_filesystem = yes``, or a local transport, nothing is copied.

Each task's size comes from the step: ranks, memory per rank and an estimated
time, from the step's own rule or from the fitted cost model when the machine
has one. A bundle's walltime is twice the estimate plus ten minutes. A task
whose bundle ran out of time is submitted again with twice the time, and
twice that after a second timeout; one that fails three times is reported,
not retried, and the step says so. Finished tasks are kept: a job that is
resubmitted, or run again by hand, reuses every result that exists and only
submits what is missing.

The program is configured **on the machine that runs the bundle**, from that
installation's ``<root>/<program>.ini``, so ORCA need not be installed where
the flowchart runs. Steps that still configure their program themselves are
the exception: their tasks run where the flowchart runs, with a warning.

Bundle files are under the step's directory, in ``tasks/_bundles/<name>/``:
the bundle's description, its script and the scheduler's log. The step's
``tasks/manifest.json`` records every task's state, attempts and where it
ran. A task past its attempts says in the manifest how to let it run again:
change its input, or delete its entry.

Running by hand
===============

A flowchart run from the command line, in a batch script of your own, has no
JobServer to hand it a section. Give it one with two environment
variables::

    export SEAMM_TARGETS=/projects/seamm/me/targets.ini   # the ini file
    export SEAMM_TARGET=tc                                 # the section
    run_flowchart my.flow

The file has the same sections as a JobServer's, with the submission keys
and ``tasks = queue``; ``SEAMM_TARGETS`` may be left out when the file is the
installation's own ``<root>/<hostname>.ini``. Without either variable the
tasks run in the pool, as before. A JobServer does the same thing for its
jobs: it copies the job's section into the job directory as ``target.json``,
which is why a section must never hold a secret.

A second variable, ``SEAMM_CE``, tells a flowchart how much of the machine
it may use (cores, memory, GPUs) when it is not inside a SLURM allocation.
Parallel loops set it for each iteration; the seed timing benchmark sets it
to cap the cores a code sees at each point of its sweep.

From the web interface to a cluster
===================================

The usual arrangement for a large campaign, as it runs today:

#. The web interface and JobServer run on a group server (``ChemAI``). Its
   ``ChemAI.ini`` has a local section for small jobs and several sections
   for the cluster (``tinkercliffs``, a debug one with a short walltime, a
   GPU one), all reached over ssh with their own ``remote_root``; the MBE
   section above adds ``tasks = queue``.
#. A user builds a flowchart in the GUI and submits it from the web
   interface, choosing the cluster queue in the submit dialog and, if the
   queue's limits allow, more time or memory.
#. The JobServer copies the job directory to the cluster, submits the
   flowchart there as a one-core batch job, and polls it. The flowchart's
   tasks are bundled by estimated time and submitted to the cluster's queue
   under the user's account, up to ``max_queued_tasks`` at a time, each with
   the section's partition, QOS and constraint.
#. Finished bundles leave their results in the task directories; the
   flowchart analyzes them as they arrive and writes its own results. When
   the job finishes, its directory is copied back and it appears in the
   web interface like any other.
#. A job the cluster lost -- preempted, out of walltime -- is submitted
   again by the JobServer, up to ``max_resubmits`` times, and resumes from
   its checkpoint with every finished task kept.

Every machine that runs tasks keeps timing records of them, in
``~/.seamm.d/timing/``, from which a cost model is fitted so that estimates
and bundle walltimes improve with use. The ``seamm-exec`` documentation
describes the records, the model and the seed benchmark that places a new
machine in it.
