.. _docker:

*****************************
Installing SEAMM using Docker
*****************************

.. Note:
   The way that *Docker* runs on your machine has security implications. Containers
   effectively run with administrative privileges on your machine. This means that a
   malicious user could potentially use a container to access your files or other
   resources on your machine.

   If you are using e.g. personal laptop, this is not a big deal if you are the only
   person to use the machine, or at least trust others using it. Your machine should be
   locked down from outside access, so no one can get to *Docker* on it ... or if they
   can they have already hacked your machine. However, if you are using a shared
   machine, or a machine that is accessible from the internet, you should be more
   careful. If your computer is owned by a company or your University, you should check
   with your IT department to see if they have any policies about running *Docker* on
   your machine.
   
If *Docker* is not already installed on your system, you can download and install it
from the `Docker Desktop`_ website. The website should recognize the type of computer
you are using and provide the appropriate download link; however, you can also select a
different platform if you wish. Please follow the `Docker installation`_ instructions
for your platform.

.. Note:
   *Docker* is available for free for most users. However, if you are using it in a
   commercial setting and are at a larger company, you may need to purchase a
   license. Please check the *Docker* website for details and also check with your IT
   department.

The next steps show you how to start the SEAMM GUI using *Docker*, and how to install
and start the Dashboard and Jobserver.
   
.. Table of contents
.. toctree::
    :maxdepth: 5
    :titlesonly:
    :hidden:

    starting-seamm
    seamm-environment

.. _Docker Desktop: https://www.docker.com/products/docker-desktop
.. _Docker installation: https://docs.docker.com/get-docker/
