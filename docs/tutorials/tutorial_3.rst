.. _tutorial-3:

****************
Tables and Loops
****************

In the previous tutorials, we have demonstrated how to set up a flowchart, execute a job,
and inspect the results using the Dashboard. While it is nice to be able to run a
complicated simulations on a single chemical structure, it is often much more useful
to run the same protocol on a number of compounds to look for trends in the desired
physical or chemical properties. In this tutorial we will explore how perform complex
operations in SEAMM. 

Let us begin with creating a set of molecules from their SMILES representation by
storing a list of SMILES strings in a ``.csv`` file. In the next step, we loop over
each line in the file which correspond to each chemical structure and calculate
a group of properties, this time using `MOPAC` semi-empirical quantum chemistry
program package.

On your local machine, create a new empty file store the SMILES strings in it as shown below::

  SMILES
  C
  CC
  CCO
  CCS
  OCCO
  c1ccccc1
  c1ccccc1O

Then save the file with the ``.csv`` (comma-separated values) extension. For the purpose of
this tutorial, we have made a subdirectory of ``~/SEAMM`` called ``data`` and named the
aforementioned file ``smiles.csv``.

Next, make sure the the Dashboard and Job Server are running (see the :ref:`installation` section
for further details). Then, activate the `seamm` conda environment and start the SEAMM::

  conda activate seamm
  seamm

Now, create a flowchart with the following steps:

#. Table -- this is where we will read the table that you made
#. Join
#. Loop -- this will be set to loop over the molecules in the table
#. FromSMILES -- will create each structure in turn
#. MOPAC -- will optimize the geometry and calculate properties
#. Table -- will print the table so we can see the progress
#. Table -- will save the table

which should look like the following:

.. figure:: /images/tutorial_3/partial_flowchart.png
   :align: center
   :alt: A partial flowchart for looping over a table

   *The initial skeleton of the flowchart*

Open the dialog for the first Table step either by right-clicking and selecting
``Edit...`` from the pop-up menu or simply double-clicking on the step rectangular
box. Change the ``Operation`` to ``read`` and type the path to your file in the
``from file`` entry field:

.. figure:: /images/tutorial_3/table_1.png
   :align: center
   :alt: The dialog for a Table step

   *The dialog for the first Table step*

Then, edit the ``Loop`` step and change the first item from ``For`` to ``For rows in table``
by clicking on the arrow on the right and selecting the aforementioned option from the menu.

The next part to edit is the ``FromSMILES`` step. Set the SMILES entry to ``$_row["SMILES"]``:

.. figure:: /images/tutorial_3/from_smiles.png
   :align: center
   :alt: The dialog for a FromSMILES step

   *The dialog for the FromSMILES step*

The loop automatically initializes some variables, the names of which start with an
underscore ``_<name>`` to prevent conflicts with the user-defined variables.

.. Attention::
   Do not create variable names starting with an underscore!

When looping over the table row entries, the dictionary variable `_row` gets labeled
by the column headers and stores the entry values for each data instance.
Hence, ``$_row["SMILES"]`` refers the value of an individual entry within the SMILES string
label (column). If our table had more columns, we could access each value using the name of
the column by using ``$_row["<column-name>"]``.

In the next stage, let us edit the MOPAC step. Similar to DFTB+, MOPAC includes a sub-flowchart.
Add a single `Optimization` task to its flowchart and open it for further modifications:

.. figure:: /images/tutorial_3/mopac_optimization.png
   :align: center
   :alt: The dialog for a MOPAC Optimization step

   *The dialog for the MOPAC Optimization step*

Then, click on the ``Results`` tab at the top of the page:

.. figure:: /images/tutorial_3/mopac_results.png
   :align: center
   :alt: The results tab for MOPAC Optimization

   *Saving the results from a MOPAC optimization calculation*

There are five columns in the table of results:

**Result**
  The property or other computed result

**Save**
  Used to store a specific value in a variable

**Variable name**
  The name of a variable which is editable

**In table**
  The table for storing the results

**Column name**
  The name of the column in the table

Only the scalar values can be stored in tables. Let us save the ``area``, ``dipole``,
``heat of formation``, ``ionization potential`` and ``volume`` in our table
named **table1**. Type in **table1** in the ``Table`` column for each of the above properties.

.. hint::
   You can copy and paste the values by using ⌘C or ^C and ⌘V or ^V shortcut keys, respectively.


.. figure:: /images/tutorial_3/mopac_results_2.png
   :align: center
   :alt: The dialog showing MOPAC Optimization results

   *Saving results from Optimization in MOPAC*

Note that we changed the column name for the ionization potential to ``IP`` for brevity.
Click ``OK`` to save the changes to the ``Results``, and click ``OK`` to save the 
sub-flowchart for MOPAC.

Next, in the second ``Table`` step, change the ``Operation`` to ``save`` and in
the third ``Table`` step, change the same ``Operation`` to ``print current row``.
We save the table after working on every molecule entry and thus, we do not lose
any information if e.g., the job crashes. Simultaneously, by printing each row,
we will be able to see our progress. In our present case, the aforementioned features
might not seem significant because MOPAC is very fast and our calculation involves
only a handful of molecules. However, if we execute our flowcharts on thousands of
molecular structures using a more accurate but slower quantum chemistry method, saving
incremental progress becomes crucial.

At this point, we have set up all required steps. Now, we are almost ready to execute
the flowchart. Before doing so, we need to close the loop in our flowchart. To do this,
we are going to drag an arrow from the last ``Table`` step up to the ``Join`` step,
just before the ``Loop`` box. Note that when the mouse is over a step box, the red
dots will appear around its edges. These red dots are in fact connection points allowing
the users to connect different steps together. When the mouse pointer is hovered over
one of the connection points, the red dot becomes larger indicating that it has become
active and ready to make a connection:

.. figure:: /images/tutorial_3/closing_1.png
   :align: center
   :alt: The flowchart with an active connection

   *Active connection dot on last Table step*

Click on an active connection point (red dots around the step boxes) and drag a connecting
arrow to the ``Join`` step. As you get closer to the ``Join`` step box, its connection dots
will appear around it. Hover the mouse pointer over the connection point on the right
side of the ``Join`` box until it becomes active. Now, release the mouse button to create
the connection.

.. note::
   At the moment, the position of the mouse pointer on the ``Join`` step is quite sensitive. So,
   care must be taken when hovering the mouse over the connection points. If one releases the
   mouse button before the mouse pointer is exactly on the active connection point, the connection
   arrow will disappear. This issue will be resolved in the upcoming releases.

.. figure:: /images/tutorial_3/closing_2.png
   :align: center
   :alt: Dropping the connection on the Join step

   *Dropping the connection on the Join step*

Upon making a connection between the last ``Table`` step and the ``Join`` step, the
flowchart will look like the following:

.. figure:: /images/tutorial_3/closing_3.png
   :align: center
   :alt: Initial connection closing a loop

   *The connection closing the loop*

The flowchart shown above does not look well-organized. Under the Edit
menu click on ``Clean layout`` item. This will automatically clean the
flowchart layout to a standard form:

.. figure:: /images/tutorial_3/closing_4.png
   :align: center
   :alt: Final flowchart

   *Completed flowchart*

At this point, all that is left is to run the flowchart. Select ``Run`` from the ``File``
menu, fill out the form with an appropriate title and description, and click on the ``OK``
button. Next, navigate back to the browser and open the DashBoard at http://localhost:5000.
After logging in, check the list of the executed jobs within the workflow and explore 
the results of the current job. Pay attention to the table of results printed in the 
``job.out`` file:

.. figure:: /images/tutorial_3/table.png
   :align: center
   :alt: Job.out showing the table of results

   *The printed table of results*

By double-clicking on the ``Step 3`` folder within the directory section on the left pane,
all subdirectories corresponding to the ``Loop`` step iterations over all molecular SMILES will
appear in the expanded section. Opening one of the iteration subdirectories shows all pertinent input,
output, or intermediate files for that iteration including the structure and ``iteration.out``
which is an output summary much like the ``job.out`` file but specifically for one iteration:

.. figure:: /images/tutorial_3/iterations.png
   :align: center
   :alt: Dashboard showing iterations of a loop

   *DashBoard show an iteration of the loop*

Finally, by looking at the CSV file that is created, one can inspect the updated properties
resulting from MOPAC::

  ,SMILES,area,dipole,heat_of_formation,IP,volume
  0,C,54.8143,0.00181763,-14.4037,13.7252,37.0557
  1,CC,75.9592,0.00060312,-18.1965,11.9601,57.5002
  2,CCO,86.8539,2.05345,-57.8213,10.6488,68.9072
  3,CCS,102.311,2.12867,-11.5302,8.86456,87.7266
  4,OCCO,96.9126,0.507571,-95.5368,10.4813,80.4314
  5,c1ccccc1,119.695,6.72145e-05,22.9566,9.82405,108.368
  6,c1ccccc1O,129.604,1.30752,-22.1564,9.2356,119.327

In this tutorial, we have demonstrated how to use loops to iterate over the entry rows
of a table and how to use tables to store the results of our calculations.
