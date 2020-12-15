**************
What is SEAMM?
**************

The Simulation Environment for Atomistic and Molecular Modeling --
SEAMM -- is a user-friendly environment for computational molecular
and materials science. SEAMM handles the entire range of atomic,
molecular, crystalline, amorphous, and fluid systems that are
described at the level of atoms and electrons.

SEAMM is composed of :term:`plug-ins<plug-in>` that wrap popular
software packages and tools.  As a result, users can create simulation
protocols that include any combination of the following:

1. **Quantum Chemistry (QC) calculations**

 - *Ab-initio* and molecular Density Functional Theory (DFT) (in progress)
 - Semi-empirical using MOPAC
 - Periodic DFT using Quantum Espresso or VASP (in progress)

2. **Atomistic Molecular Mechanics (MM) simulations**

 - Molecular Dynamics (MD)
 - Monte Carlo (MC) (in progress)

3. **Helper tools**

 - System builders and atom typers for MM simulations
 - Simulation analysis tools
 - Cheminformatics capabilities using RDKit and OpenBabel

Features
--------

1. `Shareable and reproducible flowcharts`_ that visually represent
   simulation protocols.
2. A :ref:`graphical user interface` (GUI) to help you edit flowcharts
   and simulation input files.
3. A :ref:`Dashboard` for monitoring your jobs.
4. A :ref:`Job Manager` to automatically execute flowcharts in
   laptops, university clusters, supercomputers or in the cloud.
5. A :ref:`Job Datastore` to help you manage the many calculations you
   do throughout the year.
6. A plug-in architecture that makes it straightforward for developers
   to implement and incorporate their codes and scripts into SEAMM.

Getting Started
---------------

If you would like to use SEAMM, please read the :ref:`users_docs`.

If you are a developer and would like to incorporate your tool into
SEAMM, please read the :ref:`developers_docs`.

The source is at GitHub in the `MolSSI SEAMM project`_

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

    html/status
    html/users/index
    html/developers/index
    https://github.com/molssi-seamm
    html/glossary
    acknowledgements

.. _Shareable and reproducible flowcharts: html/users/seamm_description/flowchart.html
.. _MolSSI SEAMM project: https://github.com/molssi-seamm
.. |slack| image:: https://img.shields.io/badge/chat-on_slack-808493.svg?longCache=true&style=flat&logo=slack)
   :target: https://join.slack.com/t/seamm/shared_invite/zt-gd85l7k4-~r9xCoRSCfFHrAHnG7duFA
   :alt: SEAMM Slack Channel
