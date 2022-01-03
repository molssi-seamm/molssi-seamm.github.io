.. _ease-of-use:

***********
Ease-of-Use
***********

Currently, using the molecular and materials simulation codes is not easy! This is
widely recognized as a problem and there are some efforts underway to tackle the
problem. The heart of the problem is that telling these codes what to do is complicated
to begin with, and each code has developed a text-based language so that users can tell
the code what to do. Unfortunately, there is no standardization, with each code using
its own keywords and approach to setting up the calculation.

For example, this is the control input for GROMACS for a 1 ns constant temperature -
constant pressure (NPT) molecular dynamics calculations::

  integrator               = md
  dt                       = 0.002
  nsteps                   = 500000

  nstlog                   = 5000
  nstenergy                = 5000
  nstxout-compressed       = 5000

  continuation             = yes
  constraints              = all-bonds
  constraint-algorithm     = lincs

  cutoff-scheme            = Verlet

  coulombtype              = PME
  rcoulomb                 = 1.0

  vdwtype                  = Cut-off
  rvdw                     = 1.0
  DispCorr                 = EnerPres

  tcoupl                   = V-rescale
  tc-grps                  = Protein  SOL
  tau-t                    = 0.1      0.1
  ref-t                    = 300      300

  pcoupl                   = Parrinello-Rahman
  tau-p                    = 2.0
  compressibility          = 4.5e-5
  ref-p                    = 1.0

This is a similar input for LAMMPS::

  units               real
  boundary            p p p
  atom_style          full
  newton              on
  pair_style          lj/class2/coul/long 10.0
  pair_modify         mix sixthpower tail yes shift no
  kspace_style        pppm 1e-05
  bond_style          hybrid class2 harmonic
  angle_style         hybrid class2 harmonic
  dihedral_style      hybrid class2 harmonic
  improper_style      class2
  read_data           structure.dat
  timestep            2.0
  fix                 1 all temp/rescale 500 300.0 300.0 20.0 1.0
  fix                 2 all nve
  fix                 3 all ave/time 25 1 25 v_time v_temp v_press v_density v_cella \
                            v_cellb v_cellc v_etotal v_ke v_pe v_epair off 2 \
                            file trajectory_npt_3_2.seamm_trj 
  run                 500000

The two inputs are quite different from each other, and in either case it would take
considerable time with to manual to understand precisely the details of the
calculation.

Here is the GUI for the LAMMPS NPT calculation in SEAMM.

.. figure:: /images/lammps_npt_dialog.png
   :width: 800px
   :align: center
   :alt: LAMMPS NPT dialog

   *The LAMMPS NPT dialog*

As the saying goes, a picture is worth a thousand words! The dialog is much easier to
understand -- and change -- than the text input of the underlying codes. Furthermore,
the GUI for GROMACS could present the parameters for NPT dynamics in a similar
fashion. While there might be some differences due to details of the implementation,
most of the dialog would look the same.

Let's look a little deeper into the GUI. If we click on the Thermostat field, it
presents a number of choices:

.. figure:: /images/lammps_temperature_choices.png
   :width: 400px
   :align: center
   :alt: Choices for temperature control

   *Choices for controlling the temperature in LAMMPS*

If we choose Berendsen's method for controlling the temperature, the dialog reconfigures
to show only the relevant options:

.. figure:: /images/berendsen_parameters.png
   :width: 400px
   :align: center
   :alt: Berendsen temperature control parameters

   *The control parameters for Berendsen's method*

This is very nice! You can see the possible choices, and when you select one, you see
only the appropriate parameters for that choice.

In summary, a GUI is much easier to use than a text input, particularly when you are
starting with a code and learning. Furthermore, the GUI's in SEAMM hide the complicated
inputs for and differences between codes, and present the choices and parameters in a
way that is closer to the underlying physics.
