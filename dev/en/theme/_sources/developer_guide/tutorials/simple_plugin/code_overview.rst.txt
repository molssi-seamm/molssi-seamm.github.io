***********************
An overview of the code
***********************

Let's dive into the code and see what is where. Almost all the files that you will work
with are in the subdirectory `pyscf_step`, so change into that directory and look at the
files::

  (seamm-dev) psaxe@PaulsPersonal pyscf_step % ls -l
  ls -l
  total 96
  -rw-r--r--  1 psaxe  staff    661 Aug 23 10:11 __init__.py
  drwxr-xr-x  8 psaxe  staff    256 Aug 23 11:46 __pycache__
  -rw-r--r--  1 psaxe  staff  18471 Aug 23 10:11 _version.py
  drwxr-xr-x  3 psaxe  staff     96 Aug 23 10:11 data
  -rw-r--r--  1 psaxe  staff   5298 Aug 23 11:39 pyscf.py
  -rw-r--r--  1 psaxe  staff   3618 Aug 23 11:39 pyscf_parameters.py
  -rw-r--r--  1 psaxe  staff   2887 Aug 23 10:11 pyscf_step.py
  -rw-r--r--  1 psaxe  staff   6582 Aug 23 10:11 tk_pyscf.py

  (seamm-dev) psaxe@PaulsPersonal pyscf_step % ls -l data
  ls -l data
  total 8
  -rw-r--r--  1 psaxe  staff  1558 Aug 23 10:11 references.bib

pyscf_step.py
  This file contains factories for creating the graphical and non-graphical classes for
  the PySCF step. You shouldn't change anything in this file other than the
  description::

    my_description = {
        "description": "An interface for PySCF",
        "group": "Simulations",
        "name": "PySCF",
    }

  The only part of this that is used at the moment is the **group**, which defines where
  in the left hand panel of SEAMM this plug-in appears. By default it is "Simulations",
  which is why our brand new plug-in showed up in the simulation section. When you make
  plug-ins, you might want to change this to an appropriate area for your plug-in. You
  can either use one of the existing groupings, or create a new one by typing a new
  name.

pyscf_parameters.py
  This file defines the parameters that the plug-in provides to control what it
  does. The skeleton created by the cookiecutter has one parameter as an example::

    parameters = {
        "time": {
            "default": 100.0,
            "kind": "float",
            "default_units": "ps",
            "enumeration": tuple(),
            "format_string": ".1f",
            "description": "Simulation time:",
            "help_text": ("The time to simulate in the dynamics run."),
        },
    }

  That is why the dialog showed a parameters for **Simulation time**. We'll edit this in
  a minute.

tk_pyscf.py
  This contains the TkPySCF class, which defines the GUI for the plug-in. Generally any
  file in SEAMM starting with "tk\_" is part of the GUI.

pyscf.py
  This contains the PySCF class, which handles running PySCF when the flowchart is
  executed. We'll also come back to this file.

data/references.bib
  Contains the references that users should cite when using this plug-in. This will be
  covered in another tutorial; however, a reference to the plug-in has been
  automatically generated from the questions the cookiecutter asked, and will be
  printed when this step is irun. 
