************************************************
Creating the plug-in with the seamm-cookiecutter
************************************************

The first step is to run the **seamm-cookiecutter** to create the skeleton of your
plug-in. As always with command-line programs the *--help* options is your friend::

  (seamm-dev) psaxe@PaulsPersonal SEAMM % seamm-cookiecutter --help
  seamm-cookiecutter --help
  usage: seamm-cookiecutter [-h] [--replay] [-t {plug-in,substep,forcefield}]

  optional arguments:
    -h, --help            show this help message and exit
    --replay              Replay the last installation.
    -t {plug-in,substep,forcefield}, --type {plug-in,substep,forcefield}
			  The type of SEAMM object to create, one of plug-in, substep, forcefield. Defaults to plug-in

We want to create plug-in. Since that is the default, we can just run the SEAMM
cookiecutter. It will ask a set of questions for you to answer::

  (seamm-dev) psaxe@PaulsPersonal SEAMM % seamm-cookiecutter
  seamm-cookiecutter
  step [Name of your code or step, e.g. MOPAC or Polymer Builder]: PySCF
  PySCF
  use_subflowchart [n]: 

  repo_name [pyscf_step]: 

  class_name [Pyscf]: PySCF
  PySCF
  github_username [The GitHub directory (a username or organization) to use]: paulsaxe
  paulsaxe
  author_name [Your name (or your organization if appropriate)]: Paul Saxe
  Paul Saxe
  author_email [Your email (or your organization's if appropriate)]: psaxe@molssi.org
  psaxe@molssi.org
  description [A SEAMM plug-in for PySCF]: 

  Select dependency_source:
  1 - Prefer conda-forge over the default anaconda channel with pip fallback
  2 - Prefer default anaconda channel with pip fallback
  3 - Dependencies from pip only (no conda)
  Choose from 1, 2, 3 [1]: 

  pypi_username [paulsaxe]: 

  Select license:
  1 - BSD-3-Clause
  2 - MIT
  3 - GNU General Public License v3+
  4 - GNU Lesser General Public License v3+
  5 - other
  Choose from 1, 2, 3, 4, 5 [1]: 


  fatal: not a git repository (or any of the parent directories): .git
   128
  b'fatal: not a git repository (or any of the parent directories): .git\n'
  Initialized empty Git repository in /Users/psaxe/Work/SEAMM/pyscf_step/.git/


  [main (root-commit) 408f84e] Initial commit after SEAMM plugin Cookiecutter creation, version '2022.8.23'
   46 files changed, 5112 insertions(+)
   create mode 100644 .codecov.yml
   create mode 100644 .editorconfig
   create mode 100644 .github/ISSUE_TEMPLATE.md
   create mode 100644 .github/workflows/BranchCI.yaml
   create mode 100644 .github/workflows/CI.yaml
   create mode 100644 .github/workflows/Docs.yaml
   create mode 100644 .github/workflows/Release.yaml
   create mode 100644 .gitignore
   create mode 100644 .lgtm.yml
   create mode 100644 AUTHORS.rst
   create mode 100644 CONTRIBUTING.rst
   create mode 100644 HISTORY.rst
   create mode 100644 LICENSE
   create mode 100644 MANIFEST.in
   create mode 100644 Makefile
   create mode 100644 README.rst
   create mode 100644 devtools/README.md
   create mode 100644 devtools/conda-envs/test_env.yaml
   create mode 100644 devtools/scripts/create_conda_env.py
   create mode 100644 docs/.gitignore
   create mode 100644 docs/Makefile
   create mode 100644 docs/authors.rst
   create mode 100755 docs/buildDocs.sh
   create mode 100755 docs/conf.py
   create mode 100644 docs/contributing.rst
   create mode 100644 docs/history.rst
   create mode 100644 docs/index.rst
   create mode 100644 docs/installation.rst
   create mode 100644 docs/make.bat
   create mode 100644 docs/readme.rst
   create mode 100644 docs/usage.rst
   create mode 100644 pyscf_step/__init__.py
   create mode 100644 pyscf_step/_version.py
   create mode 100644 pyscf_step/data/references.bib
   create mode 100644 pyscf_step/pyscf.py
   create mode 100644 pyscf_step/pyscf_parameters.py
   create mode 100644 pyscf_step/pyscf_step.py
   create mode 100644 pyscf_step/tk_pyscf.py
   create mode 100644 requirements.txt
   create mode 100644 requirements_dev.txt
   create mode 100644 requirements_install.txt
   create mode 100644 setup.cfg
   create mode 100644 setup.py
   create mode 100644 tests/__init__.py
   create mode 100644 tests/test_pyscf_step.py
   create mode 100644 versioneer.py

OK, that was quite a lot! Let's take the questions one-at-a-time and understand them.

step [Name of your code or step, e.g. MOPAC or Polymer Builder]:
  This is the name that user will see in SEAMM. "PySCF" is a good choice.

use_subflowchart [n]:
  Most steps have a single dialog; however, ones that implement simulation codes that
  handle many steps of calculation can be implemented using a subflowchart with substeps
  for that code. The MOPAC, DFTB+, and LAMMPS are examples of plug-ins that use a
  subflowchart. Most other plug-ins are "simple". While a full implementation of a
  plug-in for PySCF would probably use a subflowchart, we are creating a simple plug-in,
  so accept the default answer, "n" for no.

repo_name [pyscf_step]:
  This will be the name of the repository on e.g. GitHub, the name of the directory
  created, and most importantly the name of the Python package. By convention plug-ins
  for SEAMM always end in "_step". If you plan to publish your package -- yes, you do,
  right? -- **it is critically important that you check that the name is available!** To
  check, go to `PyPI <https://pypi.org>`_ and search for this name in the search box at
  the top of the main page. You will always get a list of similar packages, but if the
  first one is identically your name, you will have to find another name. For this
  tutorial you needn't worry, because you will not publish the plug-in, but in the
  future remember this step. Fortunately the "_step" suffix is quite uncommon so you
  probably won't have a name conflict.

class_name [Pyscf]:
  This will be the root name of the classes in this package. The default isi the name of
  the code in lower case with the first letter capitalized. Above I made it look
  prettier because PySCF is ... PySCF capitalized like that.

github_username [The GitHub directory (a username or organization) to use]:
  This is probably your username on GitHub, though it might be your groups
  organization. The repository will end up being <this name>/<repo_name>.

author_name [Your name (or your organization if appropriate)]:
  Your name in a human-readable form.

author_email [Your email (or your organization's if appropriate)]:
  Your email address where people can contact you.

description [A SEAMM plug-in for PySCF]:
  A short (<~ 80 characters) description of the plug-in that will be shown at e.g. PyPI
  and the SEAMM Installer.

Select dependency_source:
  1 - Prefer conda-forge over the default anaconda channel with pip fallback
  2 - Prefer default anaconda channel with pip fallback
  3 - Dependencies from pip only (no conda)
  Choose from 1, 2, 3 [1]: 

  Unless you have good reason, use the default (conda-forge).

pypi_username [paulsaxe]: 
  This is your username at PyPI, usually the same as GitHub. If you don't have an
  account at PyPI you can create one later.

Select license:
  1 - BSD-3-Clause
  2 - MIT
  3 - GNU General Public License v3+
  4 - GNU Lesser General Public License v3+
  5 - other
  Choose from 1, 2, 3, 4, 5 [1]: 

  The license you want your code to bu under. Most plug-ins in SEAMM use the
  BSD-3-Clause license, but feel free to use whatever you want. The main framework of
  SEAMM is licensed under the LGPL.

Once you answer these questions, the cookiecutter will create the initial version of
your plug-in. You can ignore the warnings from git.
