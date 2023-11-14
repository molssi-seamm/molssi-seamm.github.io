.. _tutorial-3:

**************************
3: Variables in Flowcharts
**************************

.. Note::
   The flowchart for this tutorial is available at |flowchart_link| and also can be
   directly loaded into SEAMM by opening from Zenodo. The job for this tutorial is
   available on MolSSI's public server, |job_link|.

Introduction
------------
In the previous tutorials, you learned how to set up a flowchart, execute a job, and
inspect the results using the Dashboard. That is a good start, but if you want to run
calculations on several molecules it is tedious to have to edit the flowchart and change
e.g. the :term:`SMILES` string for each molecule. In this tutorial you'll learn how to
use variables to make the first flowchart more general, able to run different molecules
easily.

We want to make a flowchart like this:

.. figure:: images/tutorial_3/step_4.png
   :align: center
   :alt: The flowchart

   *The flowchart*

This is the flowchart from the tutorial :ref:`tutorial-1` with two changes: the addition
of the control parameters step, and changing the ``from SMILES`` step to use a
vaoriable.

Editing the Flowchart
---------------------
Let's start with the original flowchart and edit it to get the new one. (If you don't
still have the flowchart, jump back to :ref:`tutorial-1` and create it again. It will be
quick this second time.) First we want to add the control parameters step. Drag the
``from SMILES`` step to the right to get it out of the way. Click the left mouse button
on the ``from SMILES`` step. Its outline will turn red. With the mouse button held down,
drag it a bit to the right. Next, delete the connection from Start to it by
right-clicking on the arrow:

.. figure:: images/tutorial_3/step_1.png
   :align: center
   :alt: The disconnecting the ``from SMILES`` step

   *Disconnecting the ``from SMILES`` step*

Next add a control parameters step from the left pane, which is **Parameters** in the
**Control** section:

.. figure:: images/tutorial_3/step_2.png
   :align: center
   :alt: Adding the control parameters step

   *Adding the control parameters step*

Now we need to connect it to the ``from SMILES`` step. When you put the mouse on the
``Parameters`` step, small red dots appear on its frame. Move the mouse over the central dot
on the bottom of the rectangle. The dot will become much larger. Click the mouse and
drag to the top of the ``from SMILES`` step. As you go over the ``from SMILES`` step dots will
appear on its frame. Move the mouse and the arrow it is dragging over the center top dot,
which will become larger. When it does, release the mouse button. If the arrow
disappears you missed the dot. Try again! It should look like this:

.. figure:: images/tutorial_3/step_3.png
   :align: center
   :alt: Dragging the arrow

   *Connecting the Parameters and ``from SMILES`` steps*

Almost done! The flowchart will work as it is, but it is a bit ugly. You can drag the
steps around to make it look nicer but there is an easier way. Go to the **Edit** menu
and select **Clean Layout** or use the accelerator (⌘L on a Mac, ^L on Windows or
Linux). That will snap the steps into place:

.. figure:: images/tutorial_3/step_4.png
   :align: center
   :alt: Snapping steps into place

   *Flowchart after cleaning the layout*

That looks right! Now we need to set up and use the variable. Edit the ``Parameters``
step -- either double-click or right-click and select **Edit...**:


.. figure:: images/tutorial_3/step_5.png
   :align: center
   :alt: Editing the parameters

   *Editing the parameters*

Click the **+** sign to add another parameter, give it a name ("SMILES"), change the
type to **str**, make it not optional, and give it some reasonable Help text:


.. figure:: images/tutorial_3/step_6.png
   :align: center
   :alt: Dragging the arrow

   Creating a **SMILES** parameter

Click on **OK** to close the dialog and add the parameter, and click OK again to close
the dialog for the ``Parameters`` step.

You have created a required parameter named **SMILES**. All that remains is to use it in
the ``from SMILES`` step, so edit that step:

.. figure:: images/tutorial_3/step_7.png
   :align: center
   :alt: Editing the ``from SMILES`` step

   *Using the new parameter in the ``from SMILES`` step*

Replace **CCS** in the **Input:** field with **$SMILES**. Note the dollar sign **$**, which
indicates that this is a variable, not a string.

That's it! The flowchart is ready.

Running the Job
---------------
Now run another job (File / Run or ⌘R on a Mac, ^R on Windows or Linux):

.. figure:: images/tutorial_3/run.png
   :align: center
   :alt: Run dialog

   *Setting parameters when submitting a job*

Note at the bottom of the dialog there is an entry field for putting in a value for the
**SMILES** variable, with the helpful description that you gave. This time let's
run ethanol, so put **CCO** in the entry area, and adjust the title and description to
reflect that you are running ethanol this time. Then click OK to run the job.

Head over to the Dashboard in your web browser and check that the job ran, and look at
the results. 

Topics Covered
--------------
#. Dragging steps in a flowchart.
#. Removing and adding connections.
#. Defining parameters in the ``Parameter`` step.
#. Using a variable.
#. Defining variables when submitting a job.

.. Shortcut link
.. |flowchart_link| raw:: html

   <a href="https://zenodo.org/doi/10.5281/zenodo.5615808" target="_blank">Zenodo</a>

.. |job_link| raw:: html

   <a href="http://molssi10.molssi.org:55055/#/jobs/312" target="_blank">Job 312</a>
