.. _tutorial_4:

*****************************
Running from the Command-Line
*****************************

.. note::
   A `video of this tutorial <https://www.youtube.com/watch?v=Wf9GtKu5rGg>`_ is
   available on the `SEAMM YouTube channel
   <https://www.youtube.com/channel/UCF_5Kr_AN90CYb0fTgYQHzQ>`_.

.. attention::
   So far, we have demonstrated how to create and submit a flowchart in the SEAMM graphical
   user interface (GUI), and examine the results using the Dashboard. In this tutorial
   you will

        #. open a flowchart directly from Zenodo instead of building it from scratch,
        #. edit the flowchart by modifying its steps,
        #. learn how to create and use command-line parameters and adopt them in a flowchart,
           and
        #. learn how to execute a flowchart from the command-line interface (CLI).

Start the SEAMM GUI either by using the app or running SEAMM in a terminal window in
the conda enviroment `seamm`. Once the GUI opens, use the ``File/Open`` menu (or the
short cut key ``ctrl-o``) to open a flowchart:

.. figure:: images4/4_open_file_menu.png
   :width: 500px
   :align: center
   :alt: The file menu

   The file menu

The opened dialog will look like the following:

.. figure:: images4/4_open_dialog.png
   :width: 500px
   :align: center
   :alt: The Open dialog

   The Open dialog

.. Tip::
    Instead of storing the flowcharts on our local machines and open them here, we are going
    to get one from Zenodo servers. One can find the pre-made flowcharts at the 
    `SEAMM Flowcharts community <https://zenodo.org/communities/seamm-flowcharts/?page=1&size=20>`_
    or easily import them to your project via SEAMM GUI. 

In the first line of the opened dialog, let us change the ``Open flowchart from local files``
field to ``Open flowchart from Zenodo``. Following this change, the dialog will accordingly update.
Clicking on the ``+`` button allows us to add a filter in the criterion and type `Tutorial` into
the last field in the line that appears. Then, we click on ``Search``. After clicking on the first
entry (``SEAMM Tutorial 1``), our dialog will look like the following:

.. figure:: images4/4_open_zenodo.png
   :width: 500px
   :align: center
   :alt: Open from Zenodo

   Opening a flowchart from Zenodo

Before pressing the ``OK`` button in order to open the flowchart, note that there is a small
drop-down arrow button next to ``SEAMM Tutorial 1`` in the list of tutorials. By clicking on
this arrow button, all available versions of the tutorial will be listed in the expanded
subsection under the tutorial's title:

.. figure:: images4/4_zenodo_versions.png
   :width: 500px
   :align: center
   :alt: Versions of a flowchart

   Selecting a specific version of a flowchart

As such, the SEAMM GUI allows the users to access the entire history of a flowchart and
select the desired version. Here, we select the most recent version and click ``Open``:

.. figure:: images4/4_initial_flowchart.png
   :width: 500px
   :align: center
   :alt: The initial flowchart

   The flowchart for Tutorial 1, read from Zenodo

At this point, if we re-run our previous flowchart as we did in the :ref:`first tutorial
<tutorial-1>`, we get exactly the same results for the ethanethiol molecule. This
is nice from the point of view of reproducibility, but not very useful for pushing
the science for new discoveries. 

In the next step, we will edit our flowchart to accept SMILES strings as the input and
execute our flowchart for ethanol from the CLI. Before getting started, let us make some room
for another step box immediately after the ``Start`` step by clicking on the ``from SMILES``
step and dragging it to the right:

.. figure:: images4/4_edit_1.png
   :width: 500px
   :align: center
   :alt: Moving a step of the flowchart

   Moving a step by dragging it

Next, we right-click on the connecting arrow between the ``Start`` step and the ``from Smiles`` step boxes
and select ``Delete``:

.. figure:: images4/4_edit_2.png
   :width: 500px
   :align: center
   :alt: Deleting a connection

   Deleting the connection between two steps.

Then, we open the ``Control`` section of the left menu and add a ``Parameters`` step:

.. figure:: images4/4_edit_3.png
   :width: 500px
   :align: center
   :alt: Adding the ``Parameters`` step

   Adding the ``Parameters`` step

In the next part, we need to connect the flowchart back together with the new ``Parameters``
step as the first step. Placing the cursor over the ``Parameters`` step box activates its
connection points (red dots) around its edges. By moving the cursor over the center-bottom
connection point, it becomes larger (active) verifying that the mouse is indeed over it.
Let us click and drag the arrow that appears on the center-top connection point of the
``from Smiles`` step. When the aforementioned connection point becomes active, release the
mouse button:

.. figure:: images4/4_edit_4.png
   :width: 500px
   :align: center
   :alt: Connecting two steps

   Connecting the ``Parameters`` and ``from Smiles`` steps

Our current flowchart should look like this:

.. figure:: images4/4_edit_5.png
   :width: 500px
   :align: center
   :alt: Edited flowchart

   The edited flowchart

Although our flowchart is properly working, it is not organized nicely. We could clean
it up by dragging the steps around, but SEAMM can do it automatically. By selecting the
``Clean layout`` command from the ``Edit`` menu, or using the shortcut key ``ctrl-L``,
all steps can snapped into order at once:

.. figure:: images4/4_edit_6.png
   :width: 500px
   :align: center
   :alt: Cleaning the flowchart

   Cleaning the flowchart

At this point, we need to setup the ``Parameters`` step by double-clicking on it or using
right-click and selecting ``Edit``. By clicking on the ``+`` button, one can add another
parameter and set it up as shown:

.. figure:: images4/4_edit_7.png
   :width: 500px
   :align: center
   :alt: Setting the ``Parameters`` step

   Setting the ``Parameters`` step

The name of the variable will be set to ``SMILES`` and expects a single string value.
By default, it is a required (not optional) variable, meaning that its value must be
initialized in the GUI (e.g. using files, manually etc.) or supplied via CLI, e.g.::

  flowchart.flow CCO

where ``CCO`` is the SMILES representation of the ethanol molecule. If you left the SMILES
variable as optional, the supplied SMILES argument in the CLI value must be prefixed by
``--SMILES`` flag as shown below::

  flowchart.flow --SMILES CCO

This method works fine for the optional parameters that have reasonable defaults but 
would not be appropriate in our case because there is no default value for the SMILES
variable.

In the next stage, we need to modify the ``from SMILES`` step. After closing the
``Parameters`` step dialog by clicking ``OK``, we start editing the ``from SMILES``
step:

.. figure:: images4/4_edit_8.png
   :width: 500px
   :align: center
   :alt: Editing the ``from SMILES`` step

   Editing the ``from SMILES`` step

Rather than typing the SMILES for the molecule directly into the entry field, as we did
in the :ref:`first tutorial <tutorial-1>`, this time we type ``$SMILES`` in it. Note
that we are calling the variable ``SMILES`` in the ``Parameters`` step. The dollar 
sign (``$``) in front of the variable name allows SEAMM to know that this is a 
variable and it should access and use its value. We then click ``OK`` to close the
dialog.

Let us save the flowchart (from the ``File`` menu, select ``Save`` or use the shortcut
keys ``ctrl-S``) and store it in a folder that we can easily find. We store our copy 
in ``~/SEAMM/flowcharts`` which we will refer back to in the next few steps.

Now, we switch to a terminal window and type the following::

  (base) psaxe@paul run2 % conda activate seamm
  conda activate seamm
  (seamm) psaxe@paul run2 % ~/SEAMM/flowcharts/tutorial-4.flow --help
  ~/SEAMM/flowcharts/tutorial-4.flow --help
  usage: /Users/psaxe/SEAMM/flowcharts/tutorial-4.flow [-h] [--root ROOT] [--datastore DATASTORE] [--job-id-file JOB_ID_FILE]
                                                       [--dashboards DASHBOARDS]
                                                       [--log-level {NOTSET,DEBUG,INFO,WARNING,ERROR,CRITICAL}]
                                                       [--database DATABASE] [--read-only] [--standalone] [--project PROJECTS]
                                                       [--title TITLE] [--force] [--parallelism {none,mpi,openmp,any}]
                                                       [--ncores NCORES] [--memory MEMORY]
                                                       SMILES start-node-step control-parameters-step from-smiles-step
                                                       dftbplus-step

  positional arguments:
    SMILES                The SMILES for the molecule

  optional arguments:
    -h, --help            show this help message and exit

  main options:
    The main options for SEAMM

    --root ROOT           The root directory for SEAMM data, default: ~/SEAMM
    --datastore DATASTORE
                          The datastore (directory) for this run, default: ${root}/Jobs
  ...

Here, we needed to ensure that the ``seamm`` conda environment is running. Then, we
executed the flowchart with the ``--help`` flag. The output is a bit longer than what
is shown above but is self-explanatory. The first line gives a summary of the command
and all possible options. 

.. Note::
    The ``SMILES`` parameter, as shown in the output above, is not optional and its 
    help message in the output comes from whatever that was typed in its ``Parameters``
    dialog. This is how we can guide other researchers and users to use our flowcharts.

In the next stage, we execute the flowchart::

  (seamm) psaxe@paul run2 % ~/SEAMM/flowcharts/tutorial-4.flow --standalone CCO
  ~/SEAMM/flowcharts/tutorial-4.flow --standalone CCO
  Running in standalone mode.
  Running in directory '/Users/psaxe/tmp/run2'

  Description of the flowchart
  ----------------------------
  Step 0: Start  2022.1.17

  Step 1: Parameters  2021.10.13
      The following variables will be set from command-line arguments, or if
      not present, to the default value.

      +------------+--------+-----------+-----------------------------+
      | Variable   | Type   | Default   | Description                 |
      +============+========+===========+=============================+
      | SMILES     | str    |           | The SMILES for the molecule |
      +------------+--------+-----------+-----------------------------+

  Step 2: from SMILES  2021.10.13
      Create the structure from the SMILES in the variable '$SMILES', overwriting
      the current configuration. The name of the system will be the canonical
      SMILES of the structure. The name of the configuration will be initial.

  Step 3: DFTB+  2022.1.18

     Step 3.1: Choose Parameters
	 Using the '3ob' set of Slater-Koster parameters.

     Step 3.2: Optimization
	 Structural optimization using the Rational Function method with a
	 convergence criterion of 0.0 hartree/bohr. A maximum of 200 will be used.



  Running the flowchart
  ---------------------
  Step 0: Start  2022.1.17

  Step 1: Parameters  2021.10.13
      The following variables have been set from command-line arguments,
      environment variables, a configuration file, (.ini), or a default value, in
      that order.

      +------------+---------+-------------+-----------------------------+
      | Variable   | Value   | Set From    | Description                 |
      +============+=========+=============+=============================+
      | SMILES     | CCO     | commandline | The SMILES for the molecule |
      +------------+---------+-------------+-----------------------------+

  Step 2: from SMILES  2021.10.13
      Create the structure from the SMILES 'CCO', overwriting the current
      configuration. The name of the system will be the canonical SMILES of the
      structure. The name of the configuration will be initial.

      Created a molecular structure with 9 atoms.
	     System name = CCO
      Configuration name = initial

  Step 3: DFTB+  2022.1.18

      Step 3.1: Choose Parameters
	  Using the '3ob' set of Slater-Koster parameters.


      Step 3.2: Optimization
	  Structural optimization using the Rational Function method with a
	  convergence criterion of 0.0001 E_h/a_0. A maximum of 200 will be used.


	  The geometry optimization converged in 25 steps to a total energy of
	  -8.997975 Ha. The calculated formation energy is -274.56 kJ/mol.

  Wrote the final structure to 'final_structure.mmcif' for viewing.

  Primary references:

  (1) Jessica Nash and Eliseo Marin-Rimoldi and Paul Saxe. SEAMM: Simulation
      Environment for Atomistic and Molecular Modeling, version 2022.1.17; The
      Molecular Sciences Software Institute (MolSSI): Virginia Tech, Blacksburg,
      VA, USA, https://doi.org/10.5281/zenodo.5153984, DOI: 10.5281/zenodo.5153984

  (2) O'Boyle, Noel M. and Banck, Michael and James, Craig A. and Morley, Chris
      and Vandermeersch, Tim and Hutchison, Geoffrey R. Open Babel: An open
      chemical toolbox. Journal of Cheminformatics 2011, 3, 33. DOI:
      10.1186/1758-2946-3-33

  (3)  The Open Babel Package, version 3.1.0; Open Babel, http://openbabel.org

  (4) Hourahine, B.; Aradi, B.; Blum, V.; Bonafé, F.; Buccheri, A.; Camacho, C.;
      Cevallos, C.; Deshaye, M. Y.; Dumitrică, T.; Dominguez, A.; Ehlert, S.;
      Elstner, M.; van der Heide, T.; Hermann, J.; Irle, S.; Kranz, J. J.; Köhler,
      C.; Kowalczyk, T.; Kubař, T.; Lee, I. S.; Lutsker, V.; Maurer, R. J.; Min,
      S. K.; Mitchell, I.; Negre, C.; Niehaus, T. A.; Niklasson, A. M. N.; Page,
      A. J.; Pecchia, A.; Penazzi, G.; Persson, M. P.; Řezáč, J.; Sánchez, C. G.;
      Sternberg, M.; Stöhr, M.; Stuckenberg, F.; Tkatchenko, A.; Yu, V. W.-z.;
      Frauenheim, T. DFTB+, a software package for efficient approximate density
      functional theory based atomistic simulations. The Journal of Chemical
      Physics 2020, 152, 124101. DOI: 10.1063/1.5143190

  (5) Gaus, Michael; Goez, Albrecht; Elstner, Marcus. Parametrization and
      Benchmark of DFTB3 for Organic Molecules. Journal of Chemical Theory and
      Computation 2013, 9, 338-354. DOI: 10.1021/ct300849w

  Secondary references:

  (1) Paul Saxe. Control Parameters plug-in for SEAMM, version 2021.10.13; The
      Molecular Sciences Software Institute (MolSSI): Virginia Tech, Blacksburg,
      VA, USA, https://github.com/molssi-seamm/control_parameters_step

  (2) Paul Saxe. From Smiles plug-in for SEAMM for creating structures from
      SMILES, version 2021.10.13; The Molecular Sciences Software Institute
      (MolSSI): Virginia Tech, Blacksburg, VA, USA, https://github.com/molssi-
      seamm/from_smiles_step, DOI: 10.5281/zenodo.5159800

  (3) Paul Saxe. DFTB+ plug-in for SEAMM, version 2022.1.18; The Molecular
      Sciences Software Institute (MolSSI): Virginia Tech, Blacksburg, VA, USA,
      https://github.com/molssi-seamm/dftbplus_step

  Process time: 0:00:00.843663 (0.844 s)
  Elapsed time: 0:00:01.867495 (1.867 s)
  (seamm) psaxe@paul run2 %

The ``--standalone`` flag tells SEAMM to run the flowchart in the current directory
while not adding it to the datastore. This flag is useful for testing the new flowcharts
and avoid filling the datastore with junk.

although by now, we are familiar with the output, let us focus on two of its sections.
In the first part, where SEAMM tries to tell us what it is going to do,::

    Step 1: Parameters  2021.10.13
	The following variables will be set from command-line arguments, or if
	not present, to the default value.

	+------------+--------+-----------+-----------------------------+
	| Variable   | Type   | Default   | Description                 |
	+============+========+===========+=============================+
	| SMILES     | str    |           | The SMILES for the molecule |
	+------------+--------+-----------+-----------------------------+

    Step 2: from SMILES  2021.10.13
	Create the structure from the SMILES in the variable '$SMILES', overwriting
	the current configuration. The name of the system will be the canonical
	SMILES of the structure. The name of the configuration will be initial.

it describes each parameter, which in this case is just a single ``SMILES`` variable
we added. In the ``from SMILES`` step in the first part, SEAMM notifies us
about building the molecular structure using the value stored in the ``SMILES``
variable.

In the next part of the output when SEAMM is actually executing the workflow,
the output becomes more explicit::

    Step 1: Parameters  2021.10.13
	The following variables have been set from command-line arguments,
	environment variables, a configuration file, (.ini), or a default value, in
	that order.

	+------------+---------+-------------+-----------------------------+
	| Variable   | Value   | Set From    | Description                 |
	+============+=========+=============+=============================+
	| SMILES     | CCO     | commandline | The SMILES for the molecule |
	+------------+---------+-------------+-----------------------------+

    Step 2: from SMILES  2021.10.13
	Create the structure from the SMILES 'CCO', overwriting the current
	configuration. The name of the system will be the canonical SMILES of the
	structure. The name of the configuration will be initial.

	Created a molecular structure with 9 atoms.
	       System name = CCO
	Configuration name = initial

In the output shown above, the ``from SMILES`` step now prints out the
actual values of the ``SMILES`` being used to construct the molecule.

.. Note::
    For more clarity, SEAMM prints out the value of the ``SMILES`` variable and the interface,
    within which the variable was set -- in this case, the CLI. Some of the optional parameters
    in SEAMM can be set from the ``seamm.ini`` configuration file should users plan to use them
    frequently.