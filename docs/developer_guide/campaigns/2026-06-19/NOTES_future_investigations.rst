.. _notes-future-investigations:

=====================================================================
Notes on Open Investigations: MOPAC Conda Packaging and VASP via MDI
=====================================================================

:Date: 2026-06-19/20
:Status: Both items below are open / unresolved. Neither has had code
   written against it. Documented here as a baseline for picking back
   up later.

.. contents:: Contents
   :depth: 2
   :local:


Part A -- mopac-feedstock conda-forge packaging
==================================================

Context
--------

Investigated whether/how to add MDI support to the conda-forge
``mopac`` package (``conda-forge/mopac-feedstock``), working from the
actual ``recipe/meta.yaml`` and ``recipe/build.sh`` Paul provided.

Findings
---------

* The correct conda-forge package providing MDI is named **``pymdi``**
  (feedstock ``conda-forge/pymdi-feedstock``, building
  ``MolSSI/MDI_Library``) -- not ``mdi`` as initially assumed.
* Inspecting ``pymdi``'s ``.ci_support`` file names directly revealed
  two platform-specific constraints:

  - **No ``nompi`` variant exists for ``pymdi`` on Linux or macOS** --
    every build is tagged ``mpimpich`` or ``mpiopenmpi``. MPI is not
    optional for ``pymdi`` on those platforms.
  - **Windows builds have no MPI-provider split at all** -- a single,
    unqualified build per Python version, strongly suggesting
    ``pymdi``'s Windows build is MPI-free (TCP-only) by necessity,
    not by choice.

* A draft patch to ``meta.yaml``/``build.sh`` was prepared (gating
  ``-DMDI=ON`` and the ``pymdi`` dependency behind
  ``[unix and mpi != 'nompi']``), but several genuine open questions
  remain unresolved:

  - Whether referencing ``{{ mpi }}`` in ``mopac-feedstock``'s own
    recipe would, by default, preserve a lightweight ``nompi`` build
    for users who don't need MDI, or whether an explicit
    ``conda_build_config.yaml`` entry is required to add ``nompi``
    to the variant matrix (the ``hdf5``-style documented pattern).
  - Whether MOPAC's own ``-DMDI=ON`` compile path requires MPI
    unconditionally at compile time, even if only the TCP transport
    will ever be used at runtime -- never actually tested, since
    every build this week had MPI present regardless of which
    transport was used at runtime.
  - Whether Windows MDI support for MOPAC is feasible at all, given
    ``pymdi``'s apparent lack of an MPI-providing Windows build.

* MOPAC's own GitHub release notes (encountered later, independently)
  state that a forthcoming conda-forge MOPAC distribution will have
  MDI support enabled and will depend on the conda-forge MDI library
  -- suggesting this packaging work may already be in motion on the
  MOPAC team's side, independent of anything done here.

Status and recommendation
----------------------------

Rather than open separate GitHub issues, a combined discussion message
was drafted for Taylor Barnes (MDI_Library) and Jonathan Moussa
(OpenMOPAC), covering the three bugs found in MOPAC's native MDI engine
(see :ref:`notes-mopac-mdi-validation`) plus the packaging design
questions above, on the basis that direct discussion is more efficient
than parallel issue threads given both are in Paul's own group.

**This question is now substantially less urgent for SEAMM's own
purposes.** The successful development of ``mopac_mdi.py`` (a
``mopactools``-based Python wrapper, see
:ref:`notes-qm-mdi-engines-validation`) means SEAMM does not need a
custom MDI-enabled MOPAC build at all -- the plain conda-forge
``mopac`` + ``mopactools`` packages suffice, with no MPI dependency on
the engine side when using ``-method TCP``. The feedstock question
remains worth pursuing for the benefit of users who specifically want
MOPAC's *native* Fortran MDI engine, but is no longer a blocker for
SEAMM integration.


Part B -- VASP via MDI: feasibility assessment
=================================================

Context
--------

Investigated whether VASP's new Python plugin system
(https://vasp.at/wiki/Plugins) could be used to implement MDI support
for VASP, the way ``mopactools`` was used for MOPAC.

Findings
---------

* **The plugin system's control-flow direction is inverted from what
  MDI needs**, and this is a structural mismatch, not a workaround-able
  limitation:

  - Both the ``structure`` and ``force_and_stress`` Python hooks are
    called *at the end of each ionic relaxation step*, from *within*
    VASP's own internally-driven relaxation/MD loop (controlled by
    VASP's own ``NSW``/``IBRION``/``POTIM`` settings).
  - The ``constants`` dataclass passed into each hook is explicitly
    documented as read-only, describing what VASP itself already
    computed for "the current SCF step" -- with built-in safeguards
    against modification.
  - The ``additions`` dataclass is additive only (``additions.x +=
    ...``) -- there is no entry point for an external driver to
    supply an arbitrary new geometry and get back a single-point
    result for *exactly* that geometry, the way MDI's ``>COORDS`` /
    ``<ENERGY`` / ``<FORCES`` / ``<STRESS`` sequence requires.
  - The documented use cases confirm this framing: custom dispersion
    corrections, or substituting an ASE-calculator-based potential as
    VASP's *own* force engine for a VASP-driven trajectory (via the
    provided ``AseForceField`` helper) -- all cases where VASP retains
    ownership of the trajectory.

* **A separate, pre-existing VASP capability is a much better
  architectural fit**: ``vasp-interactive``
  (https://github.com/ulissigroup/vasp-interactive) is a pure-Python
  layer over VASP's existing "interactive mode" (no VASP source
  patching required) that exposes exactly the resident-process,
  warm-started, repeatedly-queried architecture MDI needs -- but
  speaking the **i-PI** socket protocol rather than MDI directly.

* MDI and i-PI are closely related by design: MDI_Library's own
  documentation states that the MDI Standard's command-response
  pattern and string-based command representation were modelled
  directly after i-PI's. LAMMPS's own MDI documentation
  separately lists i-PI as one of two recognized "indirect MDI
  support" paths for QM codes (the other being QCEngine).

* **Not yet resolved**: whether this relationship means the wire
  protocols are directly interchangeable (an MDI driver could address
  an i-PI server with zero translation code) or whether an adapter
  layer is still required. The available documentation describes
  shared design influence, not a confirmed claim of direct wire
  compatibility. Paul's recollection that "MDI is backwards compatible
  with i-PI" is partially corroborated (the recognized-category claim)
  but not confirmed at the protocol level from documentation alone.

Status and recommendation
----------------------------

Two ways to settle the wire-compatibility question were identified but
not yet attempted:

1. **Empirically**: point an MDI driver's ``-method TCP`` directly at
   a running ``vasp-interactive`` i-PI server (matching port) and see
   whether the handshake succeeds with no translation code at all.
2. **Authoritatively**: ask Taylor Barnes directly, given he is
   already in the loop this week on MDI_Library internals.

If a translation layer does turn out to be necessary, the concrete
path forward would be a script that is simultaneously an MDI engine
(same registration pattern as ``tblite_mdi.py``/``mopac_mdi.py``,
talking to LAMMPS) and an i-PI client (talking to a running
``vasp-interactive`` server), translating
``>COORDS``/``>CELL``/``<ENERGY``/``<FORCES``/``<STRESS`` into the
equivalent i-PI messages and back. This would be a meaningfully larger
undertaking than the existing single-protocol wrapper engines (two
protocols instead of one direct library call), and no code has been
written toward it yet.

This is a clearly separate, follow-on project from the current MOPAC/
tblite SEAMM integration work, not something to fold into the near-term
``lammps_step`` integration discussion.


References
==========

* :ref:`notes-mopac-mdi-validation`
* :ref:`notes-qm-mdi-engines-validation`
* https://vasp.at/wiki/Plugins
* https://vasp.at/wiki/PLUGINS/STRUCTURE
* https://vasp.at/wiki/PLUGINS/FORCE_AND_STRESS
* https://github.com/ulissigroup/vasp-interactive
* https://docs.lammps.org/Howto_mdi.html
* https://github.com/MolSSI-MDI/MDI_Library
