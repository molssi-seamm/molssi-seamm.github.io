***********************
A simple plug-in: PySCF
***********************

Introduction
____________
In this tutorial you will create a very simple plug-in for PySCF. PySCF is a complex,
powerful code so writing a plug-in that does it justice would be a large task. However,
we will build a simple plug-in that only uses a couple of PySCF's features. This will
show you how to get started, and we'll actually be able to do some real calculations!

This tutorial will take 20-30 minutes. At the end we'll think a bit about what it would
take to make a more complete, realistic plug-in. But first, let's get started.

Tutorial
________

This tutorial assumes that you have installed the `SEAMM development environment
<development_environment>`_ and have activated it using::

  conda activate seamm-dev

This tutorial appears quite long, but that is because there is a lot of detail included
-- listing of files, the changes that you need to make, output as well as pictures of
the flowchart, etc. -- because this is the first time you are working on a plug-in. It
is actually not very complicated and there are not that many steps. Hopefully there is
enough detail so that you can see what to do, and fix any small problems that you
encounter.

If you get stuck, got to the `forum <https://matsci.org/c/seamm/61>`_, add a topic and
explain where you are and what is happening. It is a good idea to paste in what is on
you terminal, or screenshots of the GUI or error messages so that there is enough
detail for other users and developers to help you.

Shortly we will place the files, flowchart, etc. here so you can get copies to compare
to what you are doing ... but they aren't here yet :-(.

Here are the sections of the tutorial. When you get to the end of a section, just click
the **Next** button at the lower right corner of the page to move on.

.. toctree::
    :maxdepth: 1
    :titlesonly:

    cookiecutter
    compiling
    code_overview
    customizing
    flowchart
    
