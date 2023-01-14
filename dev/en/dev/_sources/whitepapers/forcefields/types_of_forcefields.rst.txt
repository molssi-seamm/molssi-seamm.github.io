********************
Types of Forcefields
********************

Forcefields, or potentials as they are often called in the physics and materials
communities, have a staggering variety of forms and parameters. Here we will try to give
an overview and rough taxonomy.

Valence Forcefields
-------------------
These forcefields are commonly applied to organic compounds, and the closely related
bioorganic compounds and synthetic polymers. They work well for compounds with
well-defined valences and geometries that reflect the valence. As any chemist knows,
carbon and the other "organic" elements have strong hybridization states that lead
directly to the geometry -- tetrahedral :math:`sp^3` states; trigonal for :math:`sp^2`;
and linear for :math:`sp`. Organic compounds are well described in terms of bonds,
angles between bonds, torsions around bonds, and out-of-plane terms that, for instance,
ensure that benzene remains reasonably flat.

A few common elements, such as P and S, can have a couple valences depending whether
their d-orbitals are involved. This leads to minor issues in valence forcefields, but
usually such atoms are assigned to one form or the other, and everything else works
well. Organometallic structure display even more complex bonding patterns, and while
there have been some forcefields developed for organometallics, they tend to be less
general as well as less accurate. Valence forcefields can also be used for e.g. oxide
and semiconductor materials that show strong valence effects.

There are a number of categories of valence forcefields:

.. glossary::

   United-atom
       These forcefields replace groups of atoms, typically CH4, -CH3, -CH2-, and >CH-, with
       a single center at the position of the carbon atom and absorb the hydrogen atoms
       into that site in terms of both mass and effective parameters. Many fo the
       united-atom forcefields are older, reflecting limited computing resources along
       with less experimental data for fitting. The functional form of united-atom
       forcefields are typically simple, with only 'diagonal' terms: bonds, angles, etc.
       Examples are OPLS, TraPPE, and some older version of AMBER, etc.

       There are also a few anisotropic united-atom forcefields, used mainly in Monte
       Carlo simulations. While the hydrogens are removed from the description the
       charge and force centers may not be on atoms, but a defined distance from
       them. This makes calculating forces, and hence MD, difficult, but for Monte Carlo
       calculations, which do not need forces, the anisotropic terms can improve
       accuracy whilst still removing the hydrogen atoms, which are difficult to handle
       efficiently in Monte Carlo. Offsite centers are also frequently used in water
       models, such as TIP-4P and TIP-5P, for better descriptions of such a
       fundamentally important molecule and fluid/

   Class I or all-atom
       Along with the united-atom forcefields, these are the original forcefields and
       are still used widely. While still using only 'diagonal' terms, the hydrogens are
       explicitly accounted for. Most of the main valence forcefields are in this
       category: AMBER, CHARMM, OPLS-AA, ECEPP, GROMOS. There are also a few forcefields
       in this category, such as UFF, with very wide coverage across the periodic table,
       albeit with less accuracy.

   Class II
       The main feature of the Class II forcefield is their extensive use of cross-terms
       such as bond-bond, bond-angle, angle-angle and bond-torsion terms. These are "off
       diagonal" terms, and are necessary to fit vibrational frequencies and perhaps to
       get better quality fits. Class I forcefields were given that name later to
       distinguish them from Class II forcefields. The main examples are the CFF
       forcefields of both Lifson and Hagler, CVFF, and MMCFF.

   Polarizable
       The forcefields above rely on fixed charges on atoms to emulate the
       electrostatics of the system. Polarizable forcefields account for the
       polarization due to the charges of neighboring atoms, which is needed for high
       accuracy bt comes at a cost of complexity and computer time. The polarizable
       forcefields rely on either a Class I or II description for the bonded terms.

    Reactive Forcefields
       Most valence forcefields cannot handle bond breaking and creation. However, there
       are some, notably ReaxFF, which can. Obviously such a forcefield does not have
       fixed sets of bonds, angles, etc. so is quite different than traditional valence
       forcefields. They are, however, conceptually similar and and represent a
       chemist's view of structures, as opposed to other views that will appear later in
       this description.

These categories are fuzzy and there are more minor categories as well as variants, but
this will suffice for an overview.

Physics and Materials Science Interatomic Potentials
----------------------------------------------------

Valence forcefields are not useful for many inorganic systems and certainly not for
metals and allows, where there is no well-defined bonding in the organic chemistry
sense. The physics and materials science communities, which are closely related, look at
the problem as a more general expansion of one-body, two-body, three-body interactions
and so on, and call them interatomic potentials.

.. math::
   :label: e_potential

   E = \sum_{i}^{N} E_1(\vec{r_i}) + \sum_i^N \sum_j^{<i} E_2(\vec{r_i},\vec{r_j}) +
   \sum_i^N \sum_j^{<i} \sum_k^{<j} E_3(\vec{r_i},\vec{r_j},\vec{r_k}) + \dots

However, they are conceptually the same as forcefields and vice versa. Interatomic
potentials have a functional form and parameters, but since there are no obvious bonds,
angles, etc. as there are in organic chemistry, expanding the energy in these valence
terms does not work.

Since interatomic potentials do not focus on valence chemistry, almost all are capable
of describing systems where the number and nature of bonds change. Thus they are to some
extent reactive forcefields.

.. glossary::

   Pair Potentials
      The simplest two-body expansion is probably the classic Lennard-Jones potential
      that we saw in the description of the van der Waals interactions in OPLS. Standing
      alone, Lennard-Jones potentials are an excellent description of the noble gasses
      and a surprisingly good description of many other monatomic systems. There are
      similar potentials with slightly more complex forms such as Buckingham potentials,
      and Morse potentials.

   Stillinger-Weber Potentials
      These are a class of 3-body potentials based on the distances and angles between
      the atoms:

      .. math::
         :label: e_stillinger-weber

         E = \sum_i^N \sum_j^{<i} E_2(r_{ij}) + \sum_i^N \sum_j^{<i} \sum_k^{<j}
         E_3(r_{ij}, r_{ik}, \theta_{i,j,k})

      Originally developed to describe silicon, the Stillinger-Weber potentials have been
      expanded to a wide range of materials.

   Bond-Order Potentials
      This class of potentials are based on the idea that the strength of a chemical
      bonds depends on the bonding environment and the number of bonds plus perhaps
      their lengths and angles:
      
      .. math::
         :label: e_bop

         E = \sum_i^N \sum_j^{<i} E_{repulsive}(r_{ij}) + \sum_i^N \sum_j^{<i} \sum_k^{<j}
         b_{ijk} V_{attractive}(r_{ij})

      Tersoff and Brenner potentials are examples that are widely used, as are the
      Finnis-Sinclair potentials. While developed independently, it has been shown that
      if the :math:`b_{ijk}` term has no angular dependence, the bond order potentials
      are equivalent to the embedded atom method (EAM) potentials.

      Technically the ReaxFF forcefield falls into this class; however, we have chosen
      to place it with the chemistry forcefields due to its chemical approach.

   Embedded Atom Method (EAM)
      Developed by Daw and Baskes in 1984, the EAM is actually related to density
      functional methods and in particular the Harris functional, which is a
      non-self-consistent approximation of the Kohn-Sham equations for DFT. The energy
      of the system is a functional of the density, with the key observation that the
      energy of the system with one atom added can be obtained with the unchanged density
      of the initial system. In the EAM the densities of the atoms are parameterized, as
      is the embedding function :math:`F`:

      .. math::
         :label: e_eam

         E = \sum_i^N F_i \left(\sum_j \rho(r_{ij})\right)  + \sum_i^N \sum_j^{<i}
	 V_2(r_{ij})

      where :math:`F` is the embedding function; :math:`rho`, the density on the atom
      j; and :math:`V_2` is a purely repulsive potential related to the Pauli exclusion
      term.

      In practice the summations over neighboring atoms converge rapidly, only requiring
      neighbors within a short distance, so the EAM potentials are not much more
      expensive computationally than the Lennard-Jones potentials. The EAM method is
      widely used to simulate metals.

   Modified Embedded Atom Method (MEAM)
      An extension of the EAM potentials that includes angular terms:

      .. math::
         :label: e_meam

         E = \sum_i^N F_i \left(\sum_j \rho(r_{ij}) +  \sum_{j,k} f(r_{ij}) f(r_{ik})
	 g\left( cos(\theta_{ijk})\right) \right)  + \sum_i^N \sum_j^{<i}
	 V_2(r_{ij})

   Charge Optimized Many Body (COMB) Potentials
      The COMB potentials, like ReaxFF, straddle the boundary between chemistry and
      physics. The COMB potentials are similar to the EAM and Finnis-Sinclair potentials
      but extended to handle the concept of charges on the atoms and the Coulombic
      interactions between them. This allows the COMB potentials to handle ionic systems
      and simulations where the interest is the charge distribution at e.g. interfaces.
      
