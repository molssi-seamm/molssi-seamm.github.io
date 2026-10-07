.. _jobserver-queues:

***************************************
How-To Configure the JobServer's Queues
***************************************

The JobServer runs the jobs you submit from the GUI or the web interface. Out
of the box it runs each job as a subprocess on its own machine. One file turns
it into a dispatcher: it can run jobs under the machine's own queueing system,
send them to a cluster over ssh, cap how many run at once, and let a job ask
for more cores, memory or time within limits you set. This how-to sets that
file up, from a single machine to a remote cluster, and explains every key.

For *where a job's individual calculations run* -- on the machine with the
flowchart, or bundled into batch jobs of their own -- see
:ref:`where-jobs-run` in the user guide; that is a further key in the same
sections.

The file
========

The configuration is ``<root>/<name>.ini``, where ``<root>`` is the
installation (``~/SEAMM`` by default) and ``<name>`` is the JobServer's name,
which defaults to the machine's hostname: ``~/SEAMM/ChemAI.ini`` for a machine
called ``ChemAI``. It sits beside ``orca.ini`` and ``lammps.ini``, because it
describes the machine, not a user's preferences. If the file does not exist,
the JobServer runs jobs locally as it always has.

The JobServer reads the file once, when it starts. After editing it, restart
the service::

    seamm-manager services restart

Each section of the file is one **queue** a job may be sent to. ``[DEFAULT]``
names the one used when a job does not ask for a queue; with a single
section it is optional.

A single machine
================

The simplest file keeps jobs local but caps how many run at once. A laptop or
workstation has no queueing system, so the section is ``type = local``:

.. code-block:: ini

    [DEFAULT]
    default = local

    [local]
    type = local
    max_concurrent_jobs = 4

A workstation or server with its own SLURM, such as a group's GPU box, uses
that SLURM directly (``transport = local``), so each job gets a real
allocation and SLURM shares the machine fairly among jobs and other users.
This is a real example, with the comments its administrator left:

.. code-block:: ini

    [DEFAULT]
    default = ChemAI

    [ChemAI]
    transport = local
    partition = ChemAI
    nodes = 1
    ntasks = 4
    time = 7-00:00:00
    # Left blank, SLURM reserves the WHOLE node's memory per job, so jobs
    # serialize on memory alone. Set it explicitly.
    mem = 10G
    # How many jobs this JobServer keeps in SLURM at once; each at
    # ntasks = 4 keeps the 128-CPU node comfortably loaded.
    max_concurrent_jobs = 60
    # How many times to resubmit a job SLURM lost track of before giving up.
    max_resubmits = 3

    [ChemAI.limits]
    overridable = ntasks, mem, time, gres
    ntasks.min = 1
    ntasks.max = 64
    mem.max = 500G
    time.max = 7-00:00:00
    # The node has two A100s. There is deliberately no default gres above:
    # it would make every job, including CPU-only ones, wait for a GPU.
    # Jobs that need one ask for it, within these choices.
    gres.choices = gpu:1, gpu:2, gpu:A100:1, gpu:A100:2

The ``[ChemAI.limits]`` section is what lets a job ask for 32 cores or a GPU
when it needs them; see `Limits`_ below.

A remote cluster
================

A JobServer on your laptop or a group server can send jobs to a cluster it
reaches over passwordless ssh. The cluster does not share a filesystem with
the JobServer, so the section also says where on the cluster to put each job
and how to start SEAMM there. This is the section that sends jobs from the
machine above to Virginia Tech's TinkerCliffs:

.. code-block:: ini

    [tinkercliffs]
    transport = ssh
    host = tinkercliffs
    # Our submission is a bare, non-interactive `ssh ... sbatch`, with none
    # of the cluster's login-shell environment (no modules). --export=NONE
    # makes SLURM rebuild the job's environment as from a fresh login, so a
    # code whose <code>.ini on the cluster says installation = modules finds
    # its modules.
    export = NONE
    # Each job gets its own directory under here on the cluster; the job's
    # directory is copied there before submission and back when it finishes.
    remote_root = /projects/seamm/seamm_jobserver_remote_chemai
    # How to start SEAMM on the cluster: an absolute path, no activation.
    remote_run_from_jobserver = /projects/seamm/SEAMM/venv/bin/run_from_jobserver

    # Submission defaults; match what `sacctmgr show assoc user=<you>` allows.
    account = seamm
    partition = normal_q
    qos = tc_normal_base
    constraint = amd
    nodes = 1
    ntasks = 4
    cpus_per_task = 1
    mem_per_cpu = 1900M
    time = 04:00:00

    max_concurrent_jobs = 500
    max_resubmits = 3

    [tinkercliffs.limits]
    overridable = nodes, ntasks, mem_per_cpu, time
    nodes.min = 1
    nodes.max = 32
    ntasks.min = 1
    ntasks.max = 3000
    mem_per_cpu.max = 120G
    time.max = 7-00:00:00

Three things to get right for a remote cluster:

* **Passwordless ssh** from the account the JobServer runs as, to the host
  named by ``host``. Test it with ``ssh <host> sbatch --version`` from that
  account: it must print a version without asking for anything.
* **SEAMM installed on the cluster**, on a filesystem the compute nodes see,
  with the codes configured there (``<root>/orca.ini`` and so on *on the
  cluster*). ``remote_run_from_jobserver`` is the full path to that
  installation's ``run_from_jobserver``.
* **A ``remote_root`` of its own for each JobServer.** Two JobServers that
  dispatch to the same cluster account must not share one: each numbers its
  jobs from its own datastore, so both could try to use ``Job_000042``.

If the JobServer and the cluster *do* share a filesystem -- the JobServer runs
on the cluster's login node -- leave out ``remote_root`` and
``remote_run_from_jobserver`` and use ``transport = local``.

A cluster running PBS instead of SLURM takes ``scheduler = pbs`` and either
PBS's own directives or the same portable spellings (``queue`` or
``partition``, ``walltime`` or ``time``, ``select`` or ``ntasks`` and
``mem``). The JobServer's own guide has a worked PBS section.

Several queues
==============

One file can hold as many sections as there are places to run: the machine's
own SLURM, the cluster's normal partition, its debug partition with a short
walltime and a higher priority, and a GPU partition. A job picks one when it
is submitted, and the one named by ``default =`` is used otherwise:

.. code-block:: ini

    [DEFAULT]
    default = ChemAI

    [ChemAI]
    ...

    [tinkercliffs]
    ...

    [tinkercliffs_debug]
    host = tinkercliffs
    partition = normal_q
    qos = tc_normal_short
    constraint = amd
    time = 01:00:00
    ...

    [tinkercliffs_a100]
    host = tinkercliffs
    partition = a100_normal_q
    qos = tc_a100_normal_base
    ntasks = 2
    cpus_per_task = 4
    mem_per_cpu = 4G
    gres = gpu:1
    time = 04:00:00
    ...

In the GUI's and web interface's submit dialog the queue is a drop-down, and
the fields the chosen queue's limits section allows appear beside it. A
script submitting through the dashboard's API gives ``"queue"`` and
``"slurm"`` in the job's parameters.

The keys
========

``type``
    ``local`` runs the job as a subprocess with no queueing system;
    ``queue`` submits it to the queueing system named by ``scheduler``
    (``slurm``, the default, or ``pbs``). ``slurm`` is the older spelling of
    ``queue`` and still works. Default: ``queue``.
``transport``
    ``local`` runs the scheduler's commands on this machine; ``ssh`` runs them
    on ``host`` over passwordless ssh.
``host``
    The ssh host (an alias from ``~/.ssh/config`` works); ``ssh`` only.
``remote_root``
    Directory on the remote host under which each job gets its own
    directory, created as needed; ``ssh`` only. Without it the JobServer
    assumes a shared filesystem.
``remote_run_from_jobserver``
    Absolute path of ``run_from_jobserver`` in the cluster's SEAMM
    installation; ``ssh`` only. Preferred to ``remote_conda_env``, which
    names a conda environment to activate instead.
``export``
    ``NONE`` makes SLURM rebuild the job's environment as from a fresh login
    instead of propagating the submitter's; needed when submitting over ssh
    to a cluster whose codes are loaded as modules.
``setup``
    Shell commands run at the top of the batch script before SEAMM starts
    (``module load ORCA``, say); continuation lines for several. Keep this to
    what the queue itself needs; a code's own modules belong in that code's
    ``<code>.ini`` on the cluster.
the submission directives
    ``account``, ``partition``, ``qos``, ``constraint``, ``nodes``,
    ``ntasks``, ``cpus_per_task``, ``mem``, ``mem_per_cpu``, ``time``,
    ``gres``, and any other SLURM option. Each becomes a ``#SBATCH --<key>=<value>`` line,
    underscores turned into dashes, so any other SLURM option works the same
    way. A blank value means "do not pass this directive". Set ``mem`` or
    ``mem_per_cpu`` explicitly: a SLURM site that reserves the whole node's
    memory by default will otherwise run one job at a time.
``max_concurrent_jobs``
    How many jobs this JobServer keeps submitted to this queue at once; the
    rest wait in the dashboard as *submitted*.
``max_resubmits``
    How many times a job the queue lost (the node failed, the job was
    preempted, it ran out of walltime) is submitted again before it is
    marked failed. A resubmitted job resumes from its checkpoint.
``tasks`` and its companions
    Where the job's calculations run; see :ref:`where-jobs-run`.

Limits
======

Every job on a queue gets the section's resources unless it asks for
something else. What it may ask for is the optional ``[<queue>.limits]``
section. It is secure by default: without it, nothing can be overridden.

.. code-block:: ini

    [tinkercliffs.limits]
    # Only these may be overridden at all.
    overridable = nodes, ntasks, mem_per_cpu, time, qos
    # A choice must be one of these.
    qos.choices = tc_normal_base, tc_normal_short
    # Numeric, size and time bounds, each optional.
    nodes.max = 32
    ntasks.min = 1
    ntasks.max = 3000
    mem_per_cpu.max = 120G
    time.max = 7-00:00:00

The submit dialog reads this section to decide which fields to show and
checks the values; the JobServer checks them again before submitting, so a
job asking for something the section does not allow fails at startup with a
clear message rather than running with other resources. Overridden values
are kept for any resubmission of the job.

Checking the setup
==================

#. Restart the JobServer and look at its log, ``<root>/logs/jobserver.log``:
   it lists the queues it read and says which is the default.
#. Open the submit dialog: the queues appear in the drop-down, with the
   override fields the limits allow.
#. Submit a small test flowchart to each queue in turn. The job's directory
   holds the generated batch script and the scheduler's output file; for a
   remote queue, the same directory appears under ``remote_root`` on the
   cluster while the job runs and is copied back when it finishes.

Common problems
===============

A job on a remote queue fails at once with a code not found
    The cluster's ``<root>/<code>.ini`` is not read, or the modules it names
    are not loaded. Set ``export = NONE``, and check that the installation's
    ini files on the cluster name the right ``installation`` and ``modules``.
Only one job runs at a time on a SLURM machine
    No memory directive: the site reserves the whole node per job. Set
    ``mem`` or ``mem_per_cpu``.
Every job waits for a GPU
    A default ``gres`` in the section. Leave it out and offer ``gres`` in the
    limits for the jobs that need one.
A job ran but its results are not in the dashboard
    The copy back from ``remote_root`` failed, usually a transient ssh
    problem; the JobServer retries on its next poll. Check that the account
    can still ssh to the host without a prompt.
Two JobServers' jobs collide on the cluster
    They share a ``remote_root``. Give each its own.

The `JobServer's own guide <https://molssi-seamm.github.io/seamm_jobserver/user_guide/index.html>`_
describes the mechanism in detail, including what the JobServer does at each
stage of a remote job and the PBS keys.
