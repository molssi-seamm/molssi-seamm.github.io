.. _tutorial-1:

***************
Getting Started
***************

This tutorial demonstrates how to create a very simple flowchart and execute its workflow.
In :ref:`dashboard-management` and :ref:`tutorial-2`, we will provide guidance
on how to set up the Dashboard and use it to monitor and inspect the job results. These
tutorials are carefully designed to guide the first-time users of the SEAMM through the
preliminary steps of preparation while delineating its fundamental functionalities in details.
As such, subsequent tutorials will assume that the users have mastered the skills required to
build flowcharts, execute jobs and check the outputs.

First, make sure the Dashboard and Job Server are running. Refer to the :ref:`installation`
section if you do not know or remember how to get them up and running. Open a terminal 
and activate the `seamm` conda environment::

  conda activate seamm

and start the SEAMM GUI by calling its name in the terminal::

  seamm

This will bring up a window like the one shown below:

.. figure:: /images/tutorial_1/EmptySEAMMWindow.png
   :align: center
   :alt: An empty SEAMM window
   
   SEAMM initial window

The window consists of two panes separated by a sash -- the grey line. If you hover over
the sash the cursor will change to a horizontal double-pointed arrow enabling the adjustment
of the pane sizes. The left pane contains the list of available plug-in categories. Clicking
on each category expands its content and represents it as a list of available plug-ins.
Clicking on the same point on the screen will hide the expanded list:

.. figure:: /images/tutorial_1/SEAMMWindow_BuildingExpanded.png
   :align: center
   :alt: Building category of plug-ins expanded

   The SEAMM window with the Building category of plug-ins expanded

The right-hand pane contains the initial step of a flowchart, ``Start``. There must be one
and only one start step in a flowchart because this is where execution starts. Users
cannot delete or add a ``Start`` step.

Let us create a simple flowchart and add a molecule to it using SMILES. SMILES is a specific
representation of a chemical structurs in the string format. Then, we add a new step, in which
we optimize the geometry of the molecule, imported in the previous step, with a semi-empirical
quantum chemistry method.

By clicking on the ``FromSmilesStep`` from the ``Building`` section, a rectangular box
for the new step labeled as ``from SMILES`` appears in the right pane. This box is also connected
to the ``Start`` step:

.. figure:: /images/tutorial_1/SEAMMWindow_FromSMILES.png
   :align: center
   :alt: FLowchart with FromSMILESStep

   The flowchart after adding the FromSMILESStep

If you have accidentally clicked twice on the ``FromSmilesStep`` or any other menu item that you
did not want, just right-click on the unwanted step and select ``delete`` from the poped-up menu:

.. figure:: /images/tutorial_1/SEAMMWindow_DeleteStep.png
   :align: center
   :alt: Deleting a step

   Deleting a step from a flowchart

In the next stage, we need to set the SMILES string variable for the added molecule. Almost every
step has a dialog window that allows the users to set parameters and control the details of the task
in each step of the workflow. In order to access thedialog, one can either right-click on the step box
and select ``Edit...`` from the menu or just double-click on the step box to open it:

.. figure:: /images/tutorial_1/SEAMMWindow_FromSMILESDialog.png
   :align: center
   :alt: The dialog for the FromSMILES step

   The dialog for the FromSMILES step

Click in the field labeled ``SMILES`` and type `CCS`, which is the SMILES representation
for ethanethiol. Leave everything else as is and click on the ``OK`` button:

.. figure:: /images/tutorial_1/SEAMMWindow_FromSMILESDialog2.png
   :align: center
   :alt: The dialog for the FromSMILES step

   The completed dialog for the FromSMILES step

Now, open the ``Simulations`` section in the left panel and add a ``DFTB+`` step:

.. figure:: /images/tutorial_1/SEAMMWindow_DFTBplus.png
   :align: center
   :alt: The flowchart with the DFTB+ step added

   The flowchart with the DFTB+ step added

Then, open the dialog for the DFTB+ step:

.. figure:: /images/tutorial_1/SEAMMWindow_DFTBplusDialog.png
   :align: center
   :alt: The dialog for the DFTB+ step

   The dialog for the DFTB+ step

Note that this dialog looks like the main SEAMM window. Some steps, like the ``FromSMILES``
step, perform one task and thus, can be handled by a single dialog. However, many
simulation codes such as DFTB+, are capable of performing multiple tasks and often have 
their own syntax. Open the ``Setup`` and ``Simulation`` sections on the left panel and
add a ``ChooseParameters`` step followed by ``Optimization``:

.. figure:: /images/tutorial_1/SEAMMWindow_DFTBplusFlowchart.png
   :align: center
   :alt: The flowchart for DFTB+

   The flowchart for DFTB+

Open the dialog for the ``ChooseParameters`` step by double-clicking on it:

.. figure:: /images/tutorial_1/SEAMMWindow_DFTBplusChooseParameters.png
   :align: center
   :alt: The DFTB+ ChooseParameters dialog

   The dialog for the DFTB+ ChooseParameters step

The ``ChooseParameters`` dialog is quite a large and complex but at least, it is organized
similar to a periodic table! 

A short description of how DFTB+ works is in order. DFTB+ is a semiempirical quantum 
chemistry code. It uses parameterized `Slater-Koster` functions for each atom. However,
several parameterizations are available to choose from. These datasets are listed in the
pull-down button near the bottom fo the dialog window that is currently opened. Some of the
datasets have additional add-on datasets that either add more elements to the existing sets
or are tuned for different systems and properties. More information about the parameter sets
can be found in the `DFTB website <https://dftb.org/parameters/download>`_.

Unfortunately, the aforementioned datasets do not cover all elements. As such, one needs
to find an appropriate dataset that can handle all elements of interest. The 
``ChooseParameters`` dialog offers two ways to find the appropriate parameters set.
In the first approach, when a dataset and perhaps an auxiliary dataset is selected from the
two pull-down buttons at the bottom of the dialog, the supported elements within the periodic
table are automatically highlighted in red. The default dataset, ``ob3``, can handle a list of
elements including H, C, N, O, F, Na, Mg, P, S, Cl, Zn, Br, I, and Ca, which would be suitable
for our ethanethiol example as well as a wide range of organic molecules that are made of the
aforementioned elements.

In the second approach, one can select the desired set of elements, say, H, C, N, O, S, and Zn.
Then, check the drop-down button at the bottom of the dialog to see what choices are available
for the selected set of elements:

.. figure:: /images/tutorial_1/SEAMMWindow_ChooseParametersSelected.png
   :align: center
   :alt: The ChooseParameters dialog with elements selected

   The ChooseParameters dialog with elements selected

For our selected set of elements mentioned above, only ``3ob`` and ``mio`` provide global support.
Let us keep the default dataset, ``3ob``, because it is the newest and one of the most general datasets.

Let us take a look at the ``Optimization`` dialog:

.. figure:: /images/tutorial_1/SEAMMWindow_Optimization.png
   :align: center
   :alt: The DFTB+ Optimization dialog

   The DFTB+ Optimization dialog

There are certainly a lot of choices available. On the left side of the dialog, there are
options for controlling the Hamiltonian and the physical approximations being made. The 
right-hand side of the dialog consists of parameters for controlling the geometry optimzation
procedure. The pre-defined default values are often reasonable. Thus, let us leave them
untouched by clicking ``Cancel`` and leaving all control parameters unchanged.

.. tip::
   If you do not intend to make any changes in a dialog, it is a good idea to close it with
   the ``Cancel`` button. It is a common habit to click ``OK``, but pressing the latter button
   saves any changes that are made unintentionally and remained overlooked. Such accidental
   mistakes might result in calculations with unusual behavior and surprising outcomes far 
   from your expectations. Therefore, we recommend using the ``Cancel`` button unless you 
   actually want to make and save changes in the dialog.

Click ``OK`` to close the DFTB+ dialog to save your changes. In order to execute the
calculation, click on the ``File`` menu and select ``Run`` or use the accelerator
(⌘R on a Mac, ^R on Windows or Linux) to get the following dialog:

.. figure:: /images/tutorial_1/SEAMMWindow_RunDialog.png
   :align: center
   :alt: The Run Dialog

   The Run dialog in SEAMM

If the ``Project`` field is empty or not set, type `default` in it and then, add a useful title in
the ``Title`` field. Briefly describe your goal and the details of your simulation workflow within
the large text area at the bottom of the dialog. Finally, click ``OK`` to execute the calculation.

In the next two tutorials, we will demonstrate how to set up and work with Dashboard in order to
monitor and manage the executed jobs.
