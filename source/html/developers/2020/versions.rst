.. _2020_versions:

***************************
Support for Plugin Versions
***************************

Goals and Motivation
--------------------
The goal and the motivation is reproducibility -- the ability to rerun
a calculation the same way and get the same answers. In itself, this
is not all that useful; however, its if extremely valuable when the
results are unexpected, or when they seem to disagree with other,
similar results. Then the question becomes are the results correct,
and if two sets disagree, are they both correct results or is there an
error. We need to run the calculation with different versions of
codes, with slightly different parameters, etc. to understand whether
there is an issue, and what it is. This forensic analysis relies on
being able to check the original results, and hnece the need for
reproducibility.

Requirements
------------
1. Ability to run a flowchart a second time, at some later date, using
   the same version of the plugins and background codes. 
#. Ability to run a flowchart with the latest versions of all codes.
#. Possibility of running a flowchart with specified versions of each
   plugin and code, where the specified version is neither the
   original version used nor the current version.

Tasks:
------
1. Capture the "standard" environment for each plugin when it runs. We
   will need to define what we mean by this "standard" environment --
   for example, if it is the environment used to test the plugin for
   release, or that used in the initial version of the flowchart, or
   something else.
#. Create the ability to reinstate the "standard" environment for each
   plugin, and run the plugin in that environment ase the flowchart is
   executed.
#. Provide options to run the flowchart using the original plugin
   environments, or the current environments, or using manually
   defined verions.

Results and Discussion
----------------------
This is a formidable problem. While tracking versions is not that
difficult, the definition of a version is more challenging, and
keeping and instantiating versions at will is a considerable
logistical challenge.

Let's use a simple, concrete example to help understand the issues,
for example a LAMMPS plugin and the associated version of
LAMMPS. Starting with the plugin, clearly it has a version that can be
tracked. However, that plugin runs under a particular version of
Python. Is that version important? The LAMMPS plugin depends directly
on nine other Python modules, which in turn depend on yet other Python
modules. Are the versions of the direct dependencies important? Of the
indirect dependencies?

We face a similar situation with the LAMMPS executable, which has a
version but also a variety of optional components that are chosen when
compiling LAMMPS. LAMMPS also depends directly on other libraries for
linear algebra, fast fourier transforms, etc. plus for MPI, CUDA and
other lower level functionality.



