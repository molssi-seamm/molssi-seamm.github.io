**********************************************************************
SEAMM: the Simulation Environment for Atomistic and Molecular Modeling
**********************************************************************

.. attention::
   We are delighted to announce that SEAMM is ready for deployment to the public domain
   and beta testing by the members of the computational molecular sciences community. 
   Although we have made every efforts to make SEAMM a user-friendly environment for 
   scientific discovery, similar to any open-source software project it its early days,
   it is prone to bugs and glitches inadvertently made by its developers. A such, we 
   have to rely on user support to become aware of these problems.
   
   We also plan to provide a forum for reporting problems, promoting constructive 
   discussions and sharing ideas and experiences. In the meantime, feel free to email
   us at seamm@molssi.org or join the Slack channel |slack|.

   Similar to any other open-source project, you can also contribute to its growth by
   opening issues, forking the repository and submitting pull requests in order to make
   changes in the code or documentation.

   SEAMM is a large-scale and ambitious project with many moving parts. Thus, it will 
   take some time to become truly stable! We appreciate your patience and assistance!

SEAMM is a user-friendly software package for the atomistic simulations of organic 
molecules, biological systems, fluids, synthetic polymers, and materials such as metals
and metal oxides, semiconductors, ceramics and alloys. If you are performing any of 
these types of simulations, SEAMM can provides an ideal environment for discovery allowing
you to focus on the science itself insead of getting bugged down on irrelevant 
technicalities of the software.

:ref:`Installation`
   SEAMM offers convenient ways for its installation on Linux or Mac systems. We are
   doing our best to provide support for Windows. In addition to SEAMM itself, the 
   installer allows other simulation engines such as LAMMPS, DFTB+, Psi4, and Packmol
   to be installed effortlessly.

:ref:`User Experience<ease-of-use>`
   Have you ever looked at a code that you wanted to use, but when you read the
   documentation said to yourself "Wow, this is complicated ... a zillion keywords and
   they don't make sense. This is too much!"? SEAMM has graphical user interfaces (GUIs)
   for all the codes, so you don't have to learn their keywords and languages, nor do
   you start with an empty screen wondering how to start. The GUI puts it all in front
   of you, with reasonable defaults for most parameters. Even if you don't know much
   about a code, SEAMM will have you started and getting reasonable results quickly.
   As you learn more about the code you can customize your calculation more, but getting
   started is the hard part.

:ref:`Reproducibility<reproducibility>`
   In SEAMM you use flowcharts, which are a high-level, intuitive way of describing what
   you want to do.  No more scripting in a shell or Python. These flowcharts are
   reproducible, meaning you can run them again and do the same thing over. While such
   reproducibility is critical, being able to change what you do a little bit is even
   more useful. Say you want to do the same calculation on a different molecule or
   materials. Or change a few parameters, like the pressure or temperature of the
   simulation. Flowcharts make this easy and safe.

Build on the work of others
   Because flowcharts are simple text files, and are reproducible, you can send them to
   coworkers and share them. Which means that you can get flowcharts from experts in
   areas that you don't know so much about, and use them to get started. If they do what
   you need, wonderful! If not, at least you have a good place to start. SEAMM lets you
   publish workflows to Zenodo and get a DOI. You can also search Zenodo from SEAMM to
   find just the right flowchart.

Track all of your work
   SEAMM includes a datastore for all your calculations, and a web-based dashboard for
   looking at results. The datastore is organized by projects and provides access
   control so you can say who can see your work and who can add to it. And who can't.

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
    users/ease-of-use
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

.. _Installation: html/users/installation/index
