2026-10-16 Labelling and training MLFFs entirely in SEAMM
==========================================================

Goal
----

Run the whole cycle that makes a machine-learned force field -- generating
structures, choosing which to label, labelling them, assembling the training
sets, training and validating the models -- as SEAMM flowcharts submitted to a
JobServer, without the hand-made batch scripts, watchers and one-off
corrections the campaign sessions (mbe, mlff, science) use today.

This document is the checklist: for each stage, what SEAMM already does, what is
still done outside it, and what is needed. It is a living document; the science
plans stay in the ``~/Sites`` lab notebook (the carbonate plan is
``mlff-training/2026-10-08_carbonate-electrolyte-training-plan``, the water plan
``mlff-training/2026-07-15_water-mlff-training-plan``), and each step's own
campaign notes hold its design.

**Status of this list (2026-10-16):** the labelling requirements (section 2) are
mbe's, sent 2026-10-16 after carbonate wave 2. The other stages are a first
sketch by the design session from the sessions' open items; the owning session
for each is to check and complete its stage (marked *to confirm*).

1. The stages
-------------

.. list-table::
   :header-rows: 1
   :widths: 12 36 40 12

   * - Stage
     - In SEAMM now
     - Outside SEAMM now
     - Owner
   * - Structures
     - Packmol, LAMMPS (classical and MLFF MD via xnn), Normal Mode Sampling, Dimer Builder, Extract Clusters
     - Cell and frame selection scripts; Li-salt frames; OPLS reference cells (*to confirm*)
     - science
   * - Selection
     - active_learning_step (QBC committee scoring, 2026.10.14.1) and ``seamm-al``
     - ``seamm-al score/select`` run as a CLI in the MLFF conda env on ChemAI; no contact check (spreads miss the tight-contact wall)
     - science, worker
   * - Labelling
     - mbe_step + seamm_mbe (VASP monomers/cell, ORCA pairs/triples), the task layer and bundles, the cost model and ``seamm-timing``
     - Evaluator jobs submitted by hand on ARC; watchers on the Mac; restart and manifest repair scripts (section 2)
     - mbe
   * - Collection
     - ``mbe_labels.extxyz`` per cell
     - Merging into training sets; the Pulay stress offset (``*_pulayfix`` copies); the DfE convention; energy caps for high-energy tails
     - mbe, science
   * - Training
     - ``seamm-al train`` (xnn recipe, k-fold committees, Sina's samplers)
     - Slurm scripts on ChemAI's GPUs in the MLFF conda env, outside any flowchart
     - mlff
   * - Validation
     - LAMMPS MD with the MLFF as a model chemistry; the Density, Diffusivity, Viscosity and Thermal Conductivity steps; ``seamm_md_analysis``
     - Liquid analysis scripts (``analyze_liquid.py``, ``analyze_nacl_md.py``, ``mlff_dipoles.py``): ΔH_vap, RDF/CIP, dielectric, dipoles
     - mlff, science
   * - Models
     - xnn_step model chemistries
     - Checkpoints and provenance by hand; the distribution design waits on Sina
     - mlff

2. Labelling through the JobServer (mbe, 2026-10-16)
----------------------------------------------------

The path already works: ChemAI's ``[tinkercliffs_mbe]`` queue passed a smoke test
(ChemAI job 5172, 2026-10-06), and the JobServer resubmits a lost evaluator in
place. Throughput is the same either way (about 550 starts per hour per cluster;
``MaxSubmitPU`` 1000 on ``tc_normal_base``). Most important first; 2.1-2.3 are the
minimum to run as well as now, plus 2.4 if Owl is used.

2.1 **Changing the settings of running jobs.** ``target.json`` is copied from the
    queue's section when the job is submitted (``seamm_scheduler`` ``config.py``).
    In wave 2, ``estimate_scale``, ``min_task_walltime`` and ``constraint`` were
    changed five times, each followed by a restart of every evaluator; through
    ChemAI that would need ``ChemAI.ini`` edited (Paul only), the JobServer
    restarted, and every running job's ``target.json`` edited by hand.
    *Needed:* an action (REST/WebUI) that pushes the queue section's current
    settings to running jobs, and evaluators that re-read the scheduling settings
    (estimate scale, minimum task time, constraint, nice) from ``target.json`` as
    they go. The connection settings (root, transport) stay fixed for a job's
    life.

    *Also needed: who sets the bundle size.* mbe_step passes its own tasks per
    bundle ("molecular bundle", 4) and bundle walltime ("bundle walltime", 8 h)
    from the flowchart (``mbe_step/levels.py``), and these override the
    target's: a target ``bundle_walltime`` had no effect on 2026-10-16. Decide
    which wins, target or step, and make tasks per bundle adjustable on a running
    job. It is the real throughput lever: with starts capped per cluster, running
    bundles ≈ starts per hour × bundle hours, so longer bundles are the only way
    to keep more running.

2.2 **A deliberate "restart job".** Only ``_finalize_or_resubmit_slurm_job``
    exists, and it resubmits only after the evaluator is lost. *Needed:* cancel
    the evaluator and resubmit it in place, adopting the queued and running
    bundles. *Prerequisite, done:* the manifests lost archive references when an
    evaluator was stopped just after a bundle was archived, so restarts reran
    finished tasks (up to 646 missing references in one cell after the
    timing-lock stall, 0-6 per cell on ordinary cancels; 55 rerun on
    TinkerCliffs at 04:2x after an incomplete repair); mbe ran
    ``carb_production/reconcile_manifests.py --apply`` before every resubmit.
    **Fixed in seamm-exec 2026.10.16.3** (the archive is recorded before the
    directories are removed; damaged manifests heal on restore), on ARC since
    2026-10-16 13:34; the script retires once no evaluator runs the old
    version.

2.3 **Scheduler housekeeping now done by watchers on the Mac.**

    a. *Starvation.* A new evaluator queues FIFO behind its own job's pending
       bundles at the same priority. mbe nices the bundles to 10 during
       restarts and back to 0 afterwards; a niced backlog left in place is
       starved by newer bundles (it happened on 2026-10-16). *Needed:* a target
       option such as ``bundle_nice`` (adjustable on running jobs, 2.1), or a
       higher priority for evaluators.
    b. *TinkerCliffs "env retrieval failed" holds* are released automatically
       by the watcher. *Needed:* the JobServer's poller releases them.

2.4 **Owl.** ChemAI has no Owl section (configuration). Owl matters for two
    reasons: the start ceiling is per cluster, so two clusters double the
    throughput; and Owl is faster for the expensive tasks (revDSD TZ pairs:
    median 763 s on Owl against 1,348 s on TinkerCliffs, 1.77x, 2026-10-16).
    *Needed later:* a "move job to another queue" action, so a cell can be
    restarted on another cluster (``/projects`` is shared, so nothing is
    restaged).

    A queue's ``constraint`` matters to the time estimates as well as to where
    bundles run: estimates are keyed by ``cluster:partition:cpu_model``, so
    TinkerCliffs' MBE queue pins ``constraint = amd`` until the estimates follow
    the bundle's node type (seamm_exec campaign 2026-10-05, phase 5 as revised
    2026-10-16).

2.5 **Queue settings.** ``[tinkercliffs_mbe]`` uses ``tc_normal_short`` (2x cost)
    with a 1-day limit; wave-2 evaluators run longer than a day. Production
    needs ``_base`` with 7 days: an ini change, to be the documented default for
    campaign queues.

2.6 **Progress view.** Results stage back to ChemAI only at the end of a job
    (the dashboard's on-demand pull exists). mbe watches per-level task counts
    (done, pending), OOM/TIMEOUT/NODE_FAIL bundles and ``seamm-timing check``.
    *Needed:* a per-job task progress view in the WebUI, including estimate ÷
    wall per group (``seamm-timing check`` for the job), the first thing to look
    at after every update.

2.7 **Checks before a pilot.**

    a. *Which ARC user ChemAI's ssh runs as.* **Answered:** ``psaxe`` (the
       JobServer runs as ``seamm`` only on ChemAI), so jobs from ChemAI share
       ``~/.seamm.d/timing`` and the timing model with the direct runs. The
       queue's ``remote_root`` is ``/projects/seamm/seamm_jobserver_remote_chemai``
       (``/home`` is slow from compute nodes).
    b. *Each cell's job-directory size* when it stages back to ChemAI. Open.

*Proposed pilot (mbe):* one or two cells of the next wave through ChemAI, the
rest as now. It needs ``ChemAI.ini`` edits (an Owl section, ``_base``), which are
Paul's call.

Also open for labelling: a k-point spacing option in mbe_step for cells smaller
than 10 Å (vasp_step takes ``options["k_spacing"]``; the 2026-10-06 smoke cell
failed on it; deferred by Paul 2026-10-09).

3. The other stages (*to confirm* by their owners)
--------------------------------------------------

3.1 **Selection.** ``seamm-al select`` inside a flowchart step on the MLFF
    environment rather than as a CLI; a contact check beside the committee
    spreads, which do not flag the unlabelled tight-contact wall (science,
    2026-10-13).

3.2 **Collection.** Labels from many cells merged into a training set by a
    step, with the corrections as recorded options rather than scripts: the
    Pulay stress offset per code and cutoff, the energy reference (DfE
    convention), energy caps or weights for high-energy tails (DMC normal
    modes); the provenance of each set (cells, labels, corrections) kept with
    it.

3.3 **Training.** ``seamm-al train`` as a flowchart step that submits the
    committee members as GPU tasks through the task layer (ChemAI's GPUs, ARC's
    A100s), with the checkpoints and the recipe stored as the model's
    provenance.

3.4 **Validation.** The liquid analyses still in scripts as steps or options of
    the MD analysis steps: ΔH_vap, RDFs and ion pairing (CIP/SSIP with a fixed
    cutoff), the dielectric constant and dipoles (campaign 2026-10-14 covers
    part of this).

3.5 **Models.** Registering a trained committee as an xnn_step model chemistry
    (name, checkpoints, provenance), and the distribution design
    (``.mlff.json`` sidecar and catalog; waits on Sina).

3.6 **Infrastructure shared by all stages.** The time estimates and their check
    (seamm-exec 2026.10.16-2026.10.16.2, ``seamm-timing check``); estimating for
    the target's node type (seamm_exec campaign 2026-10-05, phase 5 as revised
    2026-10-16); the GPU MLFF path through SEAMM being 1.5x slower than direct
    (120 vs 76 ms/step, ``OMP_NUM_THREADS=1`` suspected, untested); job-start
    validation that catches undefined flowchart variables.

4. Log
------

- 2026-10-16: document started (Paul). Labelling list from mbe; manifest
  archive-reference bug fixed (seamm-exec 2026.10.16.3); ORCA estimates use the
  model again (orca-step 2026.10.16, .1) and record their source (2026.10.16.2).
