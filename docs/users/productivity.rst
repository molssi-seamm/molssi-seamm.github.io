.. _productivity:

************
Productivity
************

SEAMM helps you get your work done faster and more easily. First, it helps you set up
your calculations. The large simulation codes are wrapped in :term:`plug-ins<plug-in>`
which provide intuitive graphical user interfaces (GUIs) so you don't have to start with
an empty input file in a text editor and remember all the keywords and commands for each
code. While you maybe very comfortable with one or two codes, you probably can use other
codes in your research, but don't know their input as well. SEAMM supports a wide range
of codes, such as

* MOPAC for semiempirical quantum chemistry
* GAMESS, NWChem and Psi4 for quantum cehmistry
* VASP, Quantum Espresso, FHI-aims and NWChem for periodic DFT
* GROMACS, NAMD, etc. for biomolecular molecular dynamics (MD)
* LAMMPS for molecular dynamics (MD) for materials
* Cassandra and Towhee for Monte Carlo simulations of fluids

Other plug-ins provide functionality for building structures, e.g. Packmol, for
converting file formats using Open Babel, and cheminformatics functionality with
RDKit. The 'helpers' do the little tasks that you need to wrangle structures into the
simulation codes and analyze results.

Between the GUI's and the convenient 'helper' plug-ins, setting up your workflow will
indeed be faster and less error prone. Two other aspects of SEAMM will help you do even
more. First, SEAMM has loops and other control structures, so when you want to run over
several molecules, or do a parameter sweep, you can easily automate the workflow. The
results can be captured in tables and output for e.g. analysis in a spreadsheet program.

The last aspect is that the :term:`flowcharts<flowchart>` that you, and others, develop
in SEAMM can be saved, rerun and shared. You probably already do this with scripts that
you write, but creating flowcharts in SEAMM is easier than writing scripts -- and they
will run in any other copy of SEAMM. So you can build up a library of flowcharts for
common tasks and share them in your group. Or email them to a colleague. This means that
if you need some calculations that you are not completely expert at, you can get a
flowchart written by an expert to use as-is or you can tweak it to do precisely what you
need.

These features help you get more done more quickly. You will also make fewer
mistakes and waste less time tracking them down. But now that you can do more, SEAMM
helps you in other ways. The integrated :term:`Job Manager` helps you control the jobs
that you are running, and the :term:`Job Datastore` captures every job that you
run. When it comes time to write the paper or project report, everything is there at
your fingertips.
