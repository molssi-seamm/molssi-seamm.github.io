.. _tutorial-2:

**************************
Working with the Dashboard
**************************
.. note::
    The present tutorial assumes you have read and followed the instructions
    laid out in :ref:`tutorial-1` so that there is at least one job to work with.

By default, users can access the Dashboard in their web browsers at http://127.0.0.1:55055:

.. figure:: /images/tutorial_2/initial_dashboard.png
   :align: center
   :alt: The Dashboard in a browser window

   *The Dashboard when you first access it*

The left pane is a menu of various sections available in the Dashboard. The left arrow at
the bottom-right part of this pane collapses the menu into icons adding more space for
the right pane which may be useful in various situations e.g., when looking at the simulation
outputs. The right pane presents a summary of the executed jobs, flowcharts and projects
that the current user has the permission to view. On the first access to the Dashboard web-page,
it shows everything with the public permission to anyone without logging in.

Let us begin by clicking on the ``Public User`` menu drop-down button at the upper-right
corner of the section and select ``Login``.

.. note::
    When entering the username and password, remember that by default, the initial
    passwords for the **admin** and **user** accounts are set to **admin** and 
    **default**, respectively.

Once you are logged in, the front page of the Dashboard should change slightly and look like
the following: 

.. figure:: /images/tutorial_2/logged_in.png
   :align: center
   :alt: The Dashboard after logging in

   *The Dashboard after logging in*

Note the summary of information regarding the executed jobs in the main colored card
sections: two jobs, one flowchart, and one project. One can use either the menu at the
top of each panel or the items from the left-pane menu in order to inspect each job,
flowchart, or project. Next, click on the ``Jobs List`` item on from the left-pane menu:

.. figure:: /images/tutorial_2/job_list.png
   :align: center
   :alt: The Dashboard showing the Jobs List

   *The list of jobs in the Dashboard*

After starting the Dashboard, one can find the previously executed job(s) in the list.
For the illustration presented above, we ran this job twice while testing. So, there
are two copies in this figure. Note that the title that the user chooses for each job
is also listed. It is important to use relevant meaningful but brief titles.

.. Tip::
    It is a good practice to keep the title lengths down to 50-80 characters.

Click on the job ID to expand its results:

.. figure:: /images/tutorial_2/job_page.png
   :align: center
   :alt: The Dashboard showing the main page for a job

   *The main page of a job*

Once again, the job title appears at the top of the left-pane on the screen followed by
further details about the job. Below, we demonstrate a listing of the files from our job.
The job description can be found at the top of the right-pane, below which there is a large
empty space that will be used to display the file details pertinent to each job when one clicks
on them in the left-side directory section. Note that we collapsed the main menu at the very 
left to create more space. 

Now, click on the ``final_structure.mmcif`` file in the directory section, we get:

.. figure:: /images/tutorial_2/structure_display.png
   :align: center
   :alt: The Dashboard displaying a structure from a job

   *Displaying the final structure*

One can rotate the molecule using the mouse, change its representation through the menu at
the top of the screen, or export a screenshot of the current view of the molecule.

Navigate to the ``job.out`` file by clicking on it:

.. figure:: /images/tutorial_2/job_out.png
   :align: center
   :alt: The main job output in a browser window

   *The main output of the job*

This is the main output for our executed job which summarizes its results accompanied by
a list of citations at the end. Let us spend some time understanding the information
being presented. The first section is always a summary of the job workflow and the
steps involved::

  Description of the flowchart
  ----------------------------
  Step 0: Start  2021.6.2

  Step 1: from SMILES  2021.6.3
      Create the structure from the SMILES 'CCS'

  Step 2: DFTB+  2021.6.5

     Step 2.1: Choose Parameters
         Using the '3ob' set of Slater-Koster parameters.

     Step 2.2: Optimization
         Structural optimization using the Direct inversion of iterative subspace
         (gDIIS) method with a convergence criterion of 0.0 hartree/bohr. A maximum
         of 200 will be used.

This summary is printed before the job actually starts. So, even if the job takes
a long time you can review what steps are going to be/being executed. This is a useful
feature because it allows the users to correct their mistakes as soon as they find them
by killing the process and re-running it after fixing the problem. The summary provides
the key parameters pertinent to the calculations. It is important to note that the version
of each adopted plug-in for executing the flowchart is also given to ensure reproducibility
and security in cases where non-trivial bugs and glitches are found in a particular version.

The second section of the output summarizes the results from the executed flowchart::

  Running the flowchart
  ---------------------
  Step 0: Start  2021.6.8

  Step 1: from SMILES  2021.6.3
      Create the structure from the SMILES 'CCS'
      Created a molecular structure with 9 atoms.

      Step 2.1: Choose Parameters
          Using the '3ob' set of Slater-Koster parameters.

      Step 2.2: Optimization
          Structural optimization using the Direct inversion of iterative subspace
          (gDIIS) method with a convergence criterion of 0.0001 E_h/a_0. A maximum of
          200 will be used.

      Step 2.1: Choose Parameters
          Using the '3ob' set of Slater-Koster parameters.

   
      Step 2.2: Optimization
          Structural optimization using the Direct inversion of iterative subspace
          (gDIIS) method with a convergence criterion of 0.0001 E_h/a_0. A maximum of
          200 will be used.

   
          The geometry optimization converged in 25 steps to a total energy of
          -8.115704 Ha.

  Wrote the final structure to 'final_structure.mmcif' for viewing.
    
Note the similarity of this section to the first part of the output. However, a closer
look elicits more details about each step such as those pertinent to ``FromSMILES`` step
which in our case, reports the number of atoms in the chemical structure being studied
and the ``DFTB+ Optimization``, the total electronic energy and number of iterations.

The final section of the output provides references that must be cited regarding the
calculations performed::

  Primary references:
    
  (1) Jessica Nash, Eliseo Marin-Rimoldi, Paul Saxe. SEAMM: Simulation Environment
      for Atomistic and Molecular Modeling, version 2021.6.8; The Molecular
      Sciences Software Institute (MolSSI): Virginia Tech, Blacksburg, VA, USA,
      https://github.com/molssi-seamm/seamm

  (2) Hourahine, B.; Aradi, B.; Blum, V.; Bonafé, F.; Buccheri, A.; Camacho, C.;
      Cevallos, C.; Deshaye, M. Y.; Dumitrică, T.; Dominguez, A.; Ehlert, S.;
      Elstner, M.; van der Heide, T.; Hermann, J.; Irle, S.; Kranz, J. J.; Köhler,
      C.; Kowalczyk, T.; Kubař, T.; Lee, I. S.; Lutsker, V.; Maurer, R. J.; Min,
      S. K.; Mitchell, I.; Negre, C.; Niehaus, T. A.; Niklasson, A. M. N.; Page,
      A. J.; Pecchia, A.; Penazzi, G.; Persson, M. P.; Řezáč, J.; Sánchez, C. G.;
      Sternberg, M.; Stöhr, M.; Stuckenberg, F.; Tkatchenko, A.; Yu, V. W.-z.;
      Frauenheim, T. DFTB+, a software package for efficient approximate density
      functional theory based atomistic simulations. The Journal of Chemical
      Physics 2020, 152, 124101. DOI: 10.1063/1.5143190

  (3) Gaus, Michael; Lu, Xiya; Elstner, Marcus; Cui, Qiang. Parameterization of
      DFTB3/3OB for Sulfur and Phosphorus for Chemical and Biological
      Applications. Journal of Chemical Theory and Computation 2014, 10,
      1518-1537. DOI: 10.1021/ct401002w

  (4) Gaus, Michael; Goez, Albrecht; Elstner, Marcus. Parametrization and
      Benchmark of DFTB3 for Organic Molecules. Journal of Chemical Theory and
      Computation 2013, 9, 338-354. DOI: 10.1021/ct300849w

  Secondary references:

  (1) Paul Saxe. DFTB+ plug-in for SEAMM, version 2021.6.5; The Molecular Sciences
      Software Institute (MolSSI): Virginia Tech, Blacksburg, VA, USA,
      https://github.com/molssi-seamm/dftbplus_step

  Process time: 0:00:01.408026 (1.408 s)
  Elapsed time: 0:00:02.932646 (2.933 s)

The references are often divided based on their importance and usage frequency in the
code. For more complicated flowcharts, the number of references can be very large. Thus,
SEAMM tries to help users decide which ones are the most important references for their
research.

The references are also stored in a small database file, ``references.db``. Future
versions of SEAMM will provide tools to merge the references from every executed jobs
in a particular project. This will assist users to properly cite the tools that they have
employed to carry out their study.

By clicking on the folder corresponding to the second step of the flowchart (labeled **2**),
during which SEAMM performed a DFTB+ geometry optimization, we get:

.. figure:: /images/tutorial_2/dftbplus_files.png
   :align: center
   :alt: The files for the DFTB+ step

   *The files for the DFTB+ step*

The main output for DFTB+ is stored in the ``stdout.txt`` file which has been selected
for generating the picture shown above. The left panel is the directory section with all
files pertinent to this step, including the input and output files from DFTB+. One can inspect
these files to check the input file(s) generated by the plug-in, as well as the outputs.

Look at ``dftb_in.hsd``, one can see the raw input for the DFTB+ package. It should be
clear now how convenient it was to use the GUI to create an input file instead of manual
scripting.

Before wrapping up this tutorial, note that the Dashboard will display files in different
ways depending on their content and origin. Text files are displayed as text, molecules 
are represented as three-dimensional structures, tabular data are stored as sortable tables
and graphs are demonstrated as graphs.
