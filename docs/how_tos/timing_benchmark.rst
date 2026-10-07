.. _timing-benchmark:

**************************************
How-To Seed the Timing of a New Machine
**************************************

SEAMM keeps a record of every calculation it runs -- the code, the size of the
calculation, the cores it had, how long it took and on what kind of machine --
and fits a cost model to those records. The model gives each new calculation
an estimated time, which sets the walltime of the batch jobs that carry it and
how many calculations are packed into one. A machine the model has never seen
gets no estimate worth having: the estimates fall back to each step's rough
built-in rule until there are records. This how-to seeds those records with a
short, standard set of runs.

When to run it
==============

* On a new machine or cluster before sending it production work, so that the
  first real jobs get sensible walltimes.
* On each *kind* of node a cluster has. The records are keyed by cluster,
  partition and CPU model, so a partition that mixes two processors is two
  machine classes; run the seed once on each, constraining the job to one
  node type at a time.
* After a change that affects speed: a new compiler build of a code, a new
  processor, a different MPI.

Production runs keep adding records, so the model improves with use. What
they cannot give is the parallel scaling: a campaign usually runs each kind of
calculation at one fixed core count, and the fit then cannot separate the
effect of cores from the effect of size. The seed benchmark runs the same
calculations at several core counts, and that is what pins the scaling.

What it runs
============

Each code step declares its own benchmark: the systems that drive its cost and
the chemistries and tasks to run on them, with a size limit per tier. ORCA
runs a few molecules from water to a 300-atom alkane at B3LYP, HF and MP2 in
a small basis plus the MLFF labelling level in a triple-zeta basis, as
energies, gradients and optimizations. MOPAC runs the same molecules up to
3000 atoms with PM7 and PM6-ORG in both of its regimes. The ``quick`` tier
keeps each code to minutes per core count; ``full`` extends the sizes and
takes an hour or two. Any installed step that declares a benchmark is
included.

The runs are ordinary flowchart runs. Their records carry a tag naming the
benchmark set, so the fit can tell them from production runs and a later set
on the same machine can be compared with an earlier one.

Running it
==========

On a laptop or workstation, from the installation's environment::

    python -m seamm_exec.timing_benchmark --codes orca,mopac --cores 1,4,8 --fit

This builds the benchmark flowchart from the installed steps, runs it once
per core count for the codes that run in parallel (and once for the serial
ones), tags the rows, and with ``--fit`` fits the models afterwards. Core
counts above the machine's usable cores are skipped; on Apple silicon only
the performance cores count, since mixing in efficiency cores distorts the
scaling.

On a cluster, build the flowchart once and run it as a batch job that loops
over the core counts, so that each pass has the cores it asks for and the
rows carry the right partition::

    python -m seamm_exec.timing_benchmark --build-only --codes orca -o bench.flow

The batch script then runs, for each core count ``N``::

    export SEAMM_TIMING_BENCHMARK=<a name for this set>
    export SEAMM_CE='{"NTASKS": N, "MEM_PER_NODE": <bytes>, "MEM_PER_CPU": <bytes>, "NGPUS": 0}'
    run_flowchart bench.flow --ncores N orca-step --ncores N

in a fresh directory per core count. ``SEAMM_CE`` caps what the code sees,
and the ``--ncores`` options override any limit the machine's ``seamm.ini``
sets. Ask the scheduler for the largest core count in the sweep and, to seed
one node type of a mixed partition, constrain the job to it (SLURM's
``--constraint``). Sixteen cores and a few hours are enough for the quick
tier.

Fitting and checking
====================

The records are in ``~/.seamm.d/timing/<code>.csv`` of the user who ran
them, on the machine that ran them. Fit the model there::

    python -m seamm_exec.timing_model fit orca mopac

The report says how many rows and machine classes the fit saw, how well it
fits (the fraction of rows within a factor of 1.3 and of 2), the size and
parallel exponents, the relative cost of each method class and task, and the
start-up time per machine. Two things to look for:

* **Was the parallel exponent fitted?** The report says ``[assumed]`` when
  it was not. That happens when the core count followed the size in the
  records, as it does in production; the seed's core sweep is what fixes it.
* **The size range.** The model refuses to predict a calculation whose size
  lies outside what the records cover (by more than half again), or whose
  method class or kind of task the records lack; the step's built-in rule is
  used instead. If your production calculations are larger than the seed, the
  first production runs extend the range and the model refits itself as the
  records grow.

The model is written to ``~/.seamm.d/timing/models/<code>.json`` and used by
the steps from then on; it is refitted automatically when the records have
grown by a fifth or are a week older than the model.

What it does not cover yet
==========================

Records and models live in the user's home on each machine. A job submitted
from one machine to run on another is estimated, for now, with the model of
the machine that submits it; and a bundle that lands on a node type other
than the one the flowchart runs on is recorded under the flowchart's node
type. Keeping a cluster's queue sections to one node type (``constraint``)
avoids the second; the first is being addressed in ``seamm-exec``. The
``seamm-exec`` documentation describes the records, the model and the
benchmark declaration a step makes.
