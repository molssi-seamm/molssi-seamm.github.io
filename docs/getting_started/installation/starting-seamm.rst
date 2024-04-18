.. _starting-seamm:

Starting the SEAMM GUI
======================
Once you have *Docker* installed, you can start the SEAMM GUI by running the following
command in a terminal window::

  docker run --pull always --rm --name SEAMM  -e "DISPLAY=host.docker.internal:0" -v ~/SEAMM:/root/SEAMM ghcr.io/molssi-seamm/seamm:latest &

MacOS
-----
If you are using MacOS you can install an application for the SEAMM
GUI. Download :download:`SEAMM.zip <./SEAMM.zip>` and unzip it in your personal
Applications folder -- the one insde your home directory. You can do this in Finder by
dragging the file to the Applications directory under your home folder. Then
double-click on SEAMM.zip to expand it, creating SEAMM.app. You can then double-click on
SEAMM.app to start the SEAMM GUI. You can also drag the SEAMM.app to your dock to make
it easier to start in the future.

.. Note:
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
   `~/.xinitrc.d/50-xhost.sh`. You may need to create the directory and file.

Linux
-----
You can make an alias in your shell to start the SEAMM GUI. Add the following line to
your `~/.bashrc` file::

  alias SEAMM='docker run --pull always --rm --name SEAMM  -e "DISPLAY=host.docker.internal:0" -v ~/SEAMM:/root/SEAMM ghcr.io/molssi-seamm/seamm:latest &'

You can then start the SEAMM GUI by typing *SEAMM* in a terminal window.

Windows
-------
You can make a shortcut to start the SEAMM GUI. Right-click on the desktop and select
"New" and then "Shortcut". In the dialog box that appears, enter the following command::

  C:\Windows\System32\wsl.exe -d docker-desktop -u root -- docker run --pull always --rm --name SEAMM  -e "DISPLAY=host.docker.internal:0" -v ~/SEAMM:/root/SEAMM ghcr.io/molssi-seamm/seamm:latest &

You can then double-click on the shortcut to start the SEAMM GUI.

.. Note:
   We have not yet installed on SEAMM on Windows using Docker. We are working on this!
   Hopefully the above instruction will work, but we have not tested it yet.

.. _XQuartz: https://www.xquartz.org
