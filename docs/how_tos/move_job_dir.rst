.. _move_jobs_directory:

******************************
How-To Move the Jobs Directory
******************************

By default the datastore holds jobs in a directory tree rooted at ``~/SEAMM/Jobs``. This
is often perfectly fine, but if you find that you need to move the files to another
directory, follow this guide. There are a couple reasons that you might want to move the
jobs

#. The Jobs/ directory can become quite large. All the files for the jobs that you run
   end up under this top-level directory, so over time it grows and depending on what
   you run it can be quite large.

#. Often computer centers either limit the size of your home directory, or access to it
   from the nodes is slow due to the way that it is mounted. In this case, there is
   usually a large, fast disk volume that you should use, so you need to move the Jobs/
   directory there.

The obvious solution of moving ``~/SEAMM`` somewhere else and making a link to it in
your home directory does not work because of security issues. You can, however, move the
``~/SEAMM/Jobs`` directory and tell SEAMM where it is, and if you do that you can also
move ``~/SEAMM`` if you want. First let's see how to move the jobs directory.

Moving the Jobs Directory
-------------------------

Moving the Jobs directory to another location is straightforward. Just follow these
steps

#. Activate the ``seamm`` Conda environment::

     conda activate seamm
     
#. Make sure that you have no jobs running, and stop the DashBoard and JobServer::

     seamm-installer services stop

#. Make any parent directories that you need and copy or move the ~/SEAMM/Jobs directory
   to the new location::

     mv ~/SEAMM/Jobs <newpath>/

#. Edit ``~/SEAMM/seamm.ini`` and change the following lines in the ``[SEAMM]`` section::

     # The location of the datastore
     datastore = <newpath>/Jobs

#. Remove the database::

     rm <newpath>/Jobs/seamm.db

#. Test that the Dashboard runs properly from the command line::

     seamm-dashboard

   You should see quite lot of text scroll by. The end should look like this::

      <Rule '/admin/manage_user/<user_id>/delete' (GET, POST, HEAD, OPTIONS) -> admin.delete_user>,
      <Rule '/admin/manage_group/<group_id>/delete' (GET, POST, HEAD, OPTIONS) -> admin.delete_group>,
      <Rule '/static/bootstrap/<filename>' (GET, HEAD, OPTIONS) -> bootstrap.static>])
      waitress:INFO:Serving on http://0.0.0.0:55055

   Once you see the ``waitress`` line, try accessing the Dashboard through your
   browser. If you are on the same machine, it is at `http://localhost:55055
   <http://localhost:55055>`_.

#. If everything looks OK, kill the Dashboard ``(<ctrl-C>)`` and then restart the
   services::

     seamm-installer services start

   Check that you can access the Dashboard in your browser.

That is it!

Moving the entire ~/SEAMM directory
-----------------------------------

Above we said that it was not wise to move the ~/SEAMM directory. However, if you need
to, there is a trick that works: use a soft-link *AND* redirect the Dashboard just as in
the last section.

#. Move ``~/SEAMM`` to the new location, and then make a link to it. (Stop the services
   first!!!)::

     mv ~/SEAMM <newpath>/
     ln -s <newpath>/SEAMM ~/

#. Now follow the steps 4 on above. Wherever it says ``<newpath>`` use
   ``<newpath>/SEAMM``.

Why do you also have to tell SEAMM where the datastore is, even if it still appears to
be in ``~/SEAMM/Jobs``? Because the Web server in the Dashboard will not access files
outside the ``Jobs/projects`` directory because of security issues. If you don't tell it
where to look for the datastore it will look in ``~/SEAMM/Jobs``, which it will find,
but it will think the directory is ``<newpath>/SEAMM/Jobs``. It will think it is outside
the allowed path and prevent you from deleting jobs, submitting jobs, or do anything
else that changes files. Not what you want! So you have to tell it the true path to the
``Jobs/`` directory. Then it will be happy!



   
