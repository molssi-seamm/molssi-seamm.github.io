.. _notes-mopac-mdi-validation:

=====================================================
Validation Notes: MOPAC Native MDI Engine for LAMMPS
=====================================================

:Date: 2026-06-16/17
:Status: Forces and periodic stress validated; coupled NPT dynamics validated
   qualitatively. Three bugs found across MOPAC and MDI_Library during this
   session.

.. contents:: Contents
   :depth: 3
   :local:


Purpose
=======

This note documents the first end-to-end validation of MOPAC's native MDI
engine (``-DMDI=ON``) as the QM driver for LAMMPS molecular dynamics, as
proposed in :ref:`plan-qm-mdi-lammps`.  Three independent bugs were found
and locally patched during this process — one in MOPAC's force output, one
in MOPAC's stress-calculation gating logic, and one in MDI_Library's unit
conversion factors. All three are documented below with enough detail to
reproduce, report upstream, and re-apply after a future MOPAC/MDI_Library
update.


Environment and build configuration
====================================

Conda environment: ``seamm-lammps-mopac``

* MOPAC: built from source, ``cmake -DMDI=ON``, version 23.2.5
  (git hash ``052691223d19935a89f0fe18cd12301bd83e4201``), installed into
  the conda environment via ``cmake --install . --prefix $CONDA_PREFIX``
  (overwriting the non-MDI conda-forge MOPAC build).
* LAMMPS: built from source, ``-DPKG_MDI=ON -DPKG_MOLECULE=ON
  -DBUILD_MPI=ON``, version "29 Aug 2024", installed into the same conda
  environment.
* MDI_Library (``libmdi``): the conda-forge build of ``pymdi``/``libmdi``
  was **not** compiled with MPI support, which initially caused LAMMPS to
  segfault in its ``Universe`` constructor on ``MDI_Init``. MOPAC's own
  internal MDI implementation calls MPI directly and was unaffected by
  this, which is why MOPAC alone appeared to work before LAMMPS was
  brought into the picture.

.. note::

   Build/deployment gotchas encountered along the way, kept here for
   reference since they cost real debugging time:

   * Both MOPAC and LAMMPS must link against the **same** ``libmdi`` via
     ``@rpath``/RPATH resolution (``otool -L`` / ``otool -l`` to confirm).
   * MOPAC's launcher binary is a thin executable that loads
     ``libmopac.2.dylib`` at runtime; a stale conda-installed
     ``libmopac.2.dylib`` can silently shadow a freshly-built one unless
     the new build is installed over it via ``cmake --install``.
   * ``mpirun --mca mpi_yield_when_idle 1`` avoids both processes
     spin-waiting at 100% CPU between MDI exchanges.
   * ``comm_modify cutoff 2.0`` and ``fix_modify <fix_id> virial yes`` (in
     addition to the ``virial yes`` keyword on the ``fix mdi/qm`` line
     itself) are both required for the QM stress contribution to reach
     LAMMPS's global pressure/thermo output — ``virial yes`` only
     controls whether ``<STRESS`` is requested over MDI at all.


Bugs identified and fixed
==========================

Bug 1 — ``<FORCES`` sends the gradient, not the negated force
----------------------------------------------------------------

**Location**: ``src/mdi/mdi_implementation.F90``, ``CASE( "<FORCES" )``

**Symptom**: NVT dynamics on an already-optimized structure ran away
explosively — total energy climbed from -42 to beyond +100,000 kcal/mol
within ~12 timesteps. This is the signature of a positive-feedback force
error: small thermal perturbations away from the minimum were reinforced
rather than restored.

**Root cause**: the handler populated the array sent under ``<FORCES``
directly from MOPAC's internal ``grad`` array (the energy gradient,
dE/dx, the same quantity reported by the ``GRADIENTS`` keyword), with no
negation. Force = -gradient; the code sent +gradient.

**Fix applied locally**:

.. code-block:: fortran

   do i=1, nvar
     if (loc(1,i) <= numat) then
       real_array(3*(loc(1,i)-1)+loc(2,i)) = -grad(i)   ! force = -dE/dx
     end if
   end do

**Validation**: with the fix applied, NVT dynamics on the same 102-atom
methanol/PM6-ORG system remained stable over 50 steps, with temperature
oscillating in a damped fashion and total energy bounded (no runaway).
This is a qualitative stability check rather than an explicit
restoring-force perturbation test; the latter would be a useful follow-up
if a more rigorous check is wanted.

**Upstream status**: not yet reported to the MOPAC developers as of this
writing.


Bug 2 — ``calculate_voigt()`` is gated by an unsuitable condition
-----------------------------------------------------------------

**Location**: ``compfg.F90`` (the routine called by
``recompute_as_needed()`` in the MDI engine)

.. code-block:: fortran

   if (lgrad) then
     call deriv (geo, grad)
     if (id == 3 .and. nvar == 3*natoms) call calculate_voigt()
   end if

**Symptom**: ``<STRESS`` always returned exactly zero for a periodic
system under MD (fixed cell), regardless of how much the box was
compressed or expanded — even though MOPAC's batch-mode analytic Voigt
stress calculation (added since the original SEAMM finite-difference
``strain_step`` workaround was written) should have been available.

**Root cause**: ``calculate_voigt()`` is only called when
``nvar == 3*natoms``. ``natoms`` counts the 3 ``Tv`` (translation vector)
entries as pseudo-atoms (``natoms = 105`` for this 102-atom system), while
``nvar`` only counts coordinates flagged as optimization variables
(``+1``). With the ``Tv`` lines flagged ``+0`` (frozen, as is necessary
for MD where LAMMPS — not MOPAC — controls the cell), ``nvar = 306 \ne
315 = 3 \times natoms``, so the condition fails silently and
``calculate_voigt()`` never runs. The condition was apparently written
for the case where MOPAC itself is relaxing the cell as part of a
geometry optimization (in which case ``Tv`` would be flagged ``+1`` and
counted in ``nvar`` too), not for a fixed-cell MD/MDI evaluation.

**Workaround applied** (input file only, no source change): flag all
three ``Tv`` lines as variable (``+1``) in the ``.mop`` file used to
start the MDI engine:

.. code-block:: text

    Tv    10.45715914 +1   0.00000000 +1   0.00000000 +1
    Tv     0.00000000 +1  10.45715914 +1   0.00000000 +1
    Tv     0.00000000 +1   0.00000000 +1  10.45715914 +1

This makes ``nvar == 3*natoms`` (315 == 315) and triggers
``calculate_voigt()`` without MOPAC attempting to actually optimize the
cell — the MDI engine only ever calls ``compfg()`` directly for a single
energy+gradient evaluation, never MOPAC's internal geometry-optimizer
driver loop, so flagging ``Tv`` as variable has no effect beyond
satisfying this bookkeeping check. The existing ``<FORCES`` handler
already filters out any non-atomic gradient components
(``if (loc(1,i) <= numat)``), so this workaround does not contaminate the
returned atomic forces either.

**Upstream status**: Jonathan (MOPAC team) is investigating; current
thinking is to make all degrees of freedom movable automatically whenever
MDI is active, which would make the current input-file workaround
unnecessary in a future MOPAC release.


Bug 3 — ``<STRESS`` unit conversion: wrong GPa→Pa factor and a bad MDI_Library constant
-----------------------------------------------------------------------------------------

**Location**: ``src/mdi/mdi_implementation.F90``, ``CASE( "<STRESS" )``,
and (root cause) ``MDI_Library``'s ``newton`` → ``atomic_unit_of_force``
conversion factor.

**Symptom, stage 1**: after fixing Bug 2, ``<STRESS`` returned real,
nonzero values, but the resulting LAMMPS ``Press`` was many orders of
magnitude too small (~1e-6 bar for an expected ~1e4-1e5 bar signal), and
with the wrong sign relationship between compressed and expanded test
geometries (compression gave *less* positive pressure than expansion,
backwards from physical expectation).

**Two distinct issues, isolated via a clean baseline comparison** (MDI
debug print at zero strain against the batch MOPAC AUX file
``VOIGT_STRESS`` for the identical optimized structure):

1. **Sign**: MOPAC's ``voigt`` array uses the standard solid-mechanics
   convention (tensile positive), while MDI/LAMMPS expects the opposite
   (compressive positive) — same class of bug as Bug 1, just for stress
   instead of forces.

2. **Magnitude**: the original code used a suspect
   ``MDI_Conversion_factor("newton", "atomic_unit_of_force", conv)`` call.
   Empirically, ``conv`` was found to return ``2.66394e14`` in this
   environment, versus the textbook CODATA-derived value of
   ``~1.214e7`` (1 atomic unit of force = 8.2387e-8 N) — off by a factor
   of ~2.2e7, which matched almost exactly the magnitude discrepancy
   observed in the final ``Press`` values. The independently-checked
   ``meter`` → ``atomic_unit_of_length`` conversion returned the expected
   ``1.8897e10`` (matching the Bohr radius), confirming the anomaly was
   specific to the force conversion, not a general libmdi problem.

**Fix applied locally** (avoids the suspect force conversion entirely,
building the Pa → atomic-pressure factor from energy and length instead,
since pressure = energy/volume):

.. code-block:: fortran

   real_array(1) = voigt(1)
   real_array(2) = voigt(6)
   real_array(3) = voigt(5)
   real_array(4) = voigt(6)
   real_array(5) = voigt(2)
   real_array(6) = voigt(4)
   real_array(7) = voigt(5)
   real_array(8) = voigt(4)
   real_array(9) = voigt(3)

   real_array = -real_array          ! negate: tensile+ (MOPAC) -> compressive+ (MDI)
   real_array = real_array * 1e9     ! GPa -> Pa

   CALL MDI_Conversion_factor("joule", "atomic_unit_of_energy", conv, ierr)
   real_array = real_array * conv
   CALL MDI_Conversion_factor("meter", "atomic_unit_of_length", conv, ierr)
   real_array = real_array / (conv*conv*conv)

   CALL MDI_Send(real_array, 9, MDI_DOUBLE, comm, ierr)

**Root cause, confirmed**: Taylor (MDI_Library team) traced this to a
cut-and-paste error in MDI_Library's own unit-conversion table for the
``newton`` constant, and has fixed it there. The local MOPAC-side
workaround (using energy and length instead of force) remains valid
regardless of when that upstream fix reaches this conda environment, and
can be reverted once a corrected ``libmdi`` is in general use, if
desired.

**Upstream status**: fixed by Taylor in MDI_Library; not yet confirmed
present in the conda-forge release used by this environment.


Validation results
===================

Forces (Bug 1 fix)
-------------------

50-step NVT on the 102-atom methanol/PM6-ORG periodic system, starting
from an already-optimized structure: temperature oscillated in a damped
fashion, total energy stayed bounded (no runaway). Confirms the sign fix
qualitatively; an explicit single-atom displace-and-check-restoring-force
test was discussed but not performed.

Stress (Bugs 2 and 3 fixes)
-----------------------------

Baseline check (zero strain, structure identical to a prior batch MOPAC
optimization with AUX output requested):

.. list-table::
   :header-rows: 1

   * - Quantity
     - AUX (``VOIGT_STRESS``)
     - MDI debug print
   * - :math:`\sigma_{xx}` (GPa)
     - 1.36383
     - 1.36383
   * - :math:`\sigma_{yy}` (GPa)
     - 1.45639
     - 1.45639
   * - :math:`\sigma_{zz}` (GPa)
     - 1.38290
     - 1.38290

(Off-diagonal components also matched; small residual differences are
consistent with coordinate-precision truncation between the two input
files, not a computational discrepancy.)

Resulting LAMMPS ``Press`` for this baseline: ``-14010.406`` bar, which
matches :math:`-(\sigma_{xx}+\sigma_{yy}+\sigma_{zz})/3 \times 10^4` to
five significant figures (:math:`-(1.36383+1.45639+1.38290)/3 \times
10^4 = -14010.4`). Both sign and magnitude confirmed against an
independent ground truth.

Coupled NPT dynamics (forces + stress + barostat together)
--------------------------------------------------------------

50-step NPT run, ``iso 0.0 0.0 0.5``, ``temp ... 0.05``, starting from
velocities corresponding to 600 K (twice the 300 K target — intentional,
since the starting structure is a 0 K minimized geometry, and roughly
half the initial kinetic energy is expected to flow into potential
energy as the system thermalizes and relaxes away from the strict
minimum, settling temperature toward the target).

Observed:

* **Volume**: decreased steadily from 1143.5 to 1098.7 Å³ (~4% over 50
  steps) — consistent with the baseline diagnosis that this box starts
  under net tensile internal stress (wants to contract toward a smaller
  equilibrium volume at the target pressure).
* **Pressure**: damped oscillation characteristic of an underdamped
  Nose-Hoover barostat response, ranging from ~-18800 bar early on to
  brief positive excursions, generally trending toward smaller-magnitude
  oscillations as volume decreases.
* **Temperature**: relaxed from the initial 600 K toward the 300 K
  target with typical thermostat oscillation.
* **Density**: increased from 0.791 to 0.823 g/mL over the run. The
  starting value is notably close to methanol's experimental density
  (~0.792 g/mL); whether PM6-ORG's true equilibrium density for this
  system sits above or below the experimental value (or whether the
  density would oscillate back down with further equilibration) cannot
  be determined from this short test and should be revisited with a
  longer run.

This is the first confirmation that forces, periodic stress, and
barostat coupling all work together correctly through MOPAC's native MDI
engine.


Known limitations and open items
==================================

* **EXIT command**: the MDI Mechanic test report for MOPAC's MDI engine
  lists ``EXIT`` as unsupported (gray badge). In practice, MOPAC's log
  has shown ``Received MDI command: EXIT`` at the end of test runs
  without any observed crash, but a clean process-exit-code check has
  not been explicitly performed.
* **Performance**: ~1.2-2 s per MOPAC call for this 102-atom system, with
  no SCF-restart optimization (e.g. ``OLDGEO``) yet in use between MD
  steps. Worth revisiting for longer production runs.
* **MOZYME** behavior with the MDI engine has not been tested; relevant
  for systems beyond a few hundred atoms.
* **Longer NPT equilibration** is needed before drawing any conclusions
  about PM6-ORG's predicted equilibrium density for this system.
* The three local patches above exist only as informal diffs in this
  note; they have not yet been collected into a clean, reusable patch
  file for reapplication after a fresh MOPAC source checkout.
* Bugs 1 and 2 have not yet been formally reported to the MOPAC
  developers (Bug 2 is already known to Jonathan from this
  conversation/collaboration; Bug 1 has not been raised separately as of
  this writing).


References
==========

* :ref:`plan-qm-mdi-lammps` — the overall integration plan this
  validation work supports.
* MOPAC MDI documentation: https://openmopac.net/about/software/#mdi
* MOPAC MDI test repository: https://github.com/openmopac/MDI_MOPAC_test
* MDI specification: https://molssi-mdi.github.io/MDI_Library/
* LAMMPS ``fix mdi/qm``: https://docs.lammps.org/fix_mdi_qm.html
