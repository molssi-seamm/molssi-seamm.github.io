.. _plan-qm-mdi-lammps:

============================================================
Development Plan: QM/MD via MDI in SEAMM — MOPAC First
============================================================

:Author: Paul Saxe (plan drafted with Claude)
:Date: 2026-06-11
:Status: Proposed

.. contents:: Contents
   :depth: 3
   :local:


Overview
========

This document describes a plan to enable QM-driven molecular dynamics in
SEAMM, using LAMMPS as the MD driver and a quantum-chemistry code
(initially MOPAC, later xTB and others) as the energy/force engine via the
MolSSI Driver Interface (MDI).

**Key insight from the MOPAC source tree**: MOPAC already contains a
**native MDI engine implementation**, built when MOPAC is compiled with
the CMake option ``-DMDI=ON`` (see
https://openmopac.net/about/software/#mdi).  This means **no Python wrapper
is needed** for MOPAC — the MOPAC executable itself acts as the MDI engine
once it is started with the appropriate ``-mdi`` flag. This is fundamentally
different from the MACE case, where a Python engine script was required
because ``mace-torch`` has no built-in MDI support.


Architecture
============

Runtime picture
---------------

.. code-block:: text

    LAMMPS (driver)   <──MPI/MDI──>   MOPAC (engine)
       fix mdi/qm                       native MDI loop
       No pair_style                    PM7 / PM6-ORG / AM1 / …
       Verlet / Nosé-Hoover             reads .mop for Hamiltonian settings
       NVT, NPT                         receives coords+cell, returns E, F, σ

Both processes share one ``MPI_COMM_WORLD`` via the ``mpirun`` colon syntax.
MDI_Init splits it into sub-communicators.

Launch command
--------------

.. code-block:: bash

    mpirun --mca mpi_yield_when_idle 1 \
      -np 1 mopac mopac.mop \
             -mdi "-role ENGINE -name MOPAC -method MPI" \
      : -np 1 lmp \
             -mdi "-role DRIVER -name LAMMPS -method MPI" \
             -in input.dat

MOPAC reads ``mopac.mop`` for its Hamiltonian and keyword settings, then
enters its MDI event loop.  LAMMPS drives the MD, sending ``>COORDS`` (and
``>CELL`` for periodic systems) each step and requesting ``<ENERGY``,
``<FORCES``, and (when ``virial yes``) ``<STRESS``.

MOPAC MDI command support (from the MDI Mechanic test report)
--------------------------------------------------------------

The ``openmopac/MDI_MOPAC_test`` repository reports MOPAC's MDI command
support at the ``@DEFAULT`` node:

**Supported (green)**:
``<ENERGY``, ``<FORCES``, ``<STRESS``, ``>COORDS``, ``>CELL``,
``<CHARGES``, ``<COORDS``, ``<CELL``, ``<DIMENSIONS``, ``<CELL_DISPL``,
``<ELEC_MULT``, ``<ELEMENTS``, ``<MASSES``, ``<NAME``, ``<NATOMS``,
``<TOTCHARGE``, ``<@``

**Not yet supported (gray)**:
``EXIT``, ``>TOTCHARGE``, ``>ELEC_MULT``, ``>CELL_DISPL``, ``>CHARGES``,
``>MASSES``, ``>STRESS``, ``>FORCES``, ``>ENERGY``, ``<KE``,
``<PE``, ``<VELOCITIES``, ``@INIT_MD``, ``@INIT_MC``, ``@INIT_OPTG``

All commands required by ``fix mdi/qm`` (``<ENERGY``, ``<FORCES``,
``<STRESS``, ``>COORDS``, ``>CELL``) are supported.

.. note::

   ``EXIT`` is listed as gray (not registered by MOPAC).  In practice MOPAC
   likely detects the MPI communicator closure or an EOF condition when LAMMPS
   exits and terminates cleanly.  This must be verified empirically in
   Phase A.  If LAMMPS fails to terminate MOPAC, a wrapper or a ``SIGTERM``
   mechanism may be needed.

Build requirement
-----------------

**Standard MOPAC distributions do not include MDI support.**  The conda-forge
``mopac`` package does not currently ship MDI-enabled builds.  To use MOPAC
as an MDI engine you must build from source::

    cmake -DMDI=ON …
    make install

This is a deployment concern that affects SEAMM packaging.  Options:

1. Maintain a separate ``mopac-mdi`` conda package (or a feature variant).
2. Require users to build MOPAC from source and point SEAMM to that binary.
3. Petition the MOPAC conda-forge maintainers to enable MDI in the package.

**Recommendation**: start with option 2 for development, pursue option 1 or
3 for production.


SEAMM integration design
=========================

Design goals
------------

1. The user configures the QM engine using the **normal SEAMM GUI** for that
   code (MOPAC parameters, Hamiltonian selector, convergence options, etc.).
2. The LAMMPS step generates all required inputs automatically: the ``.mop``
   file, the LAMMPS input, and the ``mpirun`` launch command.
3. The design is **code-agnostic** so that xTB, ORCA, or any future
   MDI-capable code can be dropped in with minimal changes.

New component: ``QM Engine`` substep in the LAMMPS subflowchart
----------------------------------------------------------------

The LAMMPS step's existing subflowchart (which currently holds
Initialization, Velocities, NVT/NPT substeps) gains a new first slot:
the **QM Engine substep**.  When this substep is present, the LAMMPS step
switches to MDI mode.

.. code-block:: text

    LAMMPS step subflowchart (MDI QM/MD mode)
    ──────────────────────────────────────────
    [QM Engine] ──► [Initialization] ──► [Velocities] ──► [NVT/NPT]

    QM Engine substep (mini-flowchart)
    ───────────────────────────────────
    [MOPAC step]    ← configured with normal MOPAC GUI

The **QM Engine substep** is a new plug-in step — call it ``qm_engine_step``
(package ``qm_engine_step``, or embedded in ``lammps_step`` to avoid a new
package for now).  It holds a one-step mini-flowchart that can contain any
MDI-capable QM step.  Its role is purely configurational: it is *never
executed directly* — instead it is interrogated by the LAMMPS step to extract
the information needed to build the MDI launch.

QM Engine substep responsibilities
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. Hold the mini-flowchart (contains a MOPAC step, xTB step, etc.).
2. Expose a method ``get_mdi_engine(configuration)`` that returns an
   ``MDIEngineSpec`` object (see below).

``MDIEngineSpec`` — the engine abstraction
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A lightweight dataclass (not a full SEAMM plug-in) that captures everything
the LAMMPS step needs:

.. code-block:: python

    @dataclasses.dataclass
    class MDIEngineSpec:
        engine_name: str          # e.g. "MOPAC" (the MDI engine name)
        executable: str           # e.g. "/path/to/mopac"
        input_file: str           # e.g. "mopac.mop"
        input_content: str        # full content of the input file
        extra_args: list[str]     # any extra CLI args before -mdi flag
        elements: list[str]       # ordered element list for fix mdi/qm
        needs_virial: bool        # True if NPT (stress required)

Each QM step (MOPAC, xTB, …) implements a new method:

.. code-block:: python

    def get_mdi_engine_spec(
        self,
        configuration,
        needs_virial: bool = False
    ) -> MDIEngineSpec:
        ...

This is the **only interface** the LAMMPS step needs.  Adding xTB or any
other code requires only implementing this method in that step's class.

MOPAC step changes
------------------

New method ``get_mdi_engine_spec``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The MOPAC step adds ``get_mdi_engine_spec()`` that:

1. Reads the current parameter values (Hamiltonian, convergence, MOZYME
   flag, etc.) exactly as ``get_input()`` does today.
2. Constructs the ``.mop`` file content for MDI mode:

   - Uses the chosen Hamiltonian (``PM7``, ``PM6-ORG``, ``AM1``, etc.).
   - Adds ``MDI`` keyword to activate the MDI engine loop.
   - Does **not** add ``1SCF``, ``FORCE``, ``AUX``, ``NOREOR``—the MDI
     engine loop handles execution differently from a batch run.
   - Adds ``LET`` (suppress convergence-failure fatal error).
   - For periodic systems (periodicity == 3): adds ``STRESS``.
   - Includes a placeholder single-atom geometry (required by MOPAC's
     input parser even in MDI mode; the real geometry arrives via MDI).

3. Returns the ``MDIEngineSpec``.

The MOPAC step is **not executed** in MDI mode.  Its ``run()`` method is
bypassed; only ``get_mdi_engine_spec()`` is called by the LAMMPS step.

LAMMPS step changes
-------------------

The LAMMPS step needs the following additions:

Detection of QM Engine substep
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

When building the LAMMPS input, the step iterates its subflowchart.  If it
finds a ``QM Engine`` substep, it:

1. Extracts the ``MDIEngineSpec`` from the contained QM step.
2. Writes the ``.mop`` (or other QM input) file.
3. Omits ``pair_style`` and ``pair_coeff`` from the LAMMPS input.
4. Emits ``comm_modify cutoff 2.0`` near the top of the input (mandatory;
   no pair_style means zero default pairwise cutoff).
5. Derives the ordered ``elements`` list from the configuration atom types.
6. Emits ``fix mdi_fix all mdi/qm [virial yes] elements …``.
7. Constructs the full ``mpirun`` launch command.

.. code-block::

    atom_style      full
    comm_modify     cutoff 2.0      # mandatory: no pair_style → no cutoff

    fix  prop all property/atom mol charge ...
    read_data  structure.dat

    # NVT (no barostat):
    fix  mdi_fix all mdi/qm elements H C O N ...

    # NPT (barostat needs virial):
    fix  mdi_fix all mdi/qm virial yes elements H C O N ...

``lammps.ini`` and the ``code`` key
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The ``lammps_step`` already substitutes the ``code`` key from ``lammps.ini``
when launching.  For QM/MD, the MDI launch command takes the form::

    mpirun --mca mpi_yield_when_idle 1 \
        -np 1 {QM_EXE} {QM_INPUT} \
               -mdi "-role ENGINE -name {ENGINE_NAME} -method MPI" \
        : -np 1 lmp \
               -mdi "-role DRIVER -name LAMMPS -method MPI"

The QM-specific parts (``{QM_EXE}``, ``{QM_INPUT}``, ``{ENGINE_NAME}``) are
provided by the ``MDIEngineSpec`` and substituted at runtime.  The ``-in
input.dat`` suffix is appended automatically by SEAMM as usual.

A new ``mdi-code`` key in ``lammps.ini`` could store the template with
placeholders.  Alternatively, the code is constructed entirely in Python
from the ``MDIEngineSpec`` data, and ``lammps.ini`` is not modified.  The
latter is cleaner and is preferred.


MOPAC ``.mop`` file for MDI mode
=================================

Minimum viable input file
--------------------------

.. code-block:: text

    PM7 MDI LET
    MOPAC MDI engine — generated by SEAMM lammps_step
    (geometry replaced each step by MDI driver)
    C   0.0 1   0.0 1   0.0 1

    0

The critical points:

``MDI``
    Activates MOPAC's internal MDI engine loop.  Without this keyword,
    MOPAC runs as a normal batch calculation and never connects to LAMMPS.

Hamiltonian keyword (``PM7``, ``PM6-ORG``, ``GFN2``, etc.)
    Selected by the user in the MOPAC step GUI, exactly as today.

``LET``
    Prevents SCF convergence failures from killing the MD run.

Placeholder geometry
    MOPAC requires at least one atom in the input, even in MDI mode.  A
    single carbon at the origin is sufficient; it is immediately overwritten
    by the ``>COORDS`` command from LAMMPS.

Periodic systems
~~~~~~~~~~~~~~~~

For systems with PBC (periodicity == 3), add ``STRESS`` to request the
stress tensor, and include three ``Tv`` lines::

    PM7 MDI LET STRESS
    MOPAC MDI engine — periodic system
    (geometry replaced each step by MDI driver)
    C   0.0 1   0.0 1   0.0 1
    Tv  10.0 0   0.0 0   0.0 0
    Tv   0.0 0  10.0 0   0.0 0
    Tv   0.0 0   0.0 0  10.0 0

    0

.. warning::

   It is currently unclear whether MOPAC's MDI loop reads the ``Tv`` lines
   from the ``.mop`` file or relies entirely on the ``>CELL`` MDI command.
   This must be tested empirically.  If ``>CELL`` is sufficient, the ``Tv``
   lines can be omitted from the template.

Additional MOPAC keywords exposed in the GUI
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following MOPAC step parameters map naturally to MDI/MD use:

``CHARGE=n``
    Total charge of the system.  Sourced from the configuration object,
    not from the GUI (consistent with SEAMM convention).

``MULT=n``
    Spin multiplicity.  Also sourced from the configuration object.

``MOZYME``
    Linear-scaling SCF.  Highly recommended for systems > ~200 atoms.
    The MOPAC step GUI already exposes this.

``CHARGE_MODEL``
    ``CM5``, ``MULL``, etc.  Exposed but not critical for MD forces.

Convergence keyword
    MOPAC's default convergence is adequate for most MD applications.
    Expose ``PRECISE`` and ``RELSCF=n`` in the GUI.


Phased development plan
=======================

Phase A — Proof of concept: MOPAC NVT on a molecule
-----------------------------------------------------

**Goal**: confirm that a MOPAC-MDI build can be driven by LAMMPS
``fix mdi/qm`` for a non-periodic NVT simulation.

**Deliverables**

1. Build MOPAC from source with ``-DMDI=ON``.  Confirm the ``MDI`` keyword
   is accepted.
2. Manually craft a ``.mop`` file and LAMMPS input for formic acid (HCOOH)
   NVT, PM7 Hamiltonian.
3. Verify:

   - Forces agree with finite-difference numerical gradient at the starting
     geometry.
   - NVT simulation runs without crashes for ≥ 1000 steps.
   - ``EXIT`` command behaviour: does MOPAC terminate cleanly when LAMMPS
     finishes?

4. Document the exact ``.mop`` file format, required keywords, and launch
   command.
5. Note any discrepancies with the MDI Mechanic test report.

**Risks**

- MOPAC ``EXIT`` not registered (gray badge) may prevent clean shutdown.
  Workaround: run LAMMPS with ``fix mdi/qm`` and rely on MPI teardown.
- ``-DMDI=ON`` may not be available in conda.  Manual build required.

Phase B — SEAMM integration skeleton
--------------------------------------

**Goal**: add the minimum code to ``lammps_step`` and ``mopac_step`` to
run the Phase A case from a SEAMM flowchart.

**Deliverables**

1. ``MDIEngineSpec`` dataclass in a new ``lammps_step/mdi.py`` module.
2. ``MopacStep.get_mdi_engine_spec()`` method.
3. ``QM Engine`` substep skeleton (can be a simple wrapper with one-step
   mini-flowchart, embedded in ``lammps_step`` initially).
4. LAMMPS step changes:

   - Detect ``QM Engine`` substep presence.
   - Call ``get_mdi_engine_spec()``.
   - Write ``.mop`` file.
   - Omit ``pair_style``.
   - Emit ``comm_modify cutoff 2.0`` and ``fix mdi/qm``.
   - Build and execute the ``mpirun`` launch command.

5. End-to-end test: formic acid NVT from a SEAMM flowchart.

Phase C — Periodic NVT (stress)
---------------------------------

**Goal**: extend to periodic systems with stress tensor.

**Deliverables**

1. Extend ``get_mdi_engine_spec()`` to emit ``STRESS`` keyword and ``Tv``
   lines (or confirm they are not needed).
2. Verify that MOPAC ``<STRESS`` returns the correct sign convention
   (tensile positive) and that SEAMM passes it directly to LAMMPS (which
   expects the same via ``fix_mdi_qm``).
3. Test: periodic water box (64 molecules), PM7, NVT.
4. Verify stress appears in LAMMPS thermo output (non-zero virial).

Phase D — Periodic NPT
------------------------

**Goal**: NPT simulation with MOPAC as the QM engine.

**Deliverables**

1. ``virial yes`` emitted when the subflowchart contains a barostat step.
2. Test: water box NPT, verify pressure converges to target.
3. Performance benchmark: step time vs. number of atoms (100–500 atoms).
4. Document ``comm_modify`` and ``virial yes`` as mandatory for NPT.

Phase E — xTB support
-----------------------

**Goal**: support Grimme's ``xtb`` as an alternative QM engine.

xTB has a native MDI implementation in recent versions (check the xTB
documentation at https://xtb-docs.readthedocs.io for ``--mdi`` flag
support).  If native MDI is available, the pattern is identical to MOPAC:

.. code-block:: bash

    mpirun --mca mpi_yield_when_idle 1 \
      -np 1 xtb xtb.inp --mdi "-role ENGINE -name XTB -method MPI" \
      : -np 1 lmp -mdi "-role DRIVER -name LAMMPS -method MPI" -in input.dat

**Deliverables**

1. Verify xTB MDI support status (native vs. subprocess-wrapper needed).
2. Implement ``XtbStep.get_mdi_engine_spec()``.
3. Test: water box NVT, GFN2-xTB.
4. Confirm the ``QM Engine`` substep GUI accepts xTB step with no changes.

Phase F — Packaging and deployment
------------------------------------

**Goal**: make MOPAC MDI builds available through SEAMM.

**Deliverables**

1. Conda recipe for ``mopac-mdi`` (MOPAC built with ``-DMDI=ON``).
2. SEAMM installer integration: detect whether installed MOPAC has MDI
   support; warn if not.
3. ``lammps.ini`` documentation: add MDI section with example launch
   commands.
4. User-facing documentation (RST).


Known issues and open questions
================================

**EXIT command (MOPAC)**
    MOPAC does not register the ``EXIT`` MDI command.  LAMMPS sends it at
    the end of the run.  Need to verify empirically whether MOPAC handles
    it gracefully, ignores it, or crashes.  Possible mitigations:

    - Rely on MPI communicator teardown (LAMMPS exits → MPI_Finalize →
      MOPAC detects broken communicator and exits).
    - Patch MOPAC to register and handle EXIT.  The openmopac/MDI_MOPAC_test
      repo has an open pull request from MolSSI-MDI; check its status.

**Energy quantity: HOF vs. total energy**
    MOPAC reports Heat of Formation (kcal/mol), not a total electronic
    energy.  For MD only energy differences and gradients matter, so HOF is
    correct for forces.  The absolute energy in LAMMPS thermo will be an
    HOF in Hartree — this is unusual and must be clearly documented.

    ``TOTAL_ENERGY`` (eV, available in the AUX file) is a better quantity
    for absolute comparisons, but it is unclear whether MOPAC's MDI engine
    returns ``TOTAL_ENERGY`` or ``HEAT_OF_FORMATION`` via ``<ENERGY``.  This
    must be confirmed by inspection or from the MOPAC source.

**MOPAC NOREOR in MDI mode**
    In batch mode, MOPAC can reorient molecules into a standard orientation
    (NOREOR suppresses this).  Whether the MDI engine loop applies any
    reorientation is unknown.  If it does, forces will be returned in the
    wrong frame.  Verify empirically; if necessary, add ``NOREOR`` to the
    generated ``.mop`` file.

**Charge and multiplicity**
    These should come from the configuration object (SEAMM convention), not
    from the GUI.  The MOPAC ``.mop`` file should include ``CHARGE=n`` and
    ``MULT=n`` only when they differ from the defaults (0 and 1).  The MDI
    ``<TOTCHARGE`` and ``<ELEC_MULT`` commands (supported by MOPAC) allow
    the driver to query these values, but not to set them.

**MOZYME for large systems**
    MOPAC's MOZYME (localized MO) method enables near-linear scaling and is
    important for systems > 200 atoms.  It may have compatibility
    constraints with the MDI loop.  Verify in Phase A/B.

**QM Engine substep package location**
    For Phase B, embed the ``QM Engine`` substep inside ``lammps_step`` to
    avoid creating a new package.  Evaluate whether it merits a separate
    ``qm_engine_step`` package as adoption grows.

**Parallel MOPAC**
    MOPAC supports OpenMP parallelism.  The MDI launch can run MOPAC on
    multiple threads by setting ``OMP_NUM_THREADS`` before the ``mpirun``
    invocation.  Expose as ``mopac-threads`` option in the QM Engine substep.


Comparison with MACE MDI (for reference)
==========================================

+-----------------------------+------------------------+-------------------------+
| Aspect                      | MACE (lammps-mdi)      | MOPAC (this plan)       |
+=============================+========================+=========================+
| Engine implementation       | Python wrapper script  | Native in MOPAC binary  |
+-----------------------------+------------------------+-------------------------+
| MDI support required?       | Custom (mace_mdi.py)   | Build with ``-DMDI=ON`` |
+-----------------------------+------------------------+-------------------------+
| Per-step overhead           | ~0 (in-process GPU)    | ~0 (in-process, CPU)    |
+-----------------------------+------------------------+-------------------------+
| Subprocess needed?          | No                     | No                      |
+-----------------------------+------------------------+-------------------------+
| Stress sign convention      | Negate (MACE tensile+) | Verify (MOPAC ?)        |
+-----------------------------+------------------------+-------------------------+
| SEAMM integration           | lammps.ini code= key   | QM Engine substep +     |
|                             |                        | auto-generated .mop     |
+-----------------------------+------------------------+-------------------------+
| ``virial yes`` trap         | Yes — same             | Yes — same              |
+-----------------------------+------------------------+-------------------------+
| ``comm_modify cutoff`` trap | Yes — same             | Yes — same              |
+-----------------------------+------------------------+-------------------------+
| Energy quantity             | eV (DFT total energy)  | kcal/mol (HOF) — verify |
+-----------------------------+------------------------+-------------------------+


References
==========

- MOPAC MDI documentation: https://openmopac.net/about/software/#mdi
- MOPAC MDI test repository: https://github.com/openmopac/MDI_MOPAC_test
- MDI specification: https://molssi-mdi.github.io/MDI_Library/
- LAMMPS ``fix mdi/qm``: https://docs.lammps.org/fix_mdi_qm.html
- LAMMPS MDI HOWTO: https://docs.lammps.org/Howto_mdi.html
- MACE MDI development summary: ``mace_mdi_development_summary.md``
  (project knowledge)
