.. _starting-seamm:

Starting the SEAMM GUI
======================
.. Attention::
   The docker images are large (~ 1 GB), and may take some time to download. The first
   time you run a part of SEAMM, it will take some time to start up, as the image is
   downloaded and unpacked. Subsequent starts will be faster both because the images are
   cached on disk and because the various images for SEAMM share a common base image.

MacOS
-----
If you are using MacOS you can install an application for the SEAMM
GUI. Download :download:`SEAMM.zip <./SEAMM.zip>` and unzip it in your personal
Applications folder -- the one inside your home directory. You can do this in Finder by
dragging the file to the Applications directory under your home folder. Then
double-click on SEAMM.zip to expand it, creating SEAMM.app. You can then double-click on
SEAMM.app to start the SEAMM GUI. You can also drag the SEAMM.app to your dock to make
it easier to start in the future.

.. Note::
   If you are using MacOS, you will need to install the `XQuartz`_ X server. You can
   download and install it from the `XQuartz`_ website. Once you have installed *XQuartz*,
   you will need to log out and log back in to your computer. You will also need to start
   *XQuartz* and go to the preferences. In the preferences, go to the "Security" tab and
   check the box that says "Allow connections from network clients". You will need to
   restart *XQuartz* after making this change.

   You will also need to allow applications to connect to the X server. You can do this
   by running the following command in an xterm window::

     xhost + 127.0.0.1

   You will need to do this each time you start *XQuartz*. If you want it to run
   automatically, add a line with *xhost + 127.0.0.1* to the file
   `~/.xinitrc.d/50-xhost.sh`. You may need to create both the directory and file.

.. Note:
   If you want to run SEAMM from a terminal window, you can make an alias to start the
   SEAMM GUI. Add the following line to your `~/.bashrc` file::

     seamm='~/Applications/SEAMM.app/Contents/MacOS/SEAMM'

   You can then start the SEAMM GUI by typing *seamm* in a terminal window. You can also
   add a flowchart file to open by adding the name of the file to the command line, but
   it must be in the current directory or below, and you must use a relative path.

Linux
-----
.. Warning:
   The SEAMM installation using Docker on Linux has not yet been thoroughly tested. If
   you run into problems, please contact us! It will help us to improve the installation
   and find out if there are differences between different versions of Linux.

   Also, you may need to run `xhost + local:` or `xhost + 127.0.0.1` to allow the SEAMM
   GUI to connect to the X server. You can add this to your `~/.bashrc` file to run it
   automatically each time you start a terminal window.
   
You can make these aliases in your shell to start the SEAMM GUI. Add the following line to
your `~/.bashrc` file::

  alias seamm-standalone='docker run --pull always -v /tmp/.X11-unix/:/root/.X11-unix/ --net=host --rm --name SEAMM --env "DISPLAY" -v ~/SEAMM:/root/SEAMM -v ~/.seamm.d:/root/.seamm.d ghcr.io/molssi-seamm/seamm:latest &'
  alias seamm='docker run --pull always -v /tmp/.X11-unix/:/root/.X11-unix/ --net=host --network seamm-netowrk --rm --name SEAMM --env "DISPLAY" -v ~/SEAMM:/root/SEAMM -v ~/.seamm.d:/root/.seamm.d ghcr.io/molssi-seamm/seamm:latest &'

You can then start the SEAMM GUI by typing *seamm-standalone* or *seamm* in a terminal
window. The standalone version can only connect to Dashboards on other machines. If you
are running the SEAMM Dashboard locally, using Docker, and want to access it, you will
need the second version, *seamm*.

Windows
-------
.. Warning:
   We have not tested the SEAMM installation using Docker on Windows. If you run into
   problems, please contact us!
   
You can make a shortcut to start the SEAMM GUI. Right-click on the desktop and select
"New" and then "Shortcut". In the dialog box that appears, enter the following command::

  C:\Windows\System32\wsl.exe -d docker-desktop -u root -- docker run --pull
  always --rm --name SEAMM --env "DISPLAY=host.docker.internal:0" --network  seamm-network -v ~/SEAMM:/root/SEAMM -v ~/.seamm.d:/root/.seamm.d ghcr.io/molssi-seamm/seamm:latest &

You can then double-click on the shortcut to start the SEAMM GUI.

.. Warning::
   We have not yet installed on SEAMM on Windows using Docker. We are working on this!
   Hopefully the above instruction will work, but we have not tested it yet.

.. _XQuartz: https://www.xquartz.org
