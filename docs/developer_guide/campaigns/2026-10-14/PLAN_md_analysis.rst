The design
==========

Status: **agreed** (2026-10-14). Phases 1-4 are released (2026-10-14 to 10-16) and
rolled out to every installation; phase 5 (lammps-step 2026.10.16.1, with the SHAKE fix in 2026.10.16.3) and phase 6 (liquid-structure-step 2026.10.16) are released; phase 7 is planned (``PLAN_phase7_dielectric.rst``).
See *Phases* for the releases.

Decisions already made
----------------------

Paul, 2026-10-14:

#. **The contract is general enough for GROMACS.** A GROMACS step is not part of this
   campaign, but nothing in the analysis may depend on LAMMPS's files or commands.
#. **MDAnalysis is an acceptable dependency** for analysis steps, as are MDAKits such
   as SolvationAnalysis. Neither becomes a dependency of core SEAMM.
#. **One H5MD file per MD run** holds the trajectory (if one was sampled), every time
   series as an H5MD *observable*, the run's parameters and SEAMM's provenance. A run
   without a trajectory still writes the file, containing only observables. That is
   valid H5MD, though it may surprise people at first.
#. **SEAMM writes the H5MD file from the code's native output** at the end of each
   run or segment. During the run the code writes its usual files, so crash safety
   and following a run with ``tail`` are unchanged.
#. **Native files are kept after conversion at first.** Once the conversion is
   trusted, the default becomes deleting them.

After reviewing the design:

6. **The analyses are separate steps** (Viscosity, Structure, Dielectric constant, and
   so on) built on the shared library, not one "Liquid properties" step.
7. **The names:** ``seamm_md_analysis`` for the library, ``md.h5md`` for the file, and
   ``_md_runs`` for the workspace variable.
8. **Diffusivity uses the viscosity from a preceding Viscosity step by default** for
   the Yeh–Hummer correction, and the user can override it with a value of their own.
9. **Non-periodic systems** must at least not cause problems (see *Non-periodic
   systems*).

Where things stand
------------------

Checked in the code on 2026-10-14:

* **LAMMPS sampling.** The NVE, NVT and NPT sub-steps (``nve.py``, from which the
  other two inherit) can sample:

  - a trajectory as ``trajectory.dump_trj.gz``: ``id element [q] xu yu zu``, plus
    optional forces and velocities;
  - thermo and the pressure tensor alongside it (``trajectory.trj``);
  - atomic positions and velocities (``atomic_*.dump_trj``);
  - molecular centre-of-mass positions and velocities (``com_*.trj``, from
    ``chunk/atom molecule``);
  - the heat flux (``heat_flux.trj``, already converted to W m⁻²);
  - the shear stress: ``Pxy Pxz Pyz`` only (``shear_stress.trj``).

  Each ``.trj`` file starts with a ``!MolSSI trajectory 2.0`` line holding a JSON
  header (``code``, ``type``, ``dt``, ``tunits``, ``nsteps``), followed by column
  names. **The columns have no units.** They are implicitly in the LAMMPS unit style
  of the run.
* **Thermo statistics.** ``LAMMPS.analyze_trajectory`` uses pymbar's
  ``detect_equilibration`` and ``subsample_correlated_data`` on the state file to
  report each property as mean ± error, together with its equilibration time.
* **"Run until converged" exists only in the GUI.** ``nve_parameters.py`` defines
  ``run_control`` with that choice and ``tk_nve.py`` shows it, but nothing in the run
  code reads it. Every run has a fixed length.
* **The Custom sub-step** inserts a script verbatim. Its fixes and computes stay in
  force for every later sub-step, and SEAMM never analyses their output.
* **diffusivity_step and thermal_conductivity_step** each wrap a sub-flowchart and run
  it ``nruns`` times as independent replicas. They find their input by globbing for a
  filename: ``**/com_positions.trj`` (falling back to ``atomic_positions.dump_trj``)
  and ``**/com_velocities.trj``, or ``**/heat_flux.trj``. If the user forgot to turn
  that sampling on, the step finds nothing, but only after all the MD has run.
* **The helper code has been copied between the two and has drifted:** ``fmt_err``
  (with different signatures), ``axb``, ``create_helfand_moments``, the
  Helfand-moment fits and plots, and the readers ``read_dump_trajectory`` and
  ``read_vector_trajectory`` (in diffusivity only).
* **trajectory_analysis_step** is an unfinished stub from 2021.
* **Whole-flowchart checks.** ``seamm.builder.validate`` checks a flowchart as a
  whole; today it only checks that a Model Chemistry step comes first. It is called
  by ``seamm flowchart validate`` and by the MCP tools, but **not** by the Tk editor
  or ``run_flowchart``.

H5MD facts checked on 2026-10-14
--------------------------------

* **HDF5 file locking** works correctly on ARC ``/projects`` and home (NFS,
  HDF5 2.0) and on ChemAI ``/home`` (ext4) and ``/D3`` (ZFS, HDF5 2.1). A second
  writer is refused, a reader can open the file with ``locking=False``, and there
  were no spurious "unable to lock file" errors.
* **HDF5 1.14.6 reads files written by 2.0**, even with ``libver="latest"``.
* **h5py is already in every SEAMM installation**, because vasp_step requires it.
* **LAMMPS's own** ``dump h5md`` (our conda-forge build, 29 Aug 2024):

  - writes no unit attributes anywhere;
  - stores positions as uncompressed float64;
  - supports only orthogonal boxes (its error message says the opposite).

  MDAnalysis refuses the file unless ``convert_units=False``. **SEAMM therefore
  writes the H5MD file itself.**
* **MDAnalysis 2.10** reads a SEAMM-written H5MD file, including a triclinic box,
  units, gzip compression, float32 positions and appended frames, with three
  conditions:

  - **It needs a topology.** We build it from the molsystem configuration
    (``Universe.empty`` plus ``load_new``).
  - **It accepts only its own unit spellings**, such as ``Angstrom`` and
    ``Angstrom ps-1``.
  - **It attaches observables to frames by index, ignoring each observable's own
    step and time.** An observable sampled more often than the frames is silently
    misaligned: with temperature every 5 steps and frames every 20, frame 1
    (step 20) was given the temperature from step 5. **High-rate time series must
    therefore be read with h5py on their own time axis, never through MDAnalysis's
    per-frame data.**

Overview
--------

::

    MD step (LAMMPS now, GROMACS later)
      │  native output during the run (dump, .trj, log)
      │  at the end of each run or segment: convert ──► <sub-step dir>/md.h5md
      │  add a record to the workspace variable _md_runs
      ▼
    analysis steps (Diffusivity, Thermal conductivity, Viscosity, Structure, ...)
      │  mode "run replicas":           wrap the MD in a sub-flowchart, as now
      │  mode "analyse preceding MD":   read the records in _md_runs
      ▼
    seamm_md_analysis library
      readers (H5MD; legacy .trj and dump), statistics, correlations,
      Green–Kubo and Helfand fits, block and replica errors, graphs
      MDAnalysis Universe from molsystem + H5MD, for structural analysis
      ▼
    results: SEAMM properties, tables, .graph files

The data contract: SEAMM's H5MD layout
--------------------------------------

**The file.** Each NVE, NVT or NPT sub-step writes ``md.h5md`` in its own directory.
It is H5MD 1.1 written with h5py, with the file format pinned to
``libver=("earliest", "v110")``. It is written to ``md.h5md.tmp`` and then
renamed (``os.replace``), so an interrupted conversion never leaves a damaged file
under the real name.

.. list-table::
   :header-rows: 1
   :widths: 34 46 20

   * - Path
     - Contents
     - Required
   * - ``h5md/`` (attribute ``version`` = 1.1)
     - ``creator`` (``SEAMM <step>``, its version) and ``author`` (the job's user).
     - yes
   * - ``h5md/modules/units``
     - Declares that unit attributes are present.
     - yes
   * - ``particles/all/box``
     - ``dimension`` 3, ``boundary`` periodic or none; ``edges`` as a 3×3 matrix
       (rows are the cell vectors). It is time-dependent for NPT runs and fixed
       otherwise.
     - yes
   * - ``particles/all/id``, ``species``, ``mass``, ``charge``
     - Fixed per run: the SEAMM atom ids in configuration order, atomic numbers,
       masses, and the forcefield charges. ``charge`` is omitted when the model
       supplies no charges (MLFFs).
     - id, species, mass
   * - ``particles/all/position``
     - **Unwrapped** positions (attribute ``seamm_unwrapped = 1``, no ``image``
       dataset), float32, in Angstrom.
     - if sampled
   * - ``particles/all/velocity``, ``force``
     - float32.
     - if sampled
   * - ``particles/molecules/position``, ``velocity``
     - Centre-of-mass positions and velocities of the molecules, with
       ``particles/molecules/id`` giving the molecule's index in the configuration.
     - if sampled
   * - ``observables/<name>``
     - The time series, each with its own ``step``, ``time`` and ``value``. Names
       are listed in the next table.
     - each as sampled
   * - ``observables/user/<name>``
     - The user's extra properties (see *The LAMMPS step*).
     - if defined
   * - ``parameters/``
     - Attributes: ensemble, temperature, pressure, timestep, thermostat and its
       damping, barostat, number of steps.
     - yes
   * - ``parameters/seamm/``
     - Provenance: job id, step id and title, configuration id, model chemistry,
       code name and version, the SEAMM package version, hashes of model files,
       and a segment table (first and last step, wall time and node of each
       segment).
     - yes

**Standard observable names.** Analysis steps ask for these names. The MD steps map
their own output onto them.

.. list-table::
   :header-rows: 1
   :widths: 26 14 22 38

   * - Name
     - Shape
     - Units written
     - Notes
   * - ``temperature``
     - scalar
     - ``K``
     -
   * - ``pressure``
     - scalar
     - code's (``atm``)
     -
   * - ``pressure_tensor``
     - 3×3
     - code's (``atm``)
     - The full symmetric tensor (see the LAMMPS changes below).
   * - ``total_energy``, ``kinetic_energy``, ``potential_energy``
     - scalar
     - code's (``kcal mol-1``)
     - The LAMMPS ``emol`` and ``epair`` terms go under the same names as the code
       uses (``molecular_energy``, ``pair_energy``).
   * - ``volume``, ``density``
     - scalar
     - ``Angstrom3``, ``g cm-3``
     -
   * - ``heat_flux``
     - 3
     - ``W m-2``
     - Already converted in the LAMMPS input.
   * - ``total_dipole``
     - 3
     - ``e Angstrom``
     - New. Needs charges.
   * - ``hbond_count``, ``hbond_energy``
     - scalar
     -
     - DREIDING hydrogen bonds, when present.

**Units.** Every ``value`` and ``time`` dataset carries a ``unit`` attribute.

- Values are stored in the units the code produced, with no lossy conversion. They
  are converted on reading with pint.
- Unit strings use H5MD's syntax (space-separated factors, negative powers as
  ``-1``), with MDAnalysis's spellings for lengths, so that MDAnalysis can read
  trajectories: ``Angstrom``, ``Angstrom ps-1``, ``fs``.
- The library owns the translation of these strings to pint, with tests.

**Rates.** Each observable and each particle property has its own sampling rate.
An observable produced by on-the-fly averaging in the code has an attribute
``seamm_average_window``, the number of MD steps it averages over. It is 1 for
instantaneous values, which are the default.

**Storage.**

- Positions, velocities and forces are float32, chunked by frame, and not
  compressed by default, since gzip gains little on coordinates. A setting turns
  compression on.
- Observables are float64 with gzip and shuffle. Even a million points of a 3×3
  tensor take only about 70 MB before compression.
- Only the standard gzip filter is used, because readers may not have plug-in
  filters.

**Segments.** When a run is split into segments (for "run until converged", for
restarts, or for preemption):

#. Each segment is converted into ``md.seg-NNNN.h5md`` as soon as it ends.
#. At the end of the sub-step the segments are joined into ``md.h5md``, through a
   temporary file and a rename, and the segment files are removed.
#. The library reads either one file or the list of segments, so analysis works on a
   run that has not finished.

Appending to a single file in place was rejected because a crash during the append
would put everything written so far at risk. HDF5 virtual datasets were also
rejected as needless complexity.

**Native files.** A LAMMPS setting, "keep native MD output", is ``yes`` for now and
will later change to ``no``. The text summaries and ``.graph`` files that people look
at are unchanged in either case.

**File locking.** Nothing special is needed on our systems. Readers open the files
read-only. If a site does show locking errors, the fix is
``HDF5_USE_FILE_LOCKING=FALSE`` in the environment section of that installation's
ini file; this is documented, not set by default.

How analysis finds the data: ``_md_runs``
-----------------------------------------

Globbing for filenames is replaced by an explicit record. After converting, each MD
sub-step appends one entry to the workspace variable ``_md_runs``:

.. code-block:: python

    {
        "path": "<absolute path to md.h5md>",
        "step": "<step id and title>",
        "code": "LAMMPS",
        "ensemble": "NVT",
        "configuration": "<system/configuration ids>",
        "particles": {"position": "1 ps", "velocity": None, ...},
        "observables": {"pressure_tensor": "5 fs", "temperature": "5 fs", ...},
        "time": ["0 ps", "2000 ps"],
    }

An analysis step in mode B ("analyse preceding MD") chooses its input with a
**Source** parameter:

- **the last MD run** (the default);
- **all MD runs of the last MD step**, for production split into several sub-steps;
- **all MD runs since the start of the enclosing loop**, which treats repeated runs
  in a Loop step as replicas (see *Two modes*);
- **file(s)**, a path or a ``job://<n>/...`` reference to another job's
  ``md.h5md``, to analyse old runs.

Requirements and catching mistakes before the MD runs
-----------------------------------------------------

The flowchart editor should make invalid combinations impossible to pick rather than
catch them at run time. For analysis this means the user cannot forget to sample what
the analysis needs. Two small protocols are added:

- **MD sub-steps** implement ``md_provides(P)``, which returns what they will write:
  each particle property and observable, with its sampling interval.
- **Analysis steps** implement ``md_requirements(P)``, which returns what they need:
  names, the longest acceptable sampling interval (for example 5 fs for a Green–Kubo
  pressure tensor), and optionally the shortest useful run length.

How they are used:

- **Mode A (replicas).** At run time the analysis step walks its sub-flowchart and
  turns on whatever sampling the MD sub-steps lack, through
  ``request_sampling(name, interval)``. It prints what it changed. The user can no
  longer forget it.
- **Mode B (preceding MD).** There are two checks:

  - **In the GUI.** The analysis step's dialog compares its requirements with
    ``md_provides`` of the MD sub-step it will read, shows a warning line for each
    gap, and offers a button to turn the sampling on in that sub-step.
  - **In the flowchart check.** ``seamm.builder.validate`` gets a generic hook,
    ``node.check_flowchart(preceding)``, which the analysis steps implement. This
    catches flowcharts that were edited by hand or built by scripts.

- **Run validate before the run.** The flowchart check is called by the Tk editor
  before submitting, and by ``run_flowchart`` before the first step. A missing
  requirement stops the job before the MD runs rather than after it. This is a
  change to core seamm and is useful beyond analysis.

Two modes for each analysis step
--------------------------------

- **Mode A, "run replicas":** as now. The step wraps the MD in a sub-flowchart, runs
  it N times, and takes the error bars from the spread of the replicas.
- **Mode B, "analyse preceding MD":** the step reads ``_md_runs``. Error bars come
  from block averages over the run, or from the spread across runs when the Source
  includes several. One production run can then feed several analyses:

  ::

      LAMMPS (NPT equilibration, NVT production)
        → Viscosity → Diffusivity (Yeh–Hummer from the viscosity)
        → Dielectric constant → Structure

Mode B with a Loop step around the LAMMPS step gives replicas without a wrapping
step. Mode A may eventually become a convenience on top of this, but it stays for
now, because existing flowcharts use it.

The shared library: ``seamm_md_analysis``
-----------------------------------------

A new library package. Per the usual rule, it is released before the steps that pin
it. It holds one copy of everything currently duplicated, plus the H5MD reader.

.. list-table::
   :header-rows: 1
   :widths: 20 80

   * - Module
     - Contents
   * - ``io``
     - ``open_md(paths)`` returns an ``MDData`` for one file or a list of segment
       files, with:

       - ``observable(name, units=None)``, which returns a ``TimeSeries`` (values,
         times, pint units, averaging window), read by h5py on the observable's own
         time axis;
       - ``observables()``, ``parameters``, ``provenance``;
       - ``iter_frames(group, fields, chunk)`` for streaming frames;
       - ``universe(configuration)``, which builds an MDAnalysis ``Universe`` from
         the molsystem configuration (atoms, elements, masses, charges, bonds,
         molecules as residues) and loads the H5MD trajectory. MDAnalysis is
         imported here only.

       The legacy readers for ``.trj`` and ``.dump_trj`` files are also here, so old
       jobs can still be analysed.
   * - ``stats``
     - Equilibration detection and statistical inefficiency (wrapping pymbar), block
       averages, mean ± error, combining replicas, and a single ``fmt_err``.
   * - ``correlate``
     - FFT auto- and cross-correlation functions and their error estimates.
   * - ``transport``
     - Green–Kubo integrals and their fits; Helfand moments and slope fits; MSD by FFT
       (centre of mass or chunked over atoms); the Yeh–Hummer correction. Each
       returns an ``Estimate`` (value, error, units, details for plotting).
   * - ``plots``
     - The plotly figures written as ``.graph`` files: correlation functions,
       Green–Kubo integrals, Helfand moments, MSD.

- **Dependencies:** numpy, scipy, pymbar, h5py and pint, all already present in
  SEAMM installations. MDAnalysis is an optional extra (``seamm-md-analysis[structure]``)
  required only by the steps that use it.
- **Memory:** trajectories are always streamed, never loaded whole. Observables are
  small enough to read whole.
- **Tests:** synthetic series with known answers. For example, an
  Ornstein–Uhlenbeck process has a known Green–Kubo integral, and a random walk has a
  known MSD slope. H5MD round trips are tested, as is a regression test that the
  MDAnalysis observable trap does not reach our results.

The LAMMPS step
---------------

#. **The H5MD writer.** At the end of each NVE, NVT or NPT run (and later each
   segment), the step streams the native files into ``md.h5md``:

   - Units come from the run's LAMMPS unit style (``lammps_units.py``).
   - Triclinic boxes are handled.
   - The step adds its record to ``_md_runs``.
   - LAMMPS's own ``dump h5md`` is not used, for the reasons above.

#. **The full pressure tensor** replaces the three-component shear-stress sampling.
   Viscosity by Green–Kubo then averages five independent components (``Pxy``,
   ``Pxz``, ``Pyz``, ``(Pxx−Pyy)/2`` and ``(Pyy−Pzz)/2``) rather than three, which
   improves the statistics at no extra cost. The old "shear stress" choice maps onto
   the new one, so existing flowcharts keep working.
#. **Total dipole** sampling, using the forcefield charges. It is not offered for
   MLFFs until the engine can return charges over MDI.
#. **Extra commands and extra properties** in the NVE, NVT and NPT sub-steps (designed
   earlier on 2026-10-14):

   - *Extra commands:* ``compute``, ``fix``, ``variable`` and ``dump`` lines that
     apply to that sub-step only; SEAMM issues ``unfix``/``uncompute`` at its end.
   - *Extra properties:* name, LAMMPS expression, units, and the treatment (average,
     autocorrelation, or a Green–Kubo integral with a prefactor). They are sampled
     with the built-in properties into ``observables/user/<name>``, and get the same
     graphs, mean ± error and results.

#. **On-the-fly reductions** are used where they save storage. By default the step
   writes the raw series at the rate the analysis needs. ``fix ave/correlate/long``
   is used only when the raw series would be too large. Its output is stored as an
   observable with ``seamm_average_window`` and a ``seamm_kind = "correlation"``
   attribute, and the library accepts either form. Structural quantities such as
   g(r) are always computed from the stored trajectory, never on the fly, so they can
   be re-analysed with different settings.
#. **"Run until converged", implemented with segments.** The step runs a segment,
   converts it, and asks the library whether the chosen properties have reached the
   requested accuracy; if not, it runs another segment. The segments are also the
   unit for restarts and for preemption and requeueing in the task layer, so this
   item goes with that work.

The analysis steps
------------------

.. list-table::
   :header-rows: 1
   :widths: 20 30 50

   * - Step
     - Needs
     - Notes
   * - Diffusivity (exists)
     - Molecular COM positions or velocities, or atomic ones
     - Moves onto the library and gains mode B. A new "viscosity" choice for
       Yeh–Hummer: "from the preceding Viscosity step" (the default) or "given
       value". The output says which was used. If no Viscosity step precedes it and
       no value is given, Yeh–Hummer is skipped, with a note.
   * - Thermal conductivity (exists)
     - ``heat_flux`` at ≤ a few fs
     - Moves onto the library and gains mode B.
   * - **Viscosity** (new)
     - ``pressure_tensor`` at ≤ 5 fs
     - Green–Kubo and Helfand, as in Thermal conductivity. Publishes its result for
       Diffusivity.
   * - **Structure** (new, replaces the 2021 stub)
     - Positions at about 0.5–1 ps
     - Partial g(r) and coordination numbers (MDAnalysis ``InterRDF``); solvation
       shells, ion pairing (contact and solvent-separated pairs, aggregates) and
       residence times through SolvationAnalysis.
   * - **Dielectric constant** (new)
     - ``total_dipole`` (or positions and charges)
     - Our own code: MDAnalysis's ``DielectricConstant`` assumes no free charges,
       so it cannot be used for electrolytes. For an electrolyte, use the dipole of
       the neutral molecules or separate out the ionic current; which one is to be
       settled in that phase. Contributing it upstream to MDAnalysis is worth
       considering.
   * - Later
     -
     - Ionic conductivity (Nernst–Einstein and the full Einstein/Green–Kubo form, as
       in mdgo), reorientation times, the vibrational density of states, and dHvap
       (needs an isolated-molecule reference run).

Non-periodic systems
--------------------

The LAMMPS step already runs molecular (non-periodic) systems, with a shrink-wrapped
box (``boundary s s s``). What it does with them today, checked 2026-10-14:

- NPT stops with an error, but only at run time.
- The stress tensor is only sampled for periodic systems.
- The pressure (``v_press``) is still reported. With a shrink-wrapped box its volume
  is meaningless, and so is the pressure.
- Heat-flux and shear-stress sampling are not guarded. Both divide by the box volume.
- Neither Diffusivity nor Thermal conductivity checks for periodicity. Diffusivity
  reads ``cell.a`` for Yeh–Hummer, and Thermal conductivity reads the volume.

Checked with MDAnalysis 2.10, 2026-10-14:

- An H5MD file with ``boundary`` none and **no** ``edges`` reads correctly.
  ``dimensions`` is ``None`` and distances are computed without periodic images.
- **If** ``edges`` **is present**, MDAnalysis treats the box as periodic even when
  the boundary is none, so it would apply minimum-image distances to a molecule.
- ``InterRDF`` fails with a division by zero when there is no box, because g(r) is
  normalized by the density. SolvationAnalysis uses ``InterRDF`` to find its shell
  cutoffs, so it fails the same way.

The design therefore treats periodicity explicitly:

#. **H5MD writer.**

   - For a non-periodic run, ``box`` has ``boundary`` none and **no** ``edges``.
   - The ``pressure``, ``pressure_tensor``, ``volume`` and ``density`` observables
     are not written.
   - ``parameters/seamm`` records the periodicity, as does the run's record in
     ``_md_runs``.

#. **LAMMPS sampling.** For a non-periodic system, heat-flux and pressure-tensor
   sampling are skipped with a warning in the output, and the pressure is no longer
   reported. The GUI cannot hide these choices, because it does not know the
   structure until run time.
#. **Requirements carry periodicity.** ``md_requirements`` can say ``periodic``:

   - required by Viscosity, Thermal conductivity and Diffusivity, since a diffusion
     constant of a cluster is not a bulk property and Yeh–Hummer needs the cell;
   - required by the Dielectric constant, since the fluctuation formula differs for
     a finite sample, which can be added later if wanted;
   - required by the parts of Structure that need a density: g(r) and
     SolvationAnalysis. Coordination numbers within a fixed cutoff and ion-pair
     counts work for both kinds of system, using our own distance code, so Structure
     offers only those for a non-periodic system.

#. **Checking before the MD runs.** Periodicity is only known once the structure
   exists, so the flowchart check cannot catch it. Instead:

   - *Mode A:* the analysis step checks its input structure when it starts, before
     running any replica.
   - *Mode B:* before an MD sub-step runs, it calls ``check_configuration`` on the
     analysis steps that follow it and will read its output: those up to the next MD
     step. Any failure stops the job before the MD with a clear message. As a
     backstop, every analysis step also checks the periodicity recorded in its
     input and stops with a clear message rather than producing a meaningless
     number.

#. **The library** functions that need a volume (Green–Kubo prefactors, g(r)
   normalization, Yeh–Hummer) raise a clear error when given a non-periodic run,
   rather than dividing by a meaningless volume.

GROMACS later
-------------

To feed these analysis steps, a GROMACS step would:

- use the H5MD file GROMACS 2026 writes natively (or convert ``.xtc`` and ``.trr``
  files from older versions);
- add the observables from its ``.edr`` energy file (read with ``pyedr``) under the
  standard names, with the pressure tensor in full;
- add ``parameters/seamm`` and its record in ``_md_runs``;
- implement ``md_provides``.

The topology comes from molsystem, as for LAMMPS. Nothing in the library or the
analysis steps would change.

Phases
------

#. **seamm_md_analysis 1** (*done*: seamm-md-analysis 2026.10.14; diffusivity-step
   and thermal-conductivity-step 2026.10.15): ``stats``, ``correlate``,
   ``transport``, ``plots`` and the legacy readers. Diffusivity and Thermal
   conductivity move onto it with no change for users; the regression tests check
   that the numbers are the same on stored test data.
#. **H5MD** (*done*: seamm-md-analysis 2026.10.15, lammps-step 2026.10.15.1,
   diffusivity-step and thermal-conductivity-step 2026.10.15.1):

   - the non-periodic fixes in the LAMMPS step (pressure, heat flux and stress
     sampling) and the periodicity checks in the two existing steps;
   - the ``io`` module, with the layout written down as a specification page in the
     library's documentation;
   - the LAMMPS writer and ``_md_runs``;
   - Diffusivity and Thermal conductivity read H5MD, falling back to the legacy
     files.

#. **Requirements** (*done*: seamm-md-analysis 2026.10.15.1, seamm 2026.10.15,
   lammps-step 2026.10.15.2, diffusivity-step and thermal-conductivity-step
   2026.10.15.2):

   - ``md_provides`` / ``md_requirements``, including periodicity, and
     ``check_configuration``;
   - the ``check_flowchart`` hook in ``seamm.builder.validate``, called from the Tk
     editor and ``run_flowchart``;
   - automatic sampling in mode A;
   - mode B in both existing steps.

#. **Viscosity** (*done*: seamm-md-analysis 2026.10.15.2, lammps-step 2026.10.15.3,
   viscosity-step 2026.10.15 with the SPC/E regression in 2026.10.15.1,
   diffusivity-step 2026.10.15.3; follow-ups on 2026-10-16: the heat flux of liquids
   corrected and rigid models from the forcefield in lammps-step 2026.10.16,
   seamm-md-analysis and thermal-conductivity-step 2026.10.16): the full pressure
   tensor in LAMMPS, the Viscosity step, and Yeh–Hummer using its result.
#. **Extra commands and extra properties** in the LAMMPS MD sub-steps (*implemented*,
   lammps_step PR #131; the plan is ``PLAN_phase5_extras.rst``).
#. **Structure:** the Liquid Structure step (*done*: liquid-structure-step
   2026.10.16; the plan is ``PLAN_phase6_structure.rst``).
#. **Dielectric constant:** the step, and the ionic conductivity (*next*; the
   detailed plan is ``PLAN_phase7_dielectric.rst``).
#. **Segmented runs:** "run until converged", restarts, and preemption with the task
   layer.

Each phase is released before the next starts, with the library released before the
steps that pin it.

Validation
----------

- The library tests use synthetic data with known answers (above).
- Run-path tests through ``seamm_exec.testing`` for the LAMMPS writer and each mode.
- **Real data:** re-analyse a science production run with the new steps and compare
  with their scripts' viscosity, diffusion constants and coordination numbers. Small
  LAMMPS test runs (a few hundred atoms) can run locally; anything larger runs on ARC
  or ChemAI.

Open questions
--------------

#. **Should the electrolyte dielectric constant be contributed to MDAnalysis** rather
   than kept in SEAMM?
#. **Should running ``validate`` before every job be a separate, earlier change to
   core seamm?** It would also catch the Model Chemistry ordering problem at run
   time.
