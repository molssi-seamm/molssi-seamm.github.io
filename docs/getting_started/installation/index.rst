.. _installation:

****************
Installing SEAMM
****************

SEAMM has three parts:

  * The SEAMM core environment along with any plug-ins needed;

  * The SEAMM GUI for creating flowcharts, submitting jobs, publishing results etc., and

  * The Web-based Dashboard responsible for monitoring jobs, managing the
    job directories and presenting the results.

The SEAMM GUI and the Dashboard both require the SEAMM core environment. You can
install everything on one machine, in which case you can do everything with SEAMM on
that machine. Alternatively you can install the SEAMM GUI on one machine -- probably
your personal machine -- and the Dashboard on a server, where your jobs will run. This
is the recommended setup for a group of users, as it allows everyone to submit jobs to
the same server, and to monitor the progress of all jobs. The easiest way to get started
is to install eveything on your personal machine so that you can test and run small jobs
locally. Later, you can install the Dashboard on any servers you have available and use
the GUI on your personal computer to submit production jobs to the servers.

SEAMM can be installed and run using either the *Conda* package manager or
*Docker*. Conda provides separate environments for Python, which SEAMM uses to keep
different components separate so they don't conflict with each other. If you are already
using Python, using Conda may fit well with your currrent setup. SEAMM has an installer
that can run either with a GUI or from the command line. This installer makes it
straightforward to install and maintain SEAMM using Conda. 

The *Docker* installation is even simpler. Once you have installed *Docker Desktop*, a
couple simple commands will download and run the containers for SEAMM. Each container is
quite literally self-contained, with an operating system and all the software needed
already installed. This means you can run SEAMM on any machine that has *Docker*, and also
gives complete reproducibility since older containers are kept and can be run at any
time. The *Docker* installation is recommended for users who are not already using Python. 

The following sections will walk you through either installation. Note that you can
install parts or all of SEAMM on different machines in different ways. For example, you
can install the GUI on your personal machine using *Docker* and the dashboard on a
server using *Conda*. The choice is yours.

.. Note::
   When you install the Dashboard, you need to set the initial passwords on the default
   accounts. :ref:`dashboard-management` will walk you through this.
   

.. Table of contents
.. toctree::
    :maxdepth: 5
    :titlesonly:
    :hidden:

    docker
    conda
    dashboard_management

