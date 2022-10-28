.. _creating:

*************************************************
Creating the Initial Code and Uploading to GitHub
*************************************************

Like this::
  
  (seamm-dev) psaxe@PaulsPersonal % seamm-cookiecutter 
  step [Name of your code or step, e.g. MOPAC or Polymer Builder]: Quick Conformer Search

  use_subflowchart [n]: 

  repo_name [quick_conformer_search_step]: 

  class_name [QuickConformerSearch]: 

  github_username [molssi-seamm]: 

  author_name [Paul Saxe]: 

  author_email [psaxe@molssi.org]: 

  description [A...Search]: A SEAMM plug-in for a simple, quick conformer search

  Select dependency_source:
  1 - Prefer conda-forge over the default anaconda channel with pip fallback
  2 - Prefer default anaconda channel with pip fallback
  3 - Dependencies from pip only (no conda)
  Choose from 1, 2, 3 [1]: 

  pypi_username [seamm]: 

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
  Initialized empty Git repository in /Users/psaxe/Work/SEAMM/quick_conformer_search_step/.git/


  [main (root-commit) e3f8e7f] Initial commit after SEAMM plugin Cookiecutter creation, version '2022.10.23'
   49 files changed, 5228 insertions(+)
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
   create mode 100644 docs/developer/contributing.rst
   create mode 100644 docs/developer/index.rst
   create mode 100644 docs/developer/installation.rst
   create mode 100644 docs/developer/usage.rst
   create mode 100644 docs/history.rst
   create mode 100644 docs/index.rst
   create mode 100644 docs/make.bat
   create mode 100644 docs/user/index.rst
   create mode 100644 quick_conformer_search_step/__init__.py
   create mode 100644 quick_conformer_search_step/_version.py
   create mode 100644 quick_conformer_search_step/data/properties.csv
   create mode 100644 quick_conformer_search_step/data/references.bib
   create mode 100644 quick_conformer_search_step/metadata.py
   create mode 100644 quick_conformer_search_step/quick_conformer_search.py
   create mode 100644 quick_conformer_search_step/quick_conformer_search_parameters.py
   create mode 100644 quick_conformer_search_step/quick_conformer_search_step.py
   create mode 100644 quick_conformer_search_step/tk_quick_conformer_search.py
   create mode 100644 requirements.txt
   create mode 100644 requirements_dev.txt
   create mode 100644 requirements_install.txt
   create mode 100644 setup.cfg
   create mode 100644 setup.py
   create mode 100644 tests/__init__.py
   create mode 100644 tests/test_quick_conformer_search_step.py
   create mode 100644 versioneer.py


Like this::
  (seamm-dev) psaxe@PaulsPersonal % cd quick_conformer_search_step/

  (seamm-dev) psaxe@PaulsPersonal % git remote add origin git@github.com:molssi-seamm/quick_conformer_search_step.git
  (seamm-dev) psaxe@PaulsPersonal % git branch -M main
  (seamm-dev) psaxe@PaulsPersonal % git push -u origin main

  Enumerating objects: 72, done.
  Counting objects: 100% (72/72), done.
  Delta compression using up to 8 threads
  Compressing objects: 100% (63/63), done.
  Writing objects: 100% (72/72), 49.97 KiB | 409.00 KiB/s, done.
  Total 72 (delta 10), reused 0 (delta 0), pack-reused 0
  remote: Resolving deltas: 100% (10/10), done.        
  To github.com:molssi-seamm/quick_conformer_search_step.git
   * [new branch]      main -> main
  branch 'main' set up to track 'origin/main'.
