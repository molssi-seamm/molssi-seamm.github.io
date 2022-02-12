***************
Functional Form
***************

What is the form of the mathematical equations that describe the OPLS forcefield? Let's
wade through the `paper <https://pubs.acs.org/doi/10.1021/ja00334a030>` and see!  The
first relevant part of the description of the forcefield is this:

.. figure:: /images/OPLS-1.png
   :align: center
   :alt: van der Waals interactions in OPLS

   Figure 1: The van der Waals interactions in OPLS

This section is defining the nonbonded interactions between atoms of different molecules,
representing the `van der Waals <https://en.wikipedia.org/wiki/Van_der_Waals_force>`_
interactions between the molecules. There are four main contributions to the interaction
between molecules:

1. The short range repulsion between atoms due to the Pauli repulsion principle;
2. The Coulombic interaction between the permanent charges, dipole, quadrupole
   and higher multipole moments of the molecules;
3. The Coulombic interaction between the multipoles induced on each molecule by the
   other molecules, which is often referred to as the polarization of the molecule;
4. The London dispersion forces due to the interaction of the instantaneous fluctuations
   of the charge distribution on the pair of molecules.

The first term in the OPLS equation above represents the second contribution, the
Coulombic interaction between permanent charges and multipoles. The second and third
terms in the equation are those of the `Lennard-Jones potential
<https://en.wikipedia.org/wiki/Lennard-Jones_potential>`_, which represent the second and
fourth contributions, the repulsive and London forces. OPLS ignores the polarization
contribution, the third contribution listed above.

The text after the equation states that the Lennard-Jones parameters, which in general
are a function of the two atoms interacting, are approximated using `combining rules
<https://en.wikipedia.org/wiki/Combining_rules>`_ and parameters depending on just one
center rather than two. The equations given are called the "geometric combining rules",
which, inexplicably, are not mentioned in the Wikipedia article referenced.

The next section of the paper clarifies some details:

.. figure:: /images/OPLS-2.png
   :align: center
   :alt: United atom description in OPLS

   Figure 2: More detail about the van der Waals interactions

Here we learn three things:

1. Hydrogen atoms are ignored in the OPLS forcefield. The van der Waals
   interactions are between the locations of the carbon atoms. This is usually referred
   to as the united atom approximation.
#. They slip in a bit about the bonds and angles, which are assumed to be fixed lengths
   and angles, as given in Table I. The torsions around bonds, however, are allowed to
   change, but we will get to that in a moment.
#. Finally, in OPLS it is assumed that the :math:`\mathrm{CH}_{n}` groups are electrically
   neutral so there are no charges or multipoles on the molecules. This is an
   approximation, but they argue a reasonable one.

Putting all of this together, we can rewrite their Equation 1 as

.. math::
   :label: epsab

   \epsilon_{ab} = \sum_{i}^{on\,a} \sum_{j}^{on\,b} \frac{A_{ij}}{r_{ij}^{12}} - \frac{B_{ij}}{r_{ij}^{6}}

On to the torsion terms:

.. figure:: /images/OPLS-3.png
   :align: center
   :alt: Torsion (dihedral) description in OPLS

   Figure 3: The torsions in OPLS

This snippet refers to the "internal rotations" of the molecule, though elsewhere they
call them the "torsional motions". This term, which is sometimes called the "dihedral"
term, accounts for the rotational barrier around bonds, typically single bonds. Their
Equation 2 is a Fourier expansion in terms of multiples of the torsional angle
:math:`phi`, truncated after the :math:`4^{th}` term. They note that this is used
for the smaller linear and branched alkanes. A bit further in the paper is a discussion
about the longer normal hydrocarbons n-pentane and n-hexane where they introduce an
extended form of the equation:

.. figure:: /images/OPLS-4.png
   :align: center
   :alt: Torsion description in OPLS for n-pentane and n-hexane

   Figure 4: The torsions in OPLS for n-pentane and n-hexane

Their Equation 3 is written in a perhaps confusing way. It is a combination of their Equation 2,
unchanged, for the torsions in these larger molecules, and a variation of
Equation :eq:`epsab` for the van der Waals interactions but for **intra**\ molecular interactions
rather than the **inter**\ molecular. There is no obvious connection between the these two
terms -- indeed they involve different atoms -- so it is preferable to think of
Equation :eq:`Etorsion` handling all of the torsions in the molecules, and Equation :eq:`epsab` for
handling all the van der Waals interactions, with the restriction that all
intramolecular interactions of atoms separated by 3 or fewer bonds, i.e. 1,4 or less to
each other, are ignored. Note that all the atoms in the first alkanes they mentioned,
n-butane, isopentane, and 1-butene, have no carbon atoms more than two bonds apart, so
the summation in their Equation 3 will have no terms, and hence for those molecules
their Equation 3 is equivalent to Equation :eq:`Etorsion`. Thus the equation for the torsional
energy is

.. math::
   :label: Etorsion

   V(\phi) = V_0 + \frac{1}{2}V_1(1+\cos\phi) + \frac{1}{2}V_2(1-\cos2\phi) + \frac{1}{2}V_3(1+\cos3\phi)


This completes the description of the functional form of the OPLS forcefield as
described in this paper. The functional form is as follows:

1. Equation :eq:`epsab` covers both inter- and intra-molecular van der Waals (nonbonded)
   interactions with the stipulation that the two atoms are separated by more than 3
   bonds, i.e. are 1,5 or greater from each other. The hydrogen atoms are ignored, so
   only the carbon atoms count, and their coordinates are used for the distances in the
   equation.
#. The bond lengths are fixed at given lengths, as are the bond angles.
#. The torsions are handled by Equation :eq:`Etorsion`.

Putting all of this together we can write the total energy of the system as a function
of the coordinates of the atoms :math:`\vec{r_i}` as

.. math::
   :label: E

   E &= F(\vec{r_i})\\
   &= \sum_{i} \sum_{j}^{j>i\,and\,>1,4} \frac{A_{ij}}{r_{ij}^{12}} -
   \frac{B_{ij}}{r_{ij}^{6}} + \sum_{t}^{torsions} V_{t,0} +
   \frac{1}{2}V_{t,1}(1+\cos\phi_t) + \frac{1}{2}V_{t,2}(1-\cos2\phi_t) +
   \frac{1}{2}V_{t,3}(1+\cos3\phi_t)

where the sum over the atoms in the first term, the van der Waals interaction, runs over
the unique pairs of atoms which are either in different molecules or separated by more
than three bonds if the atoms are in the same molecule. The condition :math:`j>i` avoids
double counting the interactions. Remembering the condition that bond lengths and angles
are fixed at specified values, this is the functional form of the OPLS forcefield.
