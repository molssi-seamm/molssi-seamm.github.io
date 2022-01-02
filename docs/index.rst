**********************************************************************
SEAMM: the Simulation Environment for Atomistic and Molecular Modeling
**********************************************************************

SEAMM is an easy-to-use environment for simulations of organic molecules, biological
molecules, fluids, synthetic polymers, and materials -- oxides, ceramics, semiconductors,
metals, and alloys -- described at the atomic level. Why should you use SEAMM? Because
if you are doing these types of simulations, or want to get started with them, SEAMM
let's you focus on your science or engineering, not on how to run code X, and get more
done. Faster. SEAMM helps you from beginning to end:

:ref:`Installation`
   SEAMM is easy to install on your Linux or Mac system, and we are working on
   Windows. It installs everything that you need, not only SEAMM itself, but the
   simulation codes such as LAMMPS, DFTB+, Psi4, and Packmol.

:ref:`Ease-of-Use<ease-of-use>`
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

    status/index
    users/installation/index
    users/ease-of-use
    users/reproducibility
    users/index
    developers/index
    plug-ins/index
    https://github.com/molssi-seamm
    statistics/index
    glossary
    acknowledgements

.. _Shareable and reproducible flowcharts: html/users/seamm_description/flowchart.html
.. _MolSSI SEAMM project: https://github.com/molssi-seamm
.. |slack| image:: https://img.shields.io/badge/chat-on_slack-808493.svg?longCache=true&style=flat&logo=slack)
   :target: https://join.slack.com/t/seamm/shared_invite/zt-gd85l7k4-~r9xCoRSCfFHrAHnG7duFA
   :alt: SEAMM Slack Channel

.. _Installation: html/users/installation/index
