Phase 5: extra commands and extra properties in the MD sub-steps
=================================================================

Status: **implemented** (2026-10-16, lammps_step ace06b2, local; HISTORY 2026.10.16.1), awaiting the PR. Differences from the plan: the Green-Kubo error uses blocks only when each block still reaches the plateau (20 of the fit's slowest time constants); results of Green-Kubo integrals are given in familiar units when their dimensions match (mPa*s, W/(m K), S/m, m^2/s); the extra columns are not checked against the built-in names, since they are prefixed (``x_<name>``). The real check against the Viscosity step on the SPC/E regression is still to run (a 20 ps local run gave 0.48 mPa*s from Pxy alone).

Goal
----

Let a user measure things during an NVE, NVT or NPT run without leaving SEAMM: add
LAMMPS ``compute``, ``fix``, ``variable`` and ``dump`` lines that apply to that
sub-step only, and name quantities to be sampled, analysed and stored like the
built-in ones -- a mean with its error, an autocorrelation, or a Green–Kubo
integral. The design (Paul's notes, 2026-10-14, "A generic hook for custom fixes
and computes") is summarized in the design document under *The LAMMPS step*; this
page is the plan to build it.

The Custom sub-step stays for commands that change the system. Its commands stay in
force for every later sub-step and SEAMM never analyses their output; the new
fields are scoped to one sub-step and analysed.

Where it goes in the code
-------------------------

NVT inherits from NVE and NPT from NVT, and the three repeat the same input
pattern: the thermo and state properties (``properties``/``title2``), the
``fix ave/time`` writing ``<ensemble>_state.trj``, the trajectory dumps, the run,
and numbered ``unfix``/``uncompute``/``undump`` at the end. The heat-flux code is
already shared the same way (``NVE.heat_flux_input`` and ``heat_flux_cleanup``).
The new code follows that pattern: shared methods on ``NVE`` that the three
``get_input`` methods call.

- ``NVE.extra_input(P)``: the user's commands, validated, and the variables that
  wrap the extra properties; returns the lines, the state columns to add, and the
  cleanup lines.
- ``LAMMPS.analyze_trajectory`` (``lammps.py``) handles the new columns with the
  built-ins' code, using units and titles from the property definitions instead of
  ``LAMMPS.display_units``/``display_title``.
- ``md_h5md.py`` writes the new columns as ``observables/user/<name>``.
- ``tk_nve.py`` gets the GUI section, which ``tk_nvt.py`` and ``tk_npt.py``
  inherit.

The Heat Flux sub-step is an NVE run with its own ``get_input``; it does not get
the fields in this phase (see *Open questions*).

1. The parameters
-----------------

Added to the NVE parameters, so NVT and NPT have them too:

- ``extra commands``: a multi-line string, empty by default.
- ``extra properties``: a list (as the Packmol step's ``molecules``), each row a
  dict:

  - ``name``: an identifier (letters, digits and ``_``, starting with a letter),
    unique in the sub-step and not one of the built-in column names.
  - ``expression``: a LAMMPS equal-style expression -- ``c_dip[1]``, ``v_myvar``,
    a thermo keyword such as ``density`` or ``lx``, or arithmetic of these.
  - ``units``: see *Units*.
  - ``treatment``: ``average`` (default), ``autocorrelation`` or
    ``Green-Kubo integral``.
  - ``prefactor``: for a Green–Kubo integral only (see *Treatments*).
  - ``store``: whether the mean (or integral) is saved as a property of the
    configuration (see *Results*); off by default.

Flowcharts written before have neither, and behave as now.

2. The input
------------

``extra_input`` puts, after the ensemble's own fix and before the sampling fixes
(so that the sampling can refer to what the user defined):

#. The user's commands, as written, after checking them:

   - Only ``compute``, ``fix``, ``variable`` and ``dump`` lines, comments and blank
     lines are allowed; continuation lines (``&``) are joined first. Anything else
     (``group``, ``thermo_modify``, ``run``, ``unfix`` ...) is refused with a
     message pointing to the Custom sub-step.
   - Each defined ID (fix, compute, dump) or variable name is recorded. IDs that
     are all digits, or that SEAMM uses itself (the numbered fixes, ``S_p``,
     ``flux_p``, ``hb`` and the other names in the generated input), are refused,
     so the user's cleanup can never remove SEAMM's.

#. For each extra property, ``variable seamm_x_<name> equal <expression>``. The
   wrapper makes every kind of expression samplable by ``fix ave/time``, which
   takes only ``c_``, ``v_`` and ``f_`` references, and lets LAMMPS report a bad
   expression at the start of the run rather than at the first sample.

#. ``v_seamm_x_<name>`` is appended to the properties of both ``fix ave/time``
   lines (summary and state), with the column title ``x_<name>``.

After the run, before SEAMM's own cleanup: ``uncompute``, ``unfix`` and ``undump``
for each recorded ID, and ``variable <name> delete`` for each user variable and
each wrapper, in the reverse order of definition (a fix may use a compute).

3. Units
--------

An MLFF run uses LAMMPS's ``metal`` units and a classical forcefield ``real``, so an
expression's units depend on the forcefield. The ``units`` field therefore takes
either:

- **a LAMMPS quantity** -- ``energy``, ``pressure``, ``temperature``,
  ``distance``, ``volume``, ``density``, ``time``, ``velocity``, ``force``,
  ``charge``, ``dipole``, or ``dimensionless`` -- converted from the run's unit
  style by ``lammps_units.py``, so the same flowchart works with either kind of
  forcefield (**recommended**, and the default ``dimensionless``); or
- **an explicit unit** (``atm``, ``kcal/mol``, ``Debye`` ...), taken as the units
  of the value LAMMPS reports, with a note in the GUI that it is then the user's
  job to match the forcefield's unit style.

Results are converted to SEAMM's preferred units for the quantity, as for the
built-in columns.

4. Treatments
-------------

All three run on the production part of the series, after the equilibration that
pymbar detects, as for the built-in properties.

- **Average:** exactly the built-in analysis -- mean, standard error, statistical
  inefficiency, correlation time, the time-series and ACF graphs, and a row in the
  printed table.
- **Autocorrelation:** in addition, the normalized autocorrelation function with
  its error (``seamm_md_analysis.correlate.autocorrelation_functions`` and
  ``acf_err``), its integrated correlation time, and a graph.
- **Green–Kubo integral:** ``prefactor × ∫⟨δA(0) δA(t)⟩ dt``, fitted with
  ``seamm_md_analysis.transport.fit_green_kubo_integral`` as the Viscosity and
  Thermal Conductivity steps do, with its error and the running-integral graph.
  The prefactor is one of ``V/kT`` (stress-like, as for the viscosity),
  ``V/kT²`` (heat-flux-like), ``1/(V kT)`` (current-like, as for the ionic
  conductivity) or ``a value with units``. The result's units are those of
  prefactor × A² × time. The step warns when the sampling interval is not well
  below the correlation time, since the integral then has little meaning.

5. Storage and results
----------------------

- **H5MD:** each property is written to ``observables/user/<name>`` (step, time,
  value) with its unit and the attributes ``seamm_expression`` and
  ``seamm_treatment``; the ``_md_runs`` record lists them, so a later analysis step
  can find them by name.
- **Printed output and graphs:** as for the built-in properties, under the
  property's own name and units.
- **Results:** the step's results metadata is fixed, so per-name results cannot be
  offered for variables and tables the usual way. The plan: one result,
  ``extra properties``, holding a dict per name (mean, error, units, and the
  correlation time or integral) for variables and the job's JSON; and, for rows
  with ``store`` on, a property of the configuration named
  ``<name>#LAMMPS#{model}``, created on first use (see *Open questions*).

6. The GUI
----------

A collapsible "Extra commands and properties" section in the NVE, NVT and NPT
dialogs (in ``tk_nve.py``):

- a text box for the commands;
- a table with a row per property (as the Packmol step's molecules table):
  name, expression, units (a combobox of the quantities, also accepting an
  explicit unit), treatment (a combobox), the prefactor -- **shown only for a
  Green–Kubo integral**, per the GUI rule -- and the store checkbox; add and
  remove buttons.

The dialog checks names and commands as they are entered (the rules in 1 and 2),
and the same checks run when the flowchart is checked before a job
(``check_flowchart``) and at run time, as a backstop for hand-edited flowcharts.

7. Tests
--------

- **Input:** generated lines for each sub-step; IDs and variables collected and
  cleaned up in reverse order; continuation lines and comments; refused command
  words and ID clashes; the wrapper variables and the extra state columns.
- **Analysis:** a synthetic state file with a user column of known statistics
  (mean and error; an exponentially correlated series whose ACF and Green–Kubo
  integral are known analytically), in both unit styles.
- **H5MD:** the ``observables/user`` datasets and attributes, read back through
  ``seamm_md_analysis.io``.
- **GUI:** the dialog built headlessly and ``reset_dialog`` run over every
  treatment (the prefactor shown only for Green–Kubo).
- **Run path:** a small LAMMPS run (a few hundred atoms, locally) through
  ``seamm_exec.testing`` with, for example, ``compute msd`` and an extra property
  on ``c_msd[4]``.
- **Real check:** on ARC or ChemAI, the shear viscosity of the SPC/E regression
  cell as a user Green–Kubo integral of ``pxy`` with prefactor ``V/kT``, against
  the Viscosity step's value on the same run (it uses five components, so the
  one-component value agrees within its larger error).

8. Releases
-----------

lammps-step only; seamm-md-analysis already has the functions needed. The user guide
gets a section with three worked examples (a custom energy average, the MSD, a
Green–Kubo integral). Released, then rolled out with the usual checks and gating.

Decisions (Paul, 2026-10-16)
----------------------------

#. **Command words:** ``compute``, ``fix``, ``variable`` and ``dump`` only; no
   ``group``, which would persist into later sub-steps.
#. **Units:** LAMMPS quantities are the recommended form; explicit units are
   accepted.
#. **Vector properties:** not in this phase; averaging components in the
   autocorrelation and Green–Kubo treatments comes with the dielectric constant
   (phase 7).
#. **Stored properties:** both the ``extra properties`` result and, per row, an
   optional configuration property, off by default.
#. **Heat Flux sub-step:** left until its input is reworked onto the shared code.

The questions as they were put
------------------------------

#. **Allowed command words.** ``compute``, ``fix``, ``variable`` and ``dump`` only,
   as designed? ``group`` is the obvious candidate to add (a compute on a group of
   atoms), but a group persists and changes the system's definition for later
   sub-steps.
#. **Units.** LAMMPS quantities as the recommended form, with explicit units
   allowed (as above), or quantities only?
#. **Vector properties.** Green–Kubo integrals are usually averaged over components
   (the dipole's x, y, z; several stress components). Allow an expression list,
   ``c_dip[1], c_dip[2], c_dip[3]``, whose components' correlation functions are
   averaged, in this phase -- or keep phase 5 scalar and add it with the dielectric
   constant (phase 7)?
#. **Stored properties.** Create configuration properties named by the user on
   the fly (``<name>#LAMMPS#{model}``), or only the ``extra properties`` result?
#. **The Heat Flux sub-step.** Give it the same fields now, or leave it until it is
   reworked onto the shared input?
