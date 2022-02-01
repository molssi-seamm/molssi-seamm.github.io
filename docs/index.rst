.. _seamm-main:

**********************************************************************
SEAMM: the Simulation Environment for Atomistic and Molecular Modeling
**********************************************************************

.. attention::
   We are delighted to announce that SEAMM is ready for deployment to the public domain
   and beta testing by the members of the computational molecular sciences community. 
   Although we have made every efforts to minimize errors and glitches in the SEAMM 
   software infrastructure, similar to any open-source software project it its early days,
   it is prone to bugs and glitches. A such, we 
   have to rely on user support to become aware of these problems.
   
   We also plan to provide a forum for reporting problems, promoting constructive 
   discussions and sharing ideas and experiences. In the meantime, feel free to email
   us at seamm@molssi.org or join the Slack channel |slack|.

   SEAMM is fully open-source allowing anyone to contribute to its growth by
   opening issues, forking the repository and submitting pull requests in order to make
   changes in the code or documentation. SEAMM is also a large-scale and ambitious project
   with many moving parts. Thus, it will take some time to become truly stable! We 
   appreciate your patience and assistance throughout the development process!

SEAMM is a user-friendly software package for the atomistic simulations of organic 
molecules, biological systems, fluids, synthetic polymers, and materials such as metals
and metal oxides, semiconductors, ceramics and alloys. If you are performing any of 
these types of simulations, SEAMM can provides an ideal environment for discovery allowing
you to focus on the science itself instead of getting bugged down on irrelevant 
technicalities of the software.

:ref:`installation`
   SEAMM and other simulation engines such as LAMMPS, DFTB+, Psi4, and Packmol can be 
   conveniently installed on Linux or Mac systems. We are doing our best to provide 
   support for Windows platform.

:ref:`user-experience`
   In addition to its robust command-line interface (CLI), SEAMM provides a graphical 
   user interface (GUI) that exposes its full power and functionality to the users
   in a user-friendly environment. As such, the GUI is focused on minimizing the need 
   to learn verbose or complicated keywords and languages. Furthermore, the GUI puts 
   chooses reasonable defaults for most parameters used in the available simulation tools.
   In this way, even if you don't know much about programming, SEAMM will have you back to
   quickly get started with your simulation while expecting reasonable results. As you 
   learn more about the details of each model and the corresponding tools, you can further
   customize your calculations for more accurate outcomes.

:ref:`reproducibility`
   Flowcharts are one of the most basic but fundamental concepts in SEAMM offering a
   high-level and intuitive delineation of the entire workflow. Flowcharts remove the 
   need for manual scripting in a shell or Python while making the entire process reproducible. 
   In other words, one can run all steps involved in a complex workflow exactly the same was as
   it was originally intended and perform all calculations over. While flowcharts are critical
   for enforcing reproducibility, they are flexible objects allowing the user to perform necessary
   tweaks of changes to the workflow. For example, the same set of calculations within a flowchart
   can be performed on a variety of molecules and materials without any changes necessary.
   In other scenarios, changing parameters can be easily accommodated within an already existing
   flowchart, like fine-tuning the pressure or temperature variables in a simulation. Flowcharts 
   make all these changes convenient and reproducible.

Share your work
   Because flowcharts are simple text files, the can be easily shared with coworkers and 
   collaborators. This means that you can get flowcharts from experts in the areas that
   are outside your area of expertise and use them as a starting point for your studies.
   SEAMM makes workflows publishable and therefore, readily accessible and searchable 
   on Zenono based on unique DOIs. As a cherry on top of the cake, SEAMM allows searching 
   for flowcharts on Zenodo with convenient ways to find and import them within your workflows.

Track your work
   SEAMM provides a datastore as well as a web-based dashboard for storing, monitoring,
   and managing the calculation results. The datastore organizes each project in its isolated
   directory on disk and provides a well structured tree that can be monitored and managed effortlessly
   using the dashboard.

Do you need a data management plan?
   Most granting agencies now require a data management plan and require you to publish
   your data. SEAMM will shortly have that covered! You will be able to use the
   dashboard to publish the computational campaign for a project or paper. And we are
   working on bundling up all the files and publishing to Zenodo and getting a DOI, just
   as we already do for flowcharts. Of course, you don't have to publish your
   results. But even if you are doing proprietary work it is still a good idea to use
   these tools to make a local copy just in case.

Citations and references
   Speaking of writing up you results, SEAMM helps you gather the right citations for
   the codes and parameter sets you used in your computational campaign. Each job
   creates a list of the appropriate citations for what you just did, and saves it in a
   small database. And we are working on tools to merge the citations for a campaign.

To learn more, look at the :ref:`installation` and the :ref:`users_docs`. If you are a
developer and would like to incorporate your tool into SEAMM, please read the
:ref:`developers_docs`. 

You can also join our Slack channel by clicking here: |slack|

Documentation Versions
======================

.. raw:: html

   <iframe
   src="https://molssi-seamm.github.io/dev/versions.html"
   title="Documentation Versions"  style="border:none;">
   </iframe>

.. toctree::
    :maxdepth: 5
    :titlesonly:
    :hidden:

    users/installation/index
    users/user_experience
    users/reproducibility
    users/index
    developers/index
    plug-ins/index
    SEAMM YouTube Channel <https://www.youtube.com/channel/UCF_5Kr_AN90CYb0fTgYQHzQ>
    https://github.com/molssi-seamm
    status/index
    statistics/index
    acknowledgements
    glossary

.. _Shareable and reproducible flowcharts: html/users/seamm_description/flowchart.html
.. _MolSSI SEAMM project: https://github.com/molssi-seamm
.. |slack| image:: https://img.shields.io/badge/chat-on_slack-808493.svg?longCache=true&style=flat&logo=slack)
   :target: https://join.slack.com/t/seamm/shared_invite/zt-gd85l7k4-~r9xCoRSCfFHrAHnG7duFA
   :alt: SEAMM Slack Channel
