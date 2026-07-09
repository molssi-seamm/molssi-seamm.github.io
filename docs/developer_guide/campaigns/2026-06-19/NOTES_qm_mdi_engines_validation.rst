.. _notes-qm-mdi-engines-validation:

=========================================================================
Validation Notes: tblite MDI Engine and MOPAC Python-Wrapper MDI Engine
=========================================================================

:Date: 2026-06-19/20
:Status: Both engines validated for NVT and NPT periodic liquid MD.
   MOZYME (mopactools) found unreliable for periodic liquid MD -- two
   distinct failure modes documented, conventional solver is the
   validated path.
:Continues from: :ref:`notes-mopac-mdi-validation` (MOPAC's native
   Fortran MDI engine)

.. contents:: Contents
   :depth: 3
   :local:


Purpose
=======

This note picks up where :ref:`notes-mopac-mdi-validation` left off,
covering two new MDI engines built this week:

1. ``tblite_mdi.py`` -- a from-scratch Python wrapper around the
   ``tblite`` Python API (GFN1/GFN2/IPEA1-xTB), following the same
   in-process, no-subprocess architecture as ``mace_mdi.py``.
2. ``mopac_mdi.py`` -- a from-scratch Python wrapper around MOPAC's
   ``mopactools`` C API, as an alternative to MOPAC's native Fortran
   MDI engine documented in :ref:`notes-mopac-mdi-validation`.

The ``mopactools``-based wrapper is the path now recommended for SEAMM
integration: same architecture/idiom as the other Python-wrapper
engines, no custom MDI-enabled MOPAC build needed, no MPI dependency
on the engine side at all when using ``-method TCP`` (see decision
rationale below).


Part A -- tblite MDI engine
============================

Environment
------------

Conda environment ``seamm-lammps-tblite``: same MDI-enabled LAMMPS
build as the MOPAC work, plus ``tblite-python`` and ``pymdi``
(``*mpi_openmpi*`` build, matching LAMMPS's MPI).

Bugs found during initial setup
---------------------------------

All in our own script, not in ``tblite`` itself:

1. **LAMMPS data-file parser matched the wrong line.** ``natoms`` was
   being set from ``"4 atom types"`` instead of ``"300 atoms"``,
   because the original matching logic checked for the substring
   ``"atom"`` rather than the exact token ``"atoms"``. Fixed by
   requiring an exact ``toks[1] == 'atoms'`` match.
2. **MDI node/commands were never registered.** Without
   ``MDI_Register_node("@DEFAULT")`` and ``MDI_Register_command(...)``,
   LAMMPS could not discover what the engine supports, fell back to
   sending ``>NATOMS`` (driver-sends-count) instead of the registered
   ``<NATOMS`` (engine-sends-count) path, and the unread payload
   corrupted the socket for all subsequent commands ("Could not find
   the node"). Fixed by registering the full command set up front,
   including an explicit ``>NATOMS`` handler as a fallback.
3. **``periodic`` argument needed a numpy array, not a Python list.**
   ``tblite.interface.Structure.__init__`` checks ``periodic.size``,
   which a plain list doesn't have. Fixed with
   ``np.array([True, True, True])``.

Validation
-----------

**Forces**: tblite's ``Calculator.singlepoint()`` returns true forces
(already :math:`-\partial E/\partial x`), not raw gradients -- no sign
bug possible by construction, confirmed by a stable, bounded 50-step
NVT trajectory with no runaway.

**Stress**: ``stress = -virial / volume`` required **no additional
negation** -- the formula was correct as originally written. Confirmed
via the compress/expand test on the 300-atom methanol box:

.. list-table::
   :header-rows: 1

   * - State
     - Press (bar)
     - Density (g/mL)
   * - Compressed (-5%)
     - +109,929
     - 0.923
   * - Expanded (+5%)
     - -90,855
     - 0.683

Correct ordering (compressed > expanded), confirming both sign and
reasonable magnitude without needing the kind of unit-conversion
debugging the native MOPAC engine required.

**Warm-starting**: ``calc.singlepoint(res=prev_result, copy=False)``
reduced SCF cycle count from 9 (cold start) to 6-7 (warm), but did
**not** proportionally reduce wall-clock time -- later/near-converged
cycles are individually more expensive than early/cheap ones. Same
lesson independently re-confirmed for MOPAC's warm-starting below.

**NPT (GFN2-xTB, 300-atom methanol box, 500 steps)**: density settled
to a genuine, stationary plateau. Averaging steps 300-500 (the clearly
stationary region) gives **0.681 g/mL**, oscillating in a tight
:math:`\pm 0.5\%` band with no further drift -- this is the GFN2-xTB
result referenced in the separate density-comparison note.

Performance: ~10-14 s/step cold, dropping modestly with warm-starting;
not the bottleneck for this validation effort.


Part B -- MOPAC Python-wrapper MDI engine (``mopac_mdi.py``)
===============================================================

Design rationale
------------------

Discussed and decided over two sessions:

* The ``mopactools`` C API (inspected directly from its ``binding.py``/
  ``api.py`` source, since online documentation was sparse) exposes
  everything needed without any input file: ``MopacSystem.atom``,
  ``.coord``, ``.lattice``, ``.charge``, ``.spin``, ``.model`` are all
  plain settable Python/numpy attributes, and ``from_data(system,
  state, relax=False, vibe=False)`` runs a single-point calculation
  directly from those in-memory objects.
* ``coord_deriv`` is documented as the gradient in kcal/(mol*Angstrom)
  -- same quantity, same sign issue as the native engine's ``<FORCES``
  bug, but now we control the negation ourselves in Python.
* ``stress`` is a fixed-size 6-element Voigt array (GPa) always present
  in the properties struct, but (correctly anticipated from the native
  engine's Bug 2) its *computation* is gated by ``nlattice_move ==
  nlattice`` -- mirrored here by always setting ``nlattice_move =
  nlattice``, exactly as the ``Tv +1`` workaround did for the native
  engine.
* ``MopacState``/``MozymeState`` hold the density matrix directly and
  persist correctly across calls when reused (confirmed via
  ``state.mpack`` staying constant across calls -- see below) -- a
  cleaner warm-start mechanism than the native engine's batch-mode
  ``OLDGEO`` keyword.
* No custom MDI-enabled MOPAC build needed: ``mopactools`` loads the
  plain conda-forge ``libmopac``. No MPI dependency on the engine side
  when using ``-method TCP``, since the script never calls
  ``MPI_Init`` itself and never passes an MPI communicator into
  ``MDI_Init`` (confirmed by every TCP-mode run this week working
  without ``mpirun`` on the engine side).
* Unlike ``tblite_mdi.py``, this script was designed from the start to
  obtain **all** structural data (natoms, elements, coordinates, cell)
  purely from the MDI handshake -- no ``--structure``/``--elements``
  file parsing. LAMMPS's ``fix mdi/qm`` already sends ``>NATOMS``,
  ``>CELL``, ``>ELEMENTS`` (when the ``elements`` keyword is used) and
  ``>COORDS`` before the first property request, confirmed directly
  from observed command logs. ``--elements`` is retained only as a
  fallback for the ``>TYPES`` case.

Bugs found and fixed during development
------------------------------------------

1. **Python 3.14 / ctypes incompatibility (MozymeState only).**
   ``MozymeState().attach()`` raised
   ``ctypes.ArgumentError: argument 1: TypeError: expected
   LP_c_mozyme_state instance instead of LP_c_mopac_state`` on Python
   3.14, despite the ``attach()`` source itself being internally
   consistent (correctly builds a ``c_mozyme_state`` pointer). The
   conventional (non-MOZYME) path was unaffected. Resolved by
   downgrading the environment to Python 3.12. Root cause not
   identified beyond "very new Python + ctypes argument-checking
   changes" -- worth a minimal 3-line reproduction
   (``MozymeState(); s.attach()``) if reported upstream.
2. **MOZYME state-reuse failure: "ERROR DETECTED IN SUBROUTINE CHECK".**
   With ``--mozyme`` and the default restart interval, the *first*
   reuse of a persisted ``MozymeState`` (the second calculation,
   immediately after one successful cold-start call) failed fast
   (1.64 s, clearly not a full SCF attempt). This is consistent with,
   but distinct from, the orthogonality-drift issue MOPAC's manual
   documents for *many* chained SCF calls -- this failed on the very
   first reuse, not after gradual accumulation.
3. **MOZYME fresh-build failure: "Unit cell has a charge."** With
   ``--mozyme-restart-every 1`` (forcing a completely fresh
   Lewis-structure/LMO build every single step, eliminating any
   state-reuse explanation), the engine ran 15 successful fresh
   cold-starts (~6.2-7.2 s each) before the bonding-detection heuristic
   itself produced a Lewis structure that didn't balance to the
   declared zero charge. Most likely explanation: a transient,
   thermally-fluctuating O-H...O hydrogen-bond contact in the liquid
   was misjudged as covalent. This points to a more fundamental
   mismatch between MOZYME's bond-detection heuristic (designed around
   stable protein/enzyme covalent topology) and periodic liquid MD
   (continuous, fluctuating non-covalent contacts), independent of the
   state-reuse bug above.

   **Conclusion: MOZYME is not currently reliable for periodic liquid
   MD via this API**, regardless of restart interval. The conventional
   solver (default, no ``--mozyme``) is the validated, recommended
   path; MOZYME remains available behind the flag for future
   investigation pending upstream input.

Performance investigation
----------------------------

* **Threading makes no measurable difference.** 300% CPU (unconstrained)
  and 99.9% CPU (``OMP_NUM_THREADS=1``) gave statistically
  indistinguishable per-call times (~4.6-7.4 s, fully overlapping
  ranges) for the 300-atom system. Paul's hypothesis: MOPAC may use a
  specialized, faster-but-non-threaded diagonalization method rather
  than a standard threaded LAPACK call -- not independently confirmed;
  worth asking Jonathan or Jimmy Stewart directly.
* **Warm-starting confirmed mechanically correct, modest wall-time
  benefit.** ``state.mpack`` (the packed density-matrix size) goes
  ``0 -> 180300`` on the cold start and then stays at exactly
  ``180300`` for every subsequent call, confirming the persistent
  ``MopacState`` is genuinely being reused. But per-call time barely
  drops after the cold start (~7.3 s -> a noisy ~4.6-6.2 s band that
  never trends further down). Same conclusion as tblite's warm-start
  result: the SCF-iteration savings from a good density guess don't
  dominate; the per-step cost is most likely geometry-dependent setup
  (NDDO integral/distance-pair construction) that has to happen fresh
  every step regardless of the starting density.
* **Reference point for "is this slow?"**: a normal batch MOPAC
  geometry optimization on this exact 300-atom structure (373 SCF
  calculations, 52 min 22.6 s) works out to ~8.43 s/SCF-step. The MDI
  wrapper's ~5-6 s/step is, if anything, *faster* than plain batch
  MOPAC on the same system -- there is no script-side inefficiency to
  chase here; this is close to the intrinsic cost of PM6-ORG at this
  system size.

Code quality refactoring
---------------------------

Two changes made purely for code quality / SEAMM consistency, not bug
fixes:

* **Logging module** replaces ``print()`` throughout, with
  ``--log-level {DEBUG,INFO,WARNING,ERROR}`` (default ``INFO``). DEBUG
  shows every MDI command plus raw per-call energy/stress; INFO shows
  lifecycle events, per-call timing, and MOZYME restarts; WARNING is
  quiet (warnings/errors only).
* **Units via** ``from seamm_util import Q_`` replaces the original
  hardwired CODATA-constant approach, matching the
  ``Q_(value, "unit").m_as("other_unit")`` convention used throughout
  SEAMM (``gaussian_step``, ``thermomechanical_step``, etc.) rather
  than a parallel hand-rolled or bare-``pint`` approach. Not yet
  independently re-confirmed to execute correctly in Paul's actual
  environment as of this writing -- pending test.

Final validation: NPT (PM6-ORG, conventional solver, 300-atom box, 500 steps)
---------------------------------------------------------------------------------

Run to completion successfully (1h11m50s wall time, ~8.6 s/step
average -- somewhat above the isolated NVT/stress-check tests,
plausibly because NPT sends ``>CELL`` every step rather than the fixed
cell of NVT). Density rose from 0.791 g/mL (experimental) to a peak of
~1.148 g/mL around step 430-440, then turned over and began declining
(1.148 -> 1.137 by step 500) -- the same damped-oscillation character
seen throughout this week's PM6-ORG work.

This is the comparison point set up in advance: does the
``mopactools``-based wrapper reproduce the same physics as MOPAC's
native MDI engine on identical input? The native engine's earlier
300-atom PM6-ORG NPT run settled to ~1.10 g/mL (see the separate
density-comparison note). The wrapper's result at step 500 (~1.14,
still mid-oscillation, just past its peak) is close to but not
exactly at that reference value. Given how slowly and
non-monotonically these systems have equilibrated throughout this
entire investigation (the very first 102-atom native-engine run took
a single large oscillation that hadn't even completed by step 500),
this is most plausibly normal run-to-run oscillation-phase/seed
variation rather than a discrepancy in the wrapper's physics --
forces and stress were independently validated to agree with the
native engine's conventions exactly (same negation, same Voigt
ordering, same units). **Not yet independently confirmed** with a
controlled, same-seed comparison; flagged as something to revisit if
a precise quantitative match is ever needed, but not blocking
adoption of the wrapper for SEAMM integration.


Open items carried forward
============================

* MOZYME periodic-liquid reliability (two distinct failure modes
  above) -- candidate discussion topic for Jonathan, alongside the
  diagonalization/threading question and the orthogonality-restart-
  interval question already queued from
  :ref:`notes-mopac-mdi-validation`.
* ``seamm_util`` unit-conversion swap not yet independently tested by
  Paul.
* Same-seed, controlled comparison between native and wrapper engines
  for the PM6-ORG NPT equilibrium density, if a precise quantitative
  match is ever needed.
* Decision on whether/how to integrate ``tblite_mdi.py`` and
  ``mopac_mdi.py`` into SEAMM's ``lammps_step`` (or a more general
  location, since MDI connections may be useful elsewhere in SEAMM in
  the future) -- explicitly the next topic after this note.


References
==========

* :ref:`notes-mopac-mdi-validation` -- native MOPAC MDI engine, three
  bugs found and fixed there.
* :ref:`plan-qm-mdi-lammps` -- overall integration plan.
* tblite documentation: https://tblite.readthedocs.io/
* mopactools (uploaded source: ``binding.py``, ``api.py``)
