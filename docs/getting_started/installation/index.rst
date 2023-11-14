.. _installation:

****************
Installing SEAMM
****************

.. attention::
   Although in principle, SEAMM can be installed on Windows, several key 
   third-party dependencies are not supported under Windows. However,
   the *Windows Subsystem for Linux (WSL)* supports SEAMM and its dependencies. 
   The installation is identical to that on any Linux system. *Windows 11* provides full
   support for the SEAMM including the graphical user interface.Unfortunately, *Windows
   10* and WSL do not support graphical programs so you cannot currently fully install
   and use SEAMM on *Windows 10*. We are working to support *Windows 10*, but if you can
   upgrade to *Windows 11* SEAMM will work immediately.

The installation process in SEAMM involves two main parts:

  * SEAMM core environment consisting of the GUI for creating flowcharts,
    submitting jobs, publishing results etc., and

  * Web-based dashboard responsible for monitoring jobs, managing the
    job directories and analyzing the results.

Both parts rely on having *conda* installed on the host system. Installers 
for `Miniconda`_ or `Anaconda`_ can be found in their hosting websites. The difference
between them is that `Anaconda`_ has not only the core packages of *conda* but a large
number of tools for data science built in. `Miniconda`_ is just the core of *conda*, and
hence is smaller an quicker to install. `Miniconda`_ provides everything needed for
SEAMM, so unless you intend to use *conda* for other data science tasks, just install
`Miniconda`_.

.. note::
   A `video of installing conda <https://www.youtube.com/watch?v=FGDpdAiBPrA>`_ is
   available on the `SEAMM YouTube channel`_.

After installing *conda* you can install the rest of SEAMM using either the
:ref:`graphical installation` or :ref:`command line installation`.

If you installed the Dashboard, you need to set the initial passwords on the default
accounts. :ref:`dashboard-management` will walk you through this.

.. Table of contents
.. toctree::
    :maxdepth: 5
    :titlesonly:
    :hidden:

    graphical.rst
    command-line.rst
    dashboard_management
    
.. Link shortcuts and cross-referencing labels
.. _Miniconda: https://docs.conda.io/en/latest/miniconda.html
.. _Anaconda: https://www.anaconda.com/distribution
.. _SEAMM YouTube channel: https://www.youtube.com/channel/UCF_5Kr_AN90CYb0fTgYQHzQ
