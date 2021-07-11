**********   
Parameters
**********

Continuing with the example of OPLS from the previous section (:doc:`functional_form`)
let's recap the equation representing the energy as a function of the atomic
coordinates:

.. math::
   :label: E_parameters

   E = \sum_{i} \sum_{j}^{j>i\,and\,>1,4} \frac{A_{ij}}{r_{ij}^{12}} -
   \frac{B_{ij}}{r_{ij}^{6}} + \sum_{t}^{torsions} V_{t,0} +
   \frac{1}{2}V_{t,1}(1+\cos\phi_t) + \frac{1}{2}V_{t,2}(1-\cos2\phi_t) +
   \frac{1}{2}V_{t,3}(1+\cos3\phi_t)

The coordinates of the atoms enter this through the distances between atoms,
:math:`r_{ij}` and the torsional (or dihedral) angles, :math:`\phi`. There are also a
number of parameters in the equation: :math:`A_{ij}`, :math:`B_{ij}`, :math:`V_{t,0}`,
:math:`V_{t,1}`, :math:`V_{t,2}`, and :math:`V_{t,3}`. In this section we will continue
our journey through the `OPLS paper <https://pubs.acs.org/doi/10.1021/ja00334a030>`_,
seeing how OPLS defines these parameters.

We will work through the parameters in the order they appear in the Equation
:eq:`E_parameters` above. This is different than the order that they present them in the
paper.

Intermolecular Lennard-Jones Parameters
---------------------------------------

The Lennard-Jones parameters for the intermolecular interactions are given in Table III:

.. figure:: /images/OPLS-6.png
   :align: center
   :alt: Intermolecular Lennard-Jones Parameters

   Figure 1: The Intermolecular Lennard-Jones Parameters

It is a bit confusing that they use the parameters :math:`A_{ij}` and :math:`B_{ij}` in
Equation :eq:`E_parameters` but then present the values for a different form of the
equation for the Lennard-Jones potential:

.. math::
   :label: E_lj

   E_{LJ} &= \sum_{i} \sum_{j}^{j>i\,and\,>1,4} \frac{A_{ij}}{r_{ij}^{12}} -
	   \frac{B_{ij}}{r_{ij}^{6}} \\
        &= \sum_{i} \sum_{j}^{j>i\,and\,>1,4} 4 \epsilon_{ij}
	   \left[\left(\frac{\sigma_{ij}}{r_{ij}}\right)^{12} -
	   \left(\frac{\sigma_{ij}}{r_{ij}}\right)^{6}\right]

Just realize that the two forms are equivalent, and there are simple equations to
transform between them.

There is one more detail. Note that in the equation the parameters have two subscripts,
e.g. :math:`\epsilon+{ij}` but those listed in their Table III are for a single (united)
atom, i.e. they have a single index :math:`\epsilon+{i}`. This is common in forcefields,
and is where the :term:`combining rules` come into play, as was mentioned in the
:doc:`functional_form` section. OPLS uses the geometric combining rules:

.. math::
   :label: geometric_combining_rules

   \epsilon_{ij} &= \sqrt{\epsilon_i \epsilon_j} \\
   \sigma_{ij} &= \sqrt{\sigma_i \sigma_j}

or equivalently

.. math::
   
   A_{ij} &= \sqrt{A_i A_j} \\
   B_{ij} &= \sqrt{B_i B_j}
	   

Intramolecular Lennard-Jones Parameters
---------------------------------------

Now that we have understood the intermolecular LJ parameters, let's move on to the
intramolecular ones, which turn out to be much simpler:

.. figure:: /images/OPLS-7.png
   :align: center
   :alt: Intramolecular Lennard-Jones Parameters

   Figure 2: Intermolecular Lennard-Jones parameters.

OPLS uses a single set of parameters for the intramolecular Lennard-Jones terms:

.. math::
   :label: intermolecular_lj_parameters

	\sigma &= 4 \text{ Å} \\
	\epsilon &= 0.0074 \text{ kcal/mol}

These can be used as-is in Equation :eq:`E_lj`.

This coompletes the Lennard-Jones parameters for OPLS.

Torsion Parameters
------------------

There are four parameters for each type of torsion in the truncated Fourier expansion in
Equation :eq:`E_parameters` which are given in Table II:

.. figure:: /images/OPLS-8.png
   :align: center
   :alt: Torsion parameters

   Figure 3: The parameters for the torsions.

The torsion parameters are straightforward: after determining the type of the torsion --
whether it is the single torsion in 1-butene, isopentane, or n-butane, or it is any
other n-alkane -- the values are entered as-is into the equation.

Standard Bond Lengths and Angles
--------------------------------


Equation :eq:`E_parameters` does not explicitly mention the bond lengths and angles
because they do not affect the energy; however, the bond lengths and angles need to be
constrained to the values given in Table I:

.. figure:: /images/OPLS-5.png
   :align: center
   :alt: Fixed bond lengths and angles

   Figure 4: The standard bond lengths and angles.

Summary
-------
We have now found and understood all of the parameters included in the original `OPLS
paper <https://pubs.acs.org/doi/10.1021/ja00334a030>`_. The paper is a bit confusing in
three main parts:

* Using one form of the Lennard-Jones equations in the functional form, but providing
  the parameters for a different form without much comment. This is not an issue if you
  know that there are two equivalent forms of the equation and that it is easy to
  convert the parameters from one form to the other.
* Only very briefly mentioning the combining rules used. This is increasinlgy common in
  papers about forcefields, but until you realize that almost all forcefields and
  programs use combining rules to get the values of :math:`\epsilon_{ij}` from
  :math:`\epsilon_{i}` and :math:`\epsilon_{j}` it is not obvious where the parameters
  with two indices come from.
* The way that the intramolecular Lennard-Jones terms are presented in combination with
  the torsion terms, which creates two different equations for torsions, is confusing
  until you realize that the first, simpler equation is only applicable to molecules
  with atoms no further appart than 1,4. For these molecules, there are no terms in the
  sum over atoms for Lennard-Jones terms in the second, more complex equation so the two
  equations are in practice equivalent. Finally, by removing the Lennard-Jones terms
  from the torsion energy and combining them with the intermolecular Lennard-Jones terms
  the overall equiations are simplified and streamlined to a great extent.

Handling these issues made the discussion in this section longer than it needed to be. The
final summary is quite simple:

* There are two sets of Lennard-Jones parameters, one set for the intermolecular
  interactions and another simple set for all intramolecular interactions, wich are
  limited to atoms that are 1,5 to each other or further apart.
* There are only four sets of torsion parameters: one for the single torsion in each of
  1-butene, isopentane, and n-butane and a final set for all the other torsions in
  normal alkanes.
* The bond lengths and angles are rigidly fixed at the length or angle given in their
  table 1.

Later in the development of forcefields most evolved to a simpler, less specialized
description. For example, there is typically only one set of Lennard-Jones parameters,
which are applied to all atoms seprated by either three or four bonds, or more. Most
forcefields also moved away from united-atoms representations where the hydrogen atoms
were "swallowed" by the carbon atoms they were attached to. In addition, rigid bonds and
angle largely gave way to flexible models except for water itself. 
