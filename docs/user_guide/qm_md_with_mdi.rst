.. _user-qm-md-with-mdi:

************************************************
QM molecular dynamics (Model Chemistry + LAMMPS)
************************************************

SEAMM can run LAMMPS molecular dynamics where the energies and forces come from
a **quantum-mechanical engine** -- currently MOPAC or xTB semiempirical methods
-- instead of a classical forcefield. You set this up with two steps in your
flowchart:

#. a **Model Chemistry** step, where you pick the level of theory (e.g.
   ``MOPAC:SQM@PM6-ORG``); and
#. a **LAMMPS** step, which automatically uses that model chemistry to drive the
   dynamics.

The two communicate over the `MDI`_ protocol behind the scenes -- you do not
have to configure any of that. This page shows how to build and run such a
flowchart. Developers wanting the code-level details should read
:ref:`dev-qm-md-over-mdi`.

.. _MDI: https://molssi-mdi.github.io/MDI_Library/

.. contents:: Contents
   :depth: 2
   :local:


How it fits together
=====================

The Model Chemistry step does not compute anything itself. It records *which*
level of theory you want and makes that choice available to the steps that come
after it -- exactly the way the Forcefield step provides a forcefield. The
LAMMPS step then notices the choice and, instead of looking for a forcefield,
launches the QM engine and asks it for forces at every MD step.

::

   ┌──────────────────┐     publishes the      ┌───────────────┐
   │ Model Chemistry  │  ── chosen model ─────► │     LAMMPS    │
   │  MOPAC:SQM@PM6-ORG│      chemistry          │  MD / minimize│
   └──────────────────┘                         └───────────────┘
                                                    drives the QM engine
                                                    (MOPAC) for E and F

The order matters: the Model Chemistry step must come **before** the LAMMPS step
in the flowchart, so the choice exists when LAMMPS runs.


Prerequisites
=============

QM-MD spans several SEAMM environments. You need **LAMMPS** plus at least one of
the QM engines (**MOPAC** or **xTB**):

* **A QM engine** -- install at least one:

  * **MOPAC** -- ``seamm-installer install mopac`` (creates the ``seamm-mopac``
    environment).
  * **xTB** -- ``seamm-installer install xtb`` (creates the ``seamm-xtb``
    environment).

* **LAMMPS built with MDI** -- the SEAMM LAMMPS install
  (``seamm-installer install lammps``) includes the MDI package, which provides
  the ``fix mdi/qm`` that LAMMPS needs. You can confirm it with::

      conda run -n seamm-lammps lmp -h | grep -i mdi

* **The Model Chemistry plug-in** -- installed with SEAMM itself.

LAMMPS and the QM engine must be set up as **conda** installations (the default
from the installer). Other installation types are not yet supported for QM-MD.


Building the flowchart
======================

#. **Add a Model Chemistry step.** Drag it into the flowchart before LAMMPS.
   Open it and choose the model chemistry from the list -- for example
   ``MOPAC:SQM@PM6-ORG``. The list is built from whatever program plug-ins you
   have installed that can provide a model chemistry.

   * The names follow the pattern ``Program:Type@Method`` -- here MOPAC, a
     semiempirical QM method (``SQM``), ``PM6-ORG``. xTB methods look like
     ``xTB:SQM@GFN2-xTB``.
   * Turn on the **periodic** option if your system is periodic (a crystal or a
     liquid in a box). This filters the list to methods that have been validated
     for periodic systems (see the table below).

#. **Add a LAMMPS step** after it. Inside the LAMMPS step build the simulation
   as usual: an **Initialization** sub-step, then **Energy**, **Minimization**,
   or **Molecular dynamics** (NVE / NVT / NPT) sub-steps. You do **not** add a
   Forcefield step and you do **not** choose a ``pair_style`` -- the QM engine
   provides all the interactions.

#. **Set the charge and spin multiplicity on your system**, not in the Model
   Chemistry step. These come from the configuration (the standard SEAMM place
   for them) and are passed to the QM engine automatically.

That is the whole setup. When you run the job, the LAMMPS step launches the QM
engine, runs the dynamics, and shuts the engine down when it is done.


Which methods can be used
=========================

Only some methods can be driven over MDI. As of this writing:

.. list-table::
   :header-rows: 1
   :widths: 14 43 43

   * - Engine
     - Drivable by MDI (any system)
     - Validated for **periodic** systems
   * - MOPAC
     - PM7, PM6-D3H4, PM6-ORG, PM6, AM1, RM1
     - PM7, PM6-ORG, PM6
   * - xTB
     - GFN1-xTB, GFN2-xTB
     - GFN1-xTB, GFN2-xTB

Use any method in the middle column for molecular (non-periodic) systems. If you
turn on the *periodic* option, you must use a method from the right-hand column.
If you pick a method that cannot be driven this way -- or a non-periodic method
for a periodic system -- SEAMM stops with a clear error rather than producing
wrong results.


Running and what you get
========================

Run the job the normal way. In the LAMMPS step's working directory you will see
a few files specific to this path:

* ``mdi_launch.sh`` -- the script SEAMM generated to start the QM engine and
  the LAMMPS driver together and connect them.
* ``input.dat`` -- the LAMMPS input. It contains a ``fix ... mdi/qm`` line and,
  notably, **no** ``pair_style``: that is expected, because the QM engine
  supplies the forces.
* the usual ``log.lammps``, trajectory, and output files.

The job output notes that energies and forces are being evaluated by a QM engine
over MDI, and that LAMMPS itself runs on a single core (it only steers the
dynamics; the QM engine does the heavy work).

.. note::

   QM-MD is far more expensive per step than classical MD, and LAMMPS drives a
   single QM engine. Start small -- a modest number of atoms and steps -- to get
   a feel for the cost before scaling up.


Troubleshooting
===============

.. list-table::
   :header-rows: 1
   :widths: 38 62

   * - What you see
     - What to do
   * - "... cannot be driven via MDI"
     - The chosen method is not MDI-capable. Pick a method from the middle
       column of the table above.
   * - "... not validated for periodic systems"
     - You enabled *periodic* with a method not on the periodic list. Pick a
       method from the right-hand column of the table above, or turn off
       periodic for a molecular system.
   * - "model chemistry ... is not available"
     - The Model Chemistry step found no installed program offering it. Make
       sure a QM engine is installed (``seamm-installer install mopac`` or
       ``seamm-installer install xtb``).
   * - ``fix mdi/qm`` unknown / LAMMPS error about MDI
     - Your LAMMPS was built without the MDI package. Reinstall the SEAMM LAMMPS
       (``seamm-installer install lammps``).
   * - The run hangs at the start, or "address already in use"
     - A networking hiccup connecting the two codes (a port collision). Re-run
       the job; this is rare for a single job on a machine.
   * - Energies look wrong for a charged or open-shell system
     - Set the charge and spin multiplicity on the configuration -- they are not
       set in the Model Chemistry step.


See also
========

* :ref:`dev-qm-md-over-mdi` -- the developer/code-level companion to this page.
* MOPAC semiempirical methods: https://github.com/openmopac/mopac
* xTB (GFN-xTB) methods: https://xtb-docs.readthedocs.io/
