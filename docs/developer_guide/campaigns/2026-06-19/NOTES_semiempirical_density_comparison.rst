.. _notes-semiempirical-density-comparison:

==========================================================================
Scientific Finding: Semiempirical Method Accuracy for Liquid Methanol
==========================================================================

:Date: 2026-06-19
:Status: Three methods compared via NPT MD; PM6-ORG and PM7 both fail
   substantially (opposite directions); GFN2-xTB moderately
   under-binds but finds a genuine equilibrium.

.. contents:: Contents
   :depth: 2
   :local:


Context
=======

As a side effect of validating MDI-driven QM/MD for SEAMM (see
:ref:`notes-mopac-mdi-validation` and
:ref:`notes-qm-mdi-engines-validation`), three semiempirical/tight-binding
methods were each run as the sole interaction potential for NPT
molecular dynamics on an identical 300-atom periodic liquid methanol
box (34-100 molecules depending on system size tested), starting from
the experimental density (0.792 g/mL at room temperature). This may be
among the first MD trajectories ever run through MOPAC's native MDI
engine, given the engine was being validated for the first time this
same week -- there is essentially no prior literature on how PM6-ORG or
PM7 behave for bulk organic liquids, since neither method's
parameterization or validation set included condensed-phase liquid
properties.


Results
=======

.. list-table::
   :header-rows: 1

   * - Method
     - Equilibrium density
     - Deviation from experiment (0.792 g/mL)
     - Behavior
   * - PM6-ORG
     - ~1.10 g/mL
     - +39%
     - Severely over-binds; settles to a stable but much-too-dense
       liquid
   * - PM7
     - no plateau found (still falling after 800 steps, 0.46 g/mL and
       dropping)
     - heading toward vaporization
     - Severely under-binds; box volume expands essentially without
       bound over the tested range
   * - GFN2-xTB
     - ~0.68 g/mL (steps 300-500 average, stationary to
       :math:`\pm 0.5\%`)
     - -14%
     - Moderately under-binds, but finds a genuine, stable equilibrium


Interpretation
===============

PM6-ORG and PM7 bracket the experimental density from opposite
directions, both substantially wrong, while GFN2-xTB lands closer to
correct (and, notably, actually finds a stable liquid state rather
than collapsing or vaporizing). This is not surprising in retrospect:
PM6-ORG was parameterized and validated primarily for protein/
biomolecular structures and energetics, and PM7's focus was mainly
inorganic solids -- neither training/validation process had any reason
to get intermolecular liquid-phase cohesion right. GFN2-xTB, by
contrast, was developed with explicit dispersion (D4) and broader
non-covalent-interaction parameterization in mind, plausibly explaining
why it at least qualitatively gets the liquid-state physics right even
though the magnitude is off.

This pattern is also independently corroborated by the broader
semiempirical-methods literature, not just specific to methanol. A 2025
benchmark study comparing several semiempirical QM methods (AM1, PM6,
DFTB2, and GFN-xTB) against ab initio MD and experiment for bulk liquid
water found that, with their original parameterizations,
bulk water properties were poorly described by
all the semiempirical methods tested regardless of underlying
theoretical model, with most methods showing hydrogen bonds that are
too weak and predicting water that's far too fluid, with distorted
hydrogen-bond dynamics. PM6-ORG's *opposite* failure
(over-binding rather than under-binding) for methanol suggests its
specific parameterization choices push the other way for this
particular method/solvent combination -- worth being precise that the
literature finding is about a general tendency among several
semiempirical methods toward *under*-binding, not a universal law; PM6-
ORG's over-binding here is a separate, method-specific result from this
week's work, not something the cited study itself observed.

One caveat worth being precise about, carried over from the validation
notes: the PM6-ORG NPT runs in this comparison were not run to a fully
converged, statistically rigorous equilibrium -- both the original
102-atom run and several of the 300-atom runs showed long, slow, only
partially-completed oscillations rather than a tightly converged
plateau. The ~1.10 g/mL figure for PM6-ORG and the ~0.68 g/mL figure
for GFN2-xTB are the best available estimates from the runs performed,
not publication-grade converged averages.


Possible next steps (not yet pursued)
========================================

* Compare against any existing literature benchmarks for GFN2-xTB
  specifically (as opposed to the general SQC-methods-on-water study
  cited above) on liquid alcohol or alkane densities, if such
  benchmarks exist -- not yet searched for specifically.
* Longer, statistically converged NPT runs for a publication-quality
  density estimate, if this finding is to be written up formally.
* Test additional system sizes to rule out finite-size effects more
  rigorously than the qualitative 102-atom vs. 300-atom comparison
  already performed (see :ref:`notes-mopac-mdi-validation`).


References
==========

* :ref:`notes-mopac-mdi-validation`
* :ref:`notes-qm-mdi-engines-validation`
* Benchmarking semiempirical quantum chemical methods on liquid water,
  arXiv:2503.11867
