# Minimal makefile for Sphinx documentation
#

define BROWSER_PYSCRIPT
import os, webbrowser, sys
try:
	from urllib import pathname2url
except:
	from urllib.request import pathname2url

webbrowser.open("file://" + pathname2url(os.path.abspath(sys.argv[1])))
endef
export BROWSER_PYSCRIPT

BROWSER := python -c "$$BROWSER_PYSCRIPT"

# You can set these variables from the command line.
SPHINXOPTS    =
SPHINXBUILD   = sphinx-build
SOURCEDIR     = docs
BUILDDIR      = docs/_build

all:
	@make html
	$(BROWSER) docs/_build/html/index.html

check:
	cd docs/ && ~/bin/lychee --exclude https://twitter.com --exclude 'https://pypistats.org' --exclude-loopback --no-progress .

update:  ## post-release: sync the merged main into dev, rebuild the docs, push dev
	git checkout main
	git pull
	git checkout dev
	git merge --ff-only main
	@make html
	git push

help:
	@$(SPHINXBUILD) -M help "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

.PHONY: help Makefile update

# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
%: Makefile
	@$(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)
