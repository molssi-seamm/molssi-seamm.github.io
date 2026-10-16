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
mbe's, sent after carbonate wave 2; structures, selection, collection and
validation (section 3) are science's, in its order of priority. Training and
models are a first sketch by the design session, for mlff to check (marked *to
confirm*).

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
     - Packmol, LAMMPS (classical and MLFF MD via xnn), Normal Mode Sampling, Dimer Builder, Extract Clusters; the OPLS reference cells and Li-salt cell builds are SEAMM jobs
     - MD frame pools as plain LAMMPS Slurm jobs; seeded starts, cluster carving and n-mer sampling scripts; reference-cell density analysis
     - science
   * - Selection
     - active_learning_step (QBC committee scoring, 2026.10.14.1) and ``seamm-al``
     - ``seamm-al score/select`` run as a CLI from a frozen copy in the MLFF env on ChemAI; group quotas, budget and frame decorrelation by scripts; no contact check
     - science, worker
   * - Labelling
     - mbe_step + seamm_mbe (VASP monomers/cell, ORCA pairs/triples), the task layer and bundles, the cost model and ``seamm-timing``
     - Evaluator jobs submitted by hand on ARC; watchers on the Mac; restart and manifest repair scripts (section 2)
     - mbe
   * - Collection
     - ``mbe_labels.extxyz`` per cell
     - Every correction as a script editing extxyz text: Pulay stress offset, minus-D4 twins, ΔfE and ``total_charge`` headers, the CCSD(T) Δ-model patch, merging, the force filter; energy caps undecided
     - mbe, science
   * - Training
     - ``seamm-al train`` (xnn recipe, k-fold committees, Sina's samplers)
     - Slurm scripts on ChemAI's GPUs in the MLFF conda env, outside any flowchart
     - mlff
   * - Validation
     - LAMMPS MD with the MLFF as a model chemistry; the Density, Diffusivity, Viscosity and Thermal Conductivity steps; ``seamm_md_analysis``
     - Liquid analysis scripts: ρ, g(r) and ΔH_vap; dielectric and dipoles from the LES latent charges; CIP/SSIP; same-resolution g_OO against Skinner; molecular vs atomic pressure
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

3. The other stages
-------------------

Science's order of priority: collection, selection, structures, validation.
Paths are on ChemAI unless marked.

3.1 **Collection** (science, with mbe and mlff) -- priority 1.

    *Outside SEAMM today*, all as scripts that edit the extxyz text (not through
    ASE, which drops the DDEC6 charge column and the info keys xnn needs):

    - the Pulay stress offset: fitted offsets (water: quadratic in mass density;
      NaCl uses water's; EC a constant +2030 atm; FEC 2740 + 1680(ρ_rel − 1)),
      applied by mlff's ``make_stressfix.py`` / ``make_stressfix_full.py`` into
      ``*_pulayfix`` copies with a ``stress_pulay_shift_atm`` header
      (``/D3/sina/xnns/research/experiments/arc/2026-10-13_1400_pulay_stressfix_labels_psaxe/``;
      notebook ``mlff-training/2026-10-13_vasp-pulay-stress``);
    - minus-D4 twins: ``ion_d4/d4_twins.py`` (NaCl), ``dmc_twins.py`` (DMC),
      subtracting xnn's D4, checked against ORCA's D4 (≤ 1e-5 meV/atom);
    - the ΔfE convention and the ``total_charge`` info key for ion sets: header
      edits, by hand or per-set converters (``qz_tools/convert_qz.py`` for the
      EC/FEC/DMC QZ sets);
    - the CCSD(T) Δ-model patch (2026-10-16): ``/D3/psaxe/ccsdt_dm2/patch_dm2.py``
      adds ΔE/ΔF/Δσ from ``dmodel2.py`` and its coefficients, and
      ``verify_patch.py`` checks everything else is byte-identical; 13 water sets
      in ``patched/`` with a README and ``SHA256SUMS`` (notebook
      ``mlff-training/2026-10-16_water-ccsdt-delta-model``);
    - merging the cells' ``mbe_labels.extxyz`` into sets, and the force filter
      (\|F\| > 20 eV/Å, applied to the control forces in both arms of an A/B
      test): mlff's scripts;
    - energy caps for high-energy tails (DMC normal-mode monomers: p95 5.3 eV,
      maximum 12 eV above the minimum): Paul's decision, not implemented.

    *Needed:* a **training-set step** that takes labelled structures and applies
    an ordered list of recorded corrections, each with its parameters and a
    version -- the Pulay offset per code, cutoff and element set; the ΔfE
    reference atoms; D4 removal; a Δ-model as a plug-in callable; an energy cap
    or weight; the force filter -- writes extxyz losslessly (every per-atom
    column and info key) and records the provenance chain (source sets,
    corrections, hashes) in the set's header or a sidecar.

    *Blockers:* a lossless extxyz writer in SEAMM (ASE's is not); a home for the
    correction definitions (offset fits, Δ-model coefficients) as versioned
    data; the A/B pattern (patched and control sets with identical frames and
    filters) as a first-class option.

3.2 **Selection** (science, with worker) -- priority 2.

    *Outside SEAMM today:* ``seamm-al score/select`` as a CLI in the MLFF
    environment, from a frozen copy (``/D3/psaxe/active_learning``, frozen
    cc078f3, then 5d55e69); the wave-2 selection by ``select_w2.sh`` (stage 1:
    the top cell per liquid, density and temperature group; stage 2: the rest
    by rank within a core-hour budget) and ``greedy_w2.py`` (no adjacent frames
    of a run: they share about 70 % of their neighbour shells), result
    TinkerCliffs ``carb_production/wave2_final_AL.txt``; ranking by ρ_P + ρ_F
    from a final-committee check (ChemAI 12035).

    *Needed:* ``seamm-al select`` as a step; group quotas, a core-hour budget
    (from the ``seamm-timing`` estimates) and a frame-decorrelation rule as its
    options; a **contact check** beside the committee spreads -- MD frames with
    unlabelled tight O···O or ion contacts score like OPLS frames (2026-10-13).

    *Blocker for wave 3:* the contact check (worker).

3.3 **Structures** (science) -- priority 3.

    The OPLS reference cells and the Li-salt cell builds are SEAMM jobs (EC/FEC
    references ChemAI 5122-5131; Li-salt builds 5258-5262; NaCl step-4 frames
    5177-5188).

    *Outside SEAMM today:* MD frame pools as plain LAMMPS Slurm jobs
    (``frames_li.slurm`` in ``/home/psaxe/li_frames``, 11965-11970: six
    conditions × ρ {0.95, 1, 1.05} × T {298, 358} K → 336 frames; the
    scaled-charge runs, ``make_scaled.py``, 11954/11955); seeded starts
    (``make_liec4.py``, Li(EC)\ :sub:`4`\ :sup:`+` seeds for Packmol); carving
    (``carve_li_cluster.py``, Li⁺-centred neutral clusters within 4.5 Å;
    ``sample_dm.py`` in ``/D3/psaxe/ccsdt_dm``, connected n-mers from MD dumps;
    ``gen_ion_frame.py``, clusters in boxes for the cell pipeline -- Extract
    Clusters covers part of this); reference-cell analysis (the density from
    ⟨P⟩ through −P/K_T, block-averaged from ``nvt_state.trj``, never the stored
    scalars).

    *Needed:* an **MD frame-pool step** on top of the LAMMPS step (a grid of
    conditions, frames per condition, decorrelation spacing); Extract Clusters
    options for ion-centred, charge-neutral carving and for sampling connected
    n-mers with a stated distribution, recording the sampler's distribution
    against the liquid's (2026-10-16: the motif-balanced sampler put 33 % of
    triples in closed triangles, against 5 % in the liquid).

    *Packmol losing the P-F bonds of a second configuration source (ChemAI
    5260, 2026-10-10)* was fixed in packmol-step 2026.10.10 and molsystem
    2026.10.10.

3.4 **Validation** (science, with mlff) -- priority 4.

    *Outside SEAMM today:* ``analyze_liquid.py`` (ρ, g(r), ΔH_vap through
    ``model.json``'s ``e_monomer_min``; generalized for ``nper``/``msite``);
    ``mlff_dipoles.py``, ``eps_both.py``, ``ct_check.py`` (the dielectric
    constant from the LES latent dipoles, the 4×4 channel matrix, a
    charge-transfer check; Falcon ``/projects/seamm/psaxe/liqval_mlff`` and
    ChemAI); ``analyze_nacl_md.py`` (CIP/SSIP with a fixed cutoff,
    coordination numbers); the same-resolution g_OO against Skinner
    (``~/Sites/mlff-training/2026-09-16_trimer-mlff-liquid-density/skinner_same_resolution.py``,
    Q_max 21.8, variable Lorch; mlff's ``skinner_cmp.py`` is a copy); mlff's
    frozen-frame committee comparison of molecular and atomic pressure
    (``pmol.py``, ``/D3/psaxe/mlff_scores/pmol``: whole molecules about their
    centres of mass, and the virial-theorem check
    ⟨P_mol − P_atom⟩ = 2N·kT/V).

    *Needed,* as options of ``seamm_md_analysis`` or the Density step: g(r) at
    the resolution of a stated experimental reference; block-averaged density
    with block-size errors; molecular against atomic pressure; evaluating
    committee A on trajectory B.

    *Blocker:* the LES dipole/BEC question (2026-10-14), which decides whether a
    dielectric constant or IR spectrum from the latent charges is usable at all.

3.5 **Training** (mlff; *to confirm*). ``seamm-al train`` as a flowchart step
    that submits the committee members as GPU tasks through the task layer
    (ChemAI's GPUs, ARC's A100s), with the checkpoints and the recipe stored as
    the model's provenance.

3.6 **Models** (mlff; *to confirm*). Registering a trained committee as an
    xnn_step model chemistry (name, checkpoints, provenance), and the
    distribution design (``.mlff.json`` sidecar and catalog; waits on Sina).

3.7 **Labelling, from science.** Every label pipeline records VeryTightSCF and
    the NoCOSX element list as checked parameters: TightSCF's error on isolated
    monomers (−0.05 kJ/mol each, not additive) cost a day on 2026-10-16.

3.8 **Infrastructure shared by all stages.** The time estimates and their check
    (seamm-exec 2026.10.16-2026.10.16.2, ``seamm-timing check``); estimating for
    the target's node type (seamm_exec campaign 2026-10-05, phase 5 as revised
    2026-10-16); the GPU MLFF path through SEAMM being 1.5x slower than direct
    (120 against 76 ms/step, ``OMP_NUM_THREADS=1`` suspected, untested);
    job-start validation that catches undefined flowchart variables.

4. Log
------

- 2026-10-16: document started (Paul). Labelling list from mbe; manifest
  archive-reference bug fixed (seamm-exec 2026.10.16.3); ORCA estimates use the
  model again (orca-step 2026.10.16, .1) and record their source (2026.10.16.2).
  mbe's corrections to section 2; science's stages (section 3.1-3.4, 3.7).
