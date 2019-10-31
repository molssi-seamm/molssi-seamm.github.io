**************
What is SEAMM?
**************
SEAMM is a user-friendly environment for computational molecular and
materials science, using plug-ins to provide a wide range of building,
simulation and analysis tools. SEAMM handles the entire range of
atomic, molecular, crystalline, amorphous, and fluid systems that are
described at the level of atoms and electrons.  SEAMM provides three
important capabilities:

* Productivity_: The computational tools are wrapped with plug-ins that
  adapt them to SEAMM and provide graphical interfaces (GUIs) that help
  you set up calculations without editing complex input files and
  structures by hand.
* `Reproducibility and replicability`_: Computational protocols are
  captured as shareable graphical flowcharts. You can create your own,
  or start with ones created by experts in a particular domain, tweaking
  them to fit your problem.
* A home for tools: SEAMM makes it straightforward for
  developers and other experts to publish their existing and new codes
  and scripts as plug-ins and flowcharts, making them immediately
  available to the entire community.

SEAMM already has plug-ins for LAMMPS and MOPAC, with other quantum
chemistry and forcefield-based MD and Monte Carlo codes coming
soon. Other plug-ins use OpenBabel , RDKit and Packmol for reading in
structures, building fluid boxes, cheminformatic functionality,
etc. The SEAMM environment also provides integrated job management for
running your calculations, and a job database for storing them,
helping you manage the many projects and large numbers of calculations
you do each year.

How do you run a simulation?
############################
You create a flowchart, like this:

.. image:: source/images/flowchart.png
	    :width: 906px
	    :height: 731px
	    :align: center
	    :alt: An example flowchart

that defines the steps you want in your simulation. Once you are
satisfied with it, there are a number ways to run it ... but we are
getting ahead of ourselves!

See the menu for the details about installing SEAMM, making
flowcharts, and running.

.. toctree::
    :maxdepth: 2
    :titlesonly:
    :glob:
    :hidden:

    html/installation
    html/productivity
    html/reproducibility

.. _Productivity: html/productivity.html
.. _Reproducibility and replicability: html/reproducibility.html
