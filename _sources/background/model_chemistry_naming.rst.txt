.. _model-chemistry-naming:

================================
Model Chemistry Naming Standard
================================

SEAMM labels every calculated result with a *model chemistry* string: a single,
parseable identifier for **what was done** (the task), **at what level of
theory** (the potential energy surface), and **by which code(s)** (provenance).

The central design rule is that **comparability lives in the task and level, not
in the program**. Two results with the same task and level of theory are
comparable regardless of which code produced them. When two codes' nominally
identical method genuinely differ (the classic B3LYP case), that is a *method*
difference and must be expressed by giving the methods distinct names -- not by
leaning on the program token, which the comparability key discards.


The three axes
==============

task
   The operation performed: single point, optimization, dynamics, frequencies,
   ... **Always present and explicit** -- SEAMM does not use implicit-task
   conventions, because implicit fields cause problems.

level
   The potential energy surface: ``type@method`` plus, where applicable,
   ``/basis`` and ``@cutoff``. This is the "level of theory."

program(s)
   Provenance. The **driver** is the code performing the task. When the PES is
   delegated to another code over MDI, the **owner** is the code that evaluates
   the energy and forces. Programs are stripped to obtain the comparability key.


Grammar
=======

::

   model_chemistry = unit [ "//" unit ]
   unit            = driver ":" task "|" level
   level           = [ owner ":" ] theory
   theory          = type "@" method [ "/" basis [ "@" cutoff ] ]
   driver          = program          ; code performing the task
   owner           = program          ; code evaluating the PES (only if != driver)
   program         = token            ; LAMMPS, MOPAC, xTB, VASP, Psi4, ...
   task            = token            ; SP | OPT | MD | FREQ | ...
   type            = token            ; SQM | DFT | QC | VFF | IP | rxnFF | ML | FF
   method          = token
   basis           = token
   cutoff          = token
   token           = 1*CHAR, excluding the reserved characters : @ / |

Reserved characters are ``:`` ``@`` ``/`` ``|`` (and ``//`` for the compound).
A ``cutoff`` requires a ``basis``; an ``owner`` is written only when it differs
from the ``driver``.

Read a unit as: the *driver* performs the *task*, producing results on the
*level* PES; if an *owner* is given, the driver delegates the PES to it (via
MDI).


Task vocabulary
===============

.. list-table::
   :header-rows: 1
   :widths: 12 50

   * - Task
     - Meaning
   * - ``SP``
     - Single point -- energy / forces at a fixed geometry
   * - ``OPT``
     - Geometry optimization (energy minimization). Always ``OPT``, never ``MIN``.
   * - ``MD``
     - Molecular dynamics
   * - ``FREQ``
     - Vibrational frequencies / thermochemistry

Further tasks (transition-state search, NEB, Monte Carlo) may be added as
needed.


Level: the type vocabulary
==========================

The ``type`` names the method *family* and drives the GUI's Type -> Method
cascade.

.. list-table::
   :header-rows: 1
   :widths: 10 46 12

   * - Type
     - Meaning / examples
     - Notes
   * - ``SQM``
     - Semiempirical QM: PM6, PM7, AM1, RM1, GFN2-xTB
     -
   * - ``DFT``
     - Kohn-Sham DFT: PBE, B3LYP, r2SCAN
     -
   * - ``QC``
     - Correlated / *ab initio* wavefunction: HF, MP2, CCSD(T)
     -
   * - ``VFF``
     - Additive / valence molecular force fields: OPLS-AA, AMBER, CHARMM, GAFF
     -
   * - ``IP``
     - Interatomic potentials: EAM, MEAM, Tersoff (the OpenKIM world)
     -
   * - ``rxnFF``
     - Reactive force fields: ReaxFF, COMB
     -
   * - ``ML``
     - Machine-learned potentials: MACE, ANI, NequIP
     -
   * - ``FF``
     - Force fields not covered above
     - catch-all fallback

The force-field families are kept separate because their domains of
applicability are disjoint -- an EAM value is not comparable to an OPLS-AA value
-- and the split keeps the method cascade tractable. ``FF`` is only the
fallback.


Programs: driver and owner
==========================

The **driver** (immediately left of ``:`` ``task``) is always present. The
**owner** appears on the level side only when the driver delegates the PES to a
different code over MDI:

* ``LAMMPS:MD|VFF@OPLS-AA`` -- LAMMPS runs MD and evaluates OPLS-AA itself
  (driver == owner, so the owner is omitted).
* ``LAMMPS:MD|MOPAC:SQM@PM6-ORG`` -- LAMMPS runs MD while MOPAC evaluates the
  PM6-ORG forces over MDI (driver LAMMPS, owner MOPAC).
* ``MOPAC:OPT|SQM@PM6-ORG`` -- MOPAC optimizes at PM6-ORG (driver == owner).

This is why ``LAMMPS:SQM@PM6-ORG`` is wrong: LAMMPS evaluates none of the
semiempirical method, so it cannot be the owner -- MOPAC must be named on the
level side.


Comparability key
=================

Stripping ``driver:`` and ``owner:`` from every unit yields the **program-free
comparability key**, ``task|theory`` (or ``task|theory//task|theory`` for a
compound):

.. list-table::
   :header-rows: 1
   :widths: 40 36

   * - full string
     - comparability key
   * - ``MOPAC:OPT|SQM@PM6-ORG``
     - ``OPT|SQM@PM6-ORG``
   * - ``LAMMPS:MD|MOPAC:SQM@PM6-ORG``
     - ``MD|SQM@PM6-ORG``
   * - ``LAMMPS:MD|VFF@OPLS-AA``
     - ``MD|VFF@OPLS-AA``
   * - ``VASP:OPT|DFT@PBE/PAW@500eV``
     - ``OPT|DFT@PBE/PAW@500eV``

A properties database compares results by this key. **The B3LYP lesson:** if two
codes' "B3LYP" differ, encode the difference in the *method name* (e.g.
``B3LYP`` vs ``B3LYP(VWN5)``) so the keys differ honestly. Never rely on the
program token to distinguish them -- the key discards it.


Compound specifications (``//``)
================================

Optionally, ``//`` joins an **energy** unit to the **geometry** unit it was
evaluated at (the Pople convention), each side a full unit::

   Psi4:SP|QC@CCSD(T)/cc-pVTZ//Psi4:OPT|DFT@B3LYP/def2-SVP

= a CCSD(T)/cc-pVTZ single point on a B3LYP/def2-SVP-optimized geometry. ``//``
has the lowest precedence, so split on it before the single ``/`` (basis).
Within SEAMM the database also tracks geometry lineage through configuration
linkage, so ``//`` is mainly for labeling composite single-point methods
compactly.


What a program step advertises vs. what a consumer composes
===========================================================

A program step (via ``get_model_chemistry_options``) advertises **level specs**
only -- ``[owner:]type@method[/basis[@cutoff]]`` (e.g. ``MOPAC:SQM@PM6-ORG``) --
because a program knows its levels of theory but not the task. The Model
Chemistry step stores the selected level. The **consuming** step supplies the
``driver`` and ``task`` and composes the full string for the result label (e.g.
the LAMMPS step composes ``LAMMPS:MD|MOPAC:SQM@PM6-ORG``).


Examples
========

.. list-table::
   :header-rows: 1
   :widths: 32 11 8 10 8 16 13

   * - String
     - Driver
     - Task
     - Owner
     - Type
     - Method
     - Basis / cutoff
   * - ``MOPAC:OPT|SQM@PM6-ORG``
     - MOPAC
     - OPT
     - MOPAC
     - SQM
     - PM6-ORG
     - --
   * - ``MOPAC:SP|SQM@PM6-ORG``
     - MOPAC
     - SP
     - MOPAC
     - SQM
     - PM6-ORG
     - --
   * - ``LAMMPS:MD|VFF@OPLS-AA``
     - LAMMPS
     - MD
     - LAMMPS
     - VFF
     - OPLS-AA
     - --
   * - ``LAMMPS:OPT|VFF@OPLS-AA``
     - LAMMPS
     - OPT
     - LAMMPS
     - VFF
     - OPLS-AA
     - --
   * - ``LAMMPS:MD|MOPAC:SQM@PM6-ORG``
     - LAMMPS
     - MD
     - MOPAC
     - SQM
     - PM6-ORG
     - --
   * - ``LAMMPS:MD|IP@EAM``
     - LAMMPS
     - MD
     - LAMMPS
     - IP
     - EAM
     - --
   * - ``LAMMPS:MD|rxnFF@ReaxFF``
     - LAMMPS
     - MD
     - LAMMPS
     - rxnFF
     - ReaxFF
     - --
   * - ``VASP:OPT|DFT@PBE/PAW@500eV``
     - VASP
     - OPT
     - VASP
     - DFT
     - PBE
     - PAW @ 500eV


Parsing
=======

#. Split on ``//`` -> the energy unit and an optional geometry unit.
#. For each unit, split on ``|`` -> the task part (``driver:task``) and the
   level part. Split the task part on ``:`` -> ``driver`` and ``task``.
#. In the level part an ``owner`` is present iff a ``:`` precedes the theory;
   split it off. Then parse the theory: split on ``@`` -> ``type`` and the
   method cluster; split on ``/`` -> ``method`` and the basis cluster; split on
   ``@`` -> ``basis`` and ``cutoff``.
#. The comparability key drops ``driver`` and ``owner`` from each unit.

Reference implementation: ``model_chemistry_step/grammar.py``
(``parse_model_chemistry``, ``parse_level``, ``compose_model_chemistry``,
``comparability_key``).
