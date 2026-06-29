.. _plan-model-chemistry-step:

=====================================================================
Plan: Model Chemistry Step, Metadata Protocol, and MOPAC/xTB via MDI
=====================================================================

:Date: 2026-06-20
:Status: Architecture proposed; metadata classmethod implemented (sketch)
   for MOPAC against its real existing metadata; xTB metadata sketched
   pending a new step package; lammps_step consumption logic sketched,
   not yet implemented.

.. contents:: Contents
   :depth: 3
   :local:


Overview
========

Replaces the ad hoc ``_forcefield`` / ``_OpenKIM_Potential`` /
``_pytorch_model`` global-variable scheme with a single new
**Model Chemistry Step**, storing one dictionary (e.g. as the global
variable ``_model_chemistry``) that uniformly describes a classical
forcefield, an MLFF, or a model-chemistry string (``Program:Type@Method
[/Basis[@Cutoff]]``) -- including, for model chemistries, enough
information for a consuming driver step (``lammps_step`` first, others
later) to launch the right MDI engine.

This plan covers: the dict shape, the metadata protocol every
program-step package implements to describe what it offers, a worked
implementation of that protocol against ``mopac_step``'s real existing
metadata, a sketch of the same for xTB (which has no existing SEAMM
step package at all), and how ``lammps_step`` would consume all of
this to decide between a classical ``pair_style`` and an MDI
connection.


The ``_model_chemistry`` dictionary
=====================================

.. code-block:: python

   # Classical forcefield (existing behavior, reshaped)
   {
       "type": "forcefield",
       "name": "OPLS-AA",
   }

   # MLFF
   {
       "type": "mlff",
       "name": "MACE-MP-0",
   }

   # Model chemistry -- MOPAC via MDI
   {
       "type": "model_chemistry",
       "model": "MOPAC:SQM@PM6-ORG",   # the citable string
       "program": "MOPAC",
       "method_type": "SQM",
       "method": "PM6-ORG",
       "basis": None,
       "convergence": 1.0,             # mopactools relative-tolerance scale
       "max_iterations": None,
       "options": {},
   }

   # Model chemistry -- DFT with RI basis and explicit cutoff (VASP-style)
   {
       "type": "model_chemistry",
       "model": "VASP:DFT@PBE/PAW@500eV",
       "program": "VASP",
       "method_type": "DFT",
       "method": "PBE",
       "basis": "PAW",
       "cutoff": "500eV",
       "convergence": None,
       "options": {},
   }

Charge and multiplicity are deliberately **not** fields here -- per
existing SEAMM convention (and the SEAMM paper's own statement that
these are properties of the configuration, not of the calculation
method), they are read from the configuration by whatever step
launches the actual calculation, exactly as ``mopac_step``/
``gaussian_step`` already do.


The metadata protocol
========================

Every program-step package that wants to participate in the Model
Chemistry Step (as a source of options in its dialog, and/or as an
MDI-launchable engine for driver steps like ``lammps_step``)
implements one classmethod:

.. code-block:: python

   @classmethod
   def get_model_chemistry_options(cls, periodic_only=False, mdi_only=False):
       """Return the model chemistries this step's program can provide.

       Parameters
       ----------
       periodic_only : bool
           Only return options valid for a periodic system (relevant
           for any driver running periodic MD, e.g. via MDI/LAMMPS).
       mdi_only : bool
           Only return options actually launchable as an MDI engine,
           as opposed to only available via this step's traditional
           batch/file-based path.

       Returns
       -------
       dict
           Keyed by the bare method name (e.g. "PM6-ORG"). Each value
           is a dict with at least:
               "model_chemistry" : str   -- full "Program:Type@Method" string
               "type" : str              -- "SQM", "DFT", "QC", "FF", "MLFF"
               "description" : str
               "periodic" : bool
               "mdi_capable" : bool
               "mdi_script" : str | None
               "mdi_method_arg" : str | None
       """

This is deliberately a thin classmethod, not a full instance method --
the Model Chemistry Step's dialog (and ``lammps_step``, when deciding
how to set up a calculation) need this information *before* any
flowchart node for that program necessarily exists, so it has to be
queryable from the class itself via whatever Stevedore already uses
to discover the package, without requiring instantiation.


Worked implementation: MOPAC
===============================

``mopac_step`` already has essentially everything needed in its
``metadata["computational models"]`` structure -- this just exposes it
through the protocol above rather than inventing a new shape:

.. code-block:: python

   # Proposed addition to mopac_step (exact module/file location to be
   # confirmed against the real package -- this is a clean-room sketch
   # against the metadata structure retrieved from project knowledge,
   # not a verified patch against the actual current file).

   # mopactools' model_dict currently supports exactly these six --
   # see mopac_mdi.py's --method choices, sourced from
   # mopactools.api.MopacSystem.model_dict.
   _MDI_CAPABLE_METHODS = {"PM7", "PM6-D3H4", "PM6-ORG", "PM6", "AM1", "RM1"}

   @classmethod
   def get_model_chemistry_options(cls, periodic_only=False, mdi_only=False):
       options = {}
       for theory_class, class_data in metadata["computational models"].items():
           for family, family_data in class_data["models"].items():
               for name, param in family_data["parameterizations"].items():
                   is_periodic = param.get("periodic", False)
                   if periodic_only and not is_periodic:
                       continue

                   mdi_capable = name in _MDI_CAPABLE_METHODS
                   if mdi_only and not mdi_capable:
                       continue

                   # PM6-D3H4's periodic=False here is a confirmed real
                   # limitation (MOPAC's docs explicitly say D3H4 does
                   # not work under PBC) -- this filter correctly
                   # excludes it from periodic_only results, not an
                   # over-cautious guess. The same is NOT yet confirmed
                   # one way or the other for PM6-DH2/DH2X/D3H4X --
                   # treat those as unconfirmed for periodic+MDI use
                   # until someone actually runs one and checks, per
                   # the governing principle in the xTB section below.

                   options[name] = {
                       "model_chemistry": f"MOPAC:SQM@{name}",
                       "type": "SQM",
                       "description": param.get("description", ""),
                       "periodic": is_periodic,
                       "elements": param.get("elements", ""),
                       "mdi_capable": mdi_capable,
                       "mdi_script": "mopac_mdi.py" if mdi_capable else None,
                       "mdi_method_arg": name if mdi_capable else None,
                   }
       return options

Calling ``get_model_chemistry_options(periodic_only=True, mdi_only=True)``
against the real metadata retrieved this week would currently exclude
PM6-D3H4 and everything outside the six ``mopactools``-supported names,
leaving PM7, PM6-ORG, PM6 as confirmed periodic+MDI options.

**PM6-D3H4's exclusion is now confirmed correct, not just cautious.**
Per Paul, MOPAC's documentation explicitly states D3H4 does not work
under periodic boundary conditions -- this is a real, documented
method limitation, not an oversight in ``mopac_step``'s metadata. The
filter above is doing exactly the right thing.

**The same caution now extends to the other correction variants**
(PM6-DH2, PM6-DH2X, PM6-D3H4X, etc.) -- whether *they* also have
undocumented or differently-documented periodic limitations is not
yet known and, per Paul, "cannot be solved now" without actually
running them. Per the governing principle stated in the xTB section
below, none of these should be treated as periodic+MDI-capable until
someone actually runs one periodic via MDI and confirms it works --
regardless of what any existing metadata flag says one way or the
other. AM1 and RM1's periodic flags were similarly not visible in the
metadata excerpt available while drafting this plan and fall under the
same default-to-unconfirmed treatment.


Worked implementation: xTB
=============================

An ``xtb_step`` package now exists (added to project knowledge after
this plan's first draft) -- this supersedes the earlier speculative
sketch. Its real ``metadata["computational models"]`` wraps Grimme's
``xtb`` *binary* via subprocess/file I/O (writes ``coord.xyz``, parses
``xtbout.json``) -- a genuinely different code path from
``tblite_mdi.py``, which calls ``tblite``'s Python ``Calculator``
directly. Two important consequences fall out of this distinction
rather than being assumed:

* ``xtb_step``'s own metadata flags every method ``"periodic": False``,
  with an explicit comment that this is because the v1 subprocess
  wrapper "refuses periodic input." This is correct for that specific
  path and does **not** describe a limitation of the methods
  themselves -- periodic GFN2-xTB was independently validated this
  week via ``tblite``'s library API directly. The metadata protocol
  therefore needs **two separate periodicity flags**, not one:
  ``periodic_native`` (this package's subprocess path) and
  ``periodic_mdi`` (validated only for the specific methods actually
  run periodic via MDI).
* The method sets only partially overlap. ``xtb_step`` exposes
  GFN2-xTB, GFN1-xTB, GFN0-xTB, GFN-FF (via the ``xtb`` binary).
  ``tblite.interface.Calculator`` (what ``tblite_mdi.py`` wraps) only
  covers GFN1-xTB, GFN2-xTB, IPEA1-xTB. The overlap is GFN1/GFN2 only
  -- GFN0-xTB and GFN-FF are not reachable via MDI at all through this
  path; IPEA1-xTB is MDI-reachable but isn't in ``xtb_step``'s native
  list.

**Governing principle, stated explicitly**: a (program, method)
combination is only marked periodic-and-MDI-capable if it was actually
run periodic via MDI and observed to work -- not because some metadata
flag says "periodic: True" and not by structural inference from "the
underlying library probably supports it." This week that means
**GFN2-xTB only** -- GFN1-xTB and IPEA1-xTB use the identical
``tblite.interface.Calculator`` path and are plausibly fine, but were
never actually tested periodic, so they default to unconfirmed rather
than assumed-working.

.. code-block:: python

   # Proposed addition to xtb_step/metadata.py, alongside the existing
   # metadata["computational models"] dict (real, from project knowledge).

   # tblite.interface.Calculator's scope -- see tblite_mdi.py --method choices.
   _MDI_CAPABLE_METHODS = {"GFN1-xTB", "GFN2-xTB", "IPEA1-xTB"}

   # Only methods actually run periodic via MDI this week. Everything
   # else defaults to unconfirmed regardless of what any other flag says.
   _MDI_PERIODIC_VALIDATED = {"GFN2-xTB"}

   @classmethod
   def get_model_chemistry_options(cls, periodic_only=False, mdi_only=False):
       options = {}
       for theory_class, class_data in metadata["computational models"].items():
           for family, family_data in class_data["models"].items():
               for name, param in family_data["parameterizations"].items():
                   # GFN-FF is a force field, not SQM -- Paul's own example
                   # of why the method-type tag matters.
                   method_type = "FF" if name == "GFN-FF" else "SQM"

                   mdi_capable = name in _MDI_CAPABLE_METHODS
                   periodic_mdi = name in _MDI_PERIODIC_VALIDATED

                   if periodic_only and not periodic_mdi:
                       continue
                   if mdi_only and not mdi_capable:
                       continue

                   options[name] = {
                       "model_chemistry": f"xTB:{method_type}@{name}",
                       "type": method_type,
                       "description": "",  # pull from param/docs as available
                       "periodic_native": param.get("periodic", False),
                       "periodic_mdi": periodic_mdi,
                       "elements": param.get("elements", ""),
                       "mdi_capable": mdi_capable,
                       "mdi_script": "tblite_mdi.py" if mdi_capable else None,
                       "mdi_method_arg": name if mdi_capable else None,
                   }
       return options

**Program tag: settled as** ``xTB:`` **, not** ``tblite:``. Per Paul:
xTB and DFTB+ both use ``tblite`` under the hood for GFN-xTB methods,
but users recognize the program names, not the underlying library --
matching how the rest of this nomenclature already prioritizes
user-recognizable program names. (This does mean the same
implementation-precision question raised for B3LYP/Gaussian-vs-Psi4
technically applies here too -- ``xtb_step``'s binary path and
``tblite_mdi.py``'s library path could in principle disagree slightly
even though both report "GFN2-xTB" -- but the decision is made
deliberately, not by oversight.)

**Related, not solved here**: ``dftbplus_step`` already exists and,
per Paul, also uses ``tblite`` for GFN-xTB internally alongside its
own native DFTB parameterizations. It will eventually want the same
two-path (native vs. MDI) treatment in its own metadata. Not pursued
in this plan.

**Open question, raised but not decided**: should ``tblite_mdi.py``
(and ``mopac_mdi.py``) actually move *into* their respective step
packages (e.g. ``xtb_step/mdi_engine.py``, ``mopac_step/mdi_engine.py``)
now that ``get_model_chemistry_options()`` is proposed as a classmethod
on the step class? That would put the metadata and the thing it
describes in the same package, rather than a standalone script
elsewhere referencing the package only by string (``"mopac_mdi.py"``)
with no actual import-time connection between them.


How ``lammps_step`` consumes this
=====================================

Sketch of the decision logic, not yet implemented:

.. code-block:: text

   1. Read the global _model_chemistry dict (or a local override, if
      lammps_step's own GUI is later given a "use global" switch).

   2. If type == "forcefield": existing behavior, unchanged.

   3. If type == "model_chemistry":
        a. Parse "program" from the dict (already split out, no need
           to re-parse the string).
        b. Look up that program's step-package metadata classmethod
           via whatever Stevedore-based registry already locates
           plug-ins, calling get_model_chemistry_options(
               periodic_only=(configuration.periodicity == 3),
               mdi_only=True,
           ) to confirm the requested method is actually valid for
           this configuration and reachable via MDI.
        c. Pull charge/multiplicity from the configuration (existing
           convention) and pass them as CLI args when launching the
           engine subprocess.
        d. Build the "elements" list from the configuration's atom
           types, in LAMMPS type order.
        e. Emit "comm_modify cutoff 2.0" and "fix mdi/qm [virial yes]
           elements ..." instead of pair_style/pair_coeff.
        f. Launch "{mdi_script} -mdi '...' --method {mdi_method_arg}
           --charge {q} --multiplicity {mult}" as the engine process
           (TCP, given this week's validated approach), then launch
           LAMMPS as the driver.

This split deliberately keeps step (3.b) -- "resolve a model chemistry
to an engine launch spec" -- as something any future driver step could
call into identically, while steps (3.d)-(3.f) are LAMMPS-specific
input-generation logic that stays inside ``lammps_step``. Whether
(3.b) should be a shared utility function (in ``seamm_util`` or a new
small package) or just duplicated logic in each driver step that needs
it is an open implementation decision, not resolved here -- with only
one driver (LAMMPS) existing today, it's reasonable to write it inside
``lammps_step`` first and extract it if/when a second driver actually
needs it, rather than build the abstraction speculatively.


Phased plan
============

* **Phase 1** (this document): protocol defined; MOPAC metadata
  classmethod sketched against real existing metadata.
* **Phase 2**: confirm the AM1/RM1 periodic flags and the PM6-D3H4
  periodic/MDI conflict directly against ``mopac_step`` source;
  land the classmethod for real.
* **Phase 3**: new minimal ``xtb_step`` package (cookiecutter),
  hosting the metadata classmethod above plus whatever minimal
  standalone capability is wanted.
* **Phase 4**: the Model Chemistry Step package itself -- dialog,
  ``_model_chemistry`` variable, dynamic field exposure driven by
  the metadata protocol.
* **Phase 5**: ``lammps_step`` consumption logic (decision tree
  above) -- the actual MDI integration this whole effort is for.
* **Phase 6** (later, optional): migrate ``gaussian_step``/
  ``mopac_step``/etc. to have a "use global model chemistry" GUI
  switch, per the earlier design discussion.


Open questions carried into this plan
=========================================

* PM6-D3H4 periodic-via-mopactools: **resolved** -- confirmed real
  limitation, correctly excluded.
* PM6-DH2/DH2X/D3H4X periodic reliability, and AM1/RM1's periodic
  flags: still genuinely unconfirmed -- per the governing principle,
  default to excluded from periodic+MDI use until actually tested.
* GFN1-xTB and IPEA1-xTB periodic reliability via MDI: structurally
  plausible (same ``tblite.interface.Calculator`` as the validated
  GFN2-xTB path) but not actually tested -- same default-to-excluded
  treatment.
* ``xTB:`` as the program tag: **settled** -- matches user-recognizable
  program names over the underlying ``tblite`` library, consistent
  with how DFTB+ will eventually need the same treatment.
* Whether ``tblite_mdi.py``/``mopac_mdi.py`` should move into their
  respective step packages now that the metadata classmethod is
  proposed as living on the step class -- raised, not decided.
* Whether (3.b) in the ``lammps_step`` consumption section becomes a
  shared utility now or only once a second driver step exists --
  deferred deliberately.
* Whether the Model Chemistry Step replaces or coexists indefinitely
  with the Forcefield Step's existing variables during the transition
  (Paul's stated intent is "leave Forcefield Step for compatibility
  for the time being" -- the exact deprecation timeline is not fixed
  here).


References
==========

* :ref:`notes-qm-mdi-engines-validation`
* :ref:`notes-mopac-mdi-validation`
* ``mopac_step``'s ``metadata["computational models"]`` (project
  knowledge)
* ``mopac_mdi.py``, ``tblite_mdi.py`` (this week's validated engines)
