.. _seamm-main:

**********************************************************************
SEAMM: the Simulation Environment for Atomistic and Molecular Modeling
**********************************************************************

.. attention::
   Currently, SEAMM is in the early stages of its deployment to the public domain
   and beta testing by the members of the computational molecular sciences community.
   Although we have made every efforts to minimize errors and glitches in the SEAMM
   software infrastructure, similar to any open-source software project it its early days,
   it is prone to undetected bugs. A such, we have to rely on user support to become
   aware of these problems.
   
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
   support for the Windows platform.

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

:ref:`workflow-features`
   Flowcharts are a foundational concept in SEAMM offering a high-level and intuitive 
   delineation of the entire workflow. Flowcharts remove the need for shell or python scripting
   while making the entire process reproducible. In other words, one can run all steps involved
   in a complex workflow exactly the same as it was originally intended and perform the exact 
   same calculations all over again. While flowcharts are critical for enforcing reproducibility,
   they are flexible objects allowing users to perform necessary tweaks and changes to the workflow.
   For example, the same set of calculations within a flowchart can be performed on a variety of 
   molecules and materials without any further changes. In a different scenario, changing parameters
   can be easily accommodated within an already existing flowchart such as fine-tuning the pressure 
   or temperature variables in a simulation. Flowcharts make all these changes convenient and 
   reproducible.

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

Manage your data
   Most granting agencies require a data management plan for the dissemination of scientific
   data. With SEAMM, the users will be able to publish their computational campaigns via
   dashboard for a project or manuscript. We are also working on reducing the task of
   publishing the results on Zenodo and generating a unique DOI down to pressing a few
   buttons in the GUI.

Manage your citations
   SEAMM helps you gather the right citations for the codes and parameter sets you used
   in your computational campaign. Each job creates a list of the appropriate citations
   for the current task and stores it in a database. We are developing tools to allow
   merging multiple citations for a single computational campaign.

For further details about SEAMM, refer to the :ref:`installation` and the :ref:`users-docs`.
Developers interested in incorporating their tools and plugins in SEAMM are welcome to read
the :ref:`developers-docs`.

Users can also join our Slack channel by clicking on this badge |slack|

Documentation Versions
======================

.. Generate links to various versions of the documentation
   via iframe
.. raw:: html

   <iframe
   src="https://molssi-seamm.github.io/dev/versions.html"
   title="Documentation Versions"  style="border:none;">
   </iframe>

.. Table of contents
.. toctree::
    :maxdepth: 5
    :titlesonly:
    :hidden:

    why_seamm/index
    users/software_ecosystem
    users/installation/index
    users/tutorials/index
    users/index
    plug-ins/index
    developers/index
    SEAMM YouTube Channel <https://www.youtube.com/channel/UCF_5Kr_AN90CYb0fTgYQHzQ>
    https://github.com/molssi-seamm
    status/index
    statistics/index
    acknowledgements
    glossary

.. Badge(s)
.. |slack| image:: https://img.shields.io/badge/chat-on_slack-808493.svg?longCache=true&style=flat&logo=slack)
   :target: https://join.slack.com/t/seamm/shared_invite/zt-gd85l7k4-~r9xCoRSCfFHrAHnG7duFA
   :alt: SEAMM Slack Channel
