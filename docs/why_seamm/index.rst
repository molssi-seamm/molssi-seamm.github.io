.. _why-seamm:

**********
Why SEAMM?
**********

Computational materials science (CMS) and computational molecular science (CMS) are
rich, expanding fields with many powerful simulation tools covering a vast range of
science and engineering. And that is a problem! While the progress in the field is
wonderful, the large number of tools, the wide range of theories that they are based on,
and the diversity of the areas of application make it difficult to find and use the best
tools for the problems that you are trying to solve. It also leads to a fragmentation in
the field. CMS stands for two different fields that focus on different types of systems
but use similar methods and tools. While there is some interchange between the
communities, there is often also duplication as well as usful tools in the other CMS
field which are overlooked.

The goal of SEAMM is to provide an open -- and open-source -- environment that makes
using these simulation tools easier. Having the tools in a single enviroment makes it
easier to find the right tools, understand how to use them, and combine them into
workflows to address the scientific or engineering problems that you are working on. 

SEAMM itself is not a simulation engine. It is an environment that brings many
simulation software packages together, dare we say, "seamlessly" to improve
:ref:`productivity <productivity>`. SEAMM has :term:`plug-ins <plug-in>` for many CMS
packages, handles installing them, and manages their dependencies. The plug-ins hide the
difficult-to-learn input files and other quirks of the packages behind a unified and
user-friendly graphical user interface (GUI). The GUI's emphasize the similarities
between the codes. This improves the :ref:`user experience <user-experience>`, making it
easier to test and compare tools, and to choose the best one for the current problem.

You don't need to program or write scripts to use SEAMM. You create graphical
:term:`flowcharts <flowchart>` to map your work and the tools you need into
reproducible workflows -- which you and others can use in the future, and which you can
modify and extend over time. There are a growing number of published workflows to help
you get started, and benefit from others' expertise and experience.

We :ref:`SEAMM developers <dev-team>` believe that users of CMS software packages should
be able to spend their time focussing on scientific research and discovery instead
learning different program-specific keywords or resolving software-related issues.  We
have created SEAMM focusing on three major aspects:

1. :ref:`user-experience`
#. :ref:`productivity`
#. :ref:`workflow-features`

We invite you to :ref:`install <installation>` SEAMM and give it a try! It is easy and
convenient and we have prepared :ref:`tutorials <tutorials>` to help you find your path
in this journey. Let us know what you think about SEAMM! Visit the `forum
<https://matsci.org/c/seamm/61>`_ or drop us an email at seamm@molssi.org!

.. toctree::
    :maxdepth: 2
    :titlesonly:
    :hidden:
    
    user_experience
    productivity
    workflow_features
