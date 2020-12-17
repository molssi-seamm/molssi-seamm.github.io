**************************
Updating with Cookiecutter
**************************
If you are managing several -- or more! -- plug-ins or other projects
that have been created using a Cookiecutter_, and you need to change
them all in a similar way, Cookiecutter may be the way to do it
easily. Or at least with fewer errors.

An example might be switching you continuous integration (CI) to a
different provider, or otherwise systematically changing it. This is
the example that we encountered here at the MolSSI in late 2020. We
had been using TravisCI and ReadTheDocs for CI and code documentation,
but TravisCI started charging for builds on MacOS. So we decided to
switch to GitHub Actions and consolidate the documentation on GitHib
Pages.

Since the core of SEAMM is seven repositories, and at the time we had
about seventeen plug-ins, it would be a large amount of tedious work
to switch everything manually, and it would also be error
prone. Tedious work tends to breed errors! So we decided to see if
Cookiecutter could help us out. After all, the plug-ins were all
created with the `Cookiecutter for SEAMM plug-ins`_. How hard could it
be?

It's pretty easy! Here's how:

Create the Template
-------------------
#. Create a directory and populate it as needed. The main directory
   can have any name, but for this example we will use
   ``update/``. This directory must contain a file
   ``cookiecutter.json`` and a directory of the looks like this:
   ``{{cookiecutter.repo_name}}/``. It must have the pairs of braces
   and a variable like ``cookiecutter.repo_name``.

   You should look at the original Cookiecutter that you used and use
   it as a guide for both the JSON file and subdirectory.

#. ``cookiecutter.json`` should look something like this::
   
      {
	  "step": "Name of your code or step, e.g. MOPAC or Polymer Builder",
	  "repo_name": "{{ cookiecutter.step.lower().replace(' ', '_').replace('-', '_') }}_step"
      }

   You'll need to figure out exactly what you need in this file by
   what you need to replace in template files ... which we will get in
   a bit. You'll certainly need the variable that gives the directory
   name, in our case ``repo_name``.

#. ``{{cookiecutter.repo_name}}/`` is where the files that you want to
   copy to the target directory, possibly with substitutions. If ``{{
   xxxx }}`` appears anywhere in a file, or in a filename, and
   ``xxxx`` is a variable name defined in ``cookiecutter.json``, if
   will be replaced by the value of the variable.

   The entire tree under this directory will be copied to the target,
   and transformed as it goes. In our example, there is a file
   ``docs/index.rst`` that looks like this::

      Welcome to the documentation for the {{ cookiecutter.step }} plug-in
      {{ ('Welcome to the documentation for the ' + cookiecutter.step + ' plug-in')|length * '=' }} 

      Contents:

      .. toctree::
	 :maxdepth: 1
	 :titlesonly:

	 user/index
	 developer/index
	 ...

   This is why we needed the variable ``step``: to put the right name
   in the title of the documentation. Note the the next line creates a
   line of equals signs of the same length as the title, which is how
   you form a title in reStructedText.

#. If you need, there a pre- and post-processing hooks in for the
   Cookiecutter. You place this in the ``hooks/`` subdirectory of the
   main template directory, i.e. at the same level as
   ``{{cookiecutter.repo_name}}``. The must be named
   ``pre_gen_project.xxx`` and ``post_gen_project.xxx``. If the
   extenions is ``.py`` they are run using Python; otherwise they are
   expected to be executable. I used two preprocessing files, one in
   Python just to check that the ``repo_name`` is a valid name for a
   directory, and the other a bash shell-script to move some files
   around (``pre_gen_project.bash``)::

      #!/bin/bash
      git rm docs/readme.rst
      mkdir docs/developer
      git mv docs/contributing.rst docs/installation.rst docs/usage.rst docs/developer/
      cat >> devtools/conda-envs/test_env.yaml <<EOF

	  # Documentation
	  - rinohtype
	  - pygments
	  - sphinx-rtd-theme
	  - pystemmer
      EOF

   As you can see, I was moving some documentation to different places
   and adding the requirements for the documentation to the Conda
   environment used in the CI. I also had quite a number of files in
   the template directory to flesh out a template of the
   documentation.

   These pre- and post-processing hooks execute in the target
   directory.

Test Carefully!!!
-----------------
Once you have everything set, test. And then test again! I made a
``tmp/`` directory and made a copy of the target directory in it. I
then ran the Cookiecutter::

   bash-3.2$ cookiecutter -f ../update
   step [Name of your code or step, e.g. MOPAC or Polymer Builder]: System
   repo_name [system_step]: 
   bash-3.2$ 

and checked that the correct files and changes were made. Of course
they weren't, so I fixed the problems, made anothe clean copy of the
target, and ran again. Until it worked. Then:

Update your targets
-------------------
This is the easy step, once the updater works properly. Get a clean
copy of the targets, create a new branch in each, run the
updater. After checking the resulting code, check it into to Git and
make a pull request. 

Relax!
------
That wasn't too bad, was it? Of course it is not worth the effort if
you only have one or two target directories. But if you have 4 or 5,
or 24 it can save a lot of time. Not to mention many errrors and
typoss. :-)

.. _Cookiecutter: https://github.com/cookiecutter/cookiecutter
.. _Cookiecutter for SEAMM plug-ins: https://github.com/molssi-seamm/cookiecutter-seamm-plugin
