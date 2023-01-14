.. _productivity:

************
Productivity
************

If you are preparing a high-throughput and complex workflow including hundreds and 
thousands of atomistic simulations, SEAMM is here to help. SEAMM wraps large simulation 
engines in :term:`plug-ins<plug-in>` and hides them behind intuitive graphical user interfaces
(GUIs). As explained in the :ref:`user-experience` section, users do not need to deal with 
complexities of the input files and software specific syntaxes and keywords to setup the
calculations. In addition to offering GUIs, SEAMM also supports a wide range of simulation 
engines and software packages in the computational molecular sciences such as

* `MOPAC`_ for semiempirical quantum chemistry,
* `DFTB+`_ for density functional-based tight binding,
* `Psi4`_ for quantum chemistry,
* `LAMMPS`_ for molecular dynamics (MD) for materials.

Other plug-ins provide extra functionalities for:

* building structures, e.g. `Packmol`_,
* converting file formats using `Open Babel`_, and
* cheminformatics with `RDKit`_.

We'd like to add plug-ins for other codes such as:

* `PySCF`, `GAMESS`_, and `NWChem`_ for quantum chemistry,
* `VASP`_, `Quantum Espresso`_, `FHI-aims`_ and `NWChem`_ for periodic density
  functional theory (DFT),
* `GROMACS`_, `NAMD`_, etc. for biomolecular molecular dynamics (MD),

If you have suggestions, or know people who would like to help, let us know!

By employing both GUIs and `helper` plug-ins, the complicated and time-consuming task of
setting up complex workflows will become more convenient, efficient and less error-prone.

The final key feature in SEAMM is the :term:`flowchart<flowchart>`. All details pertinent
to every step of any specific workflow can be stored, modified, rerun, shared or published
using the flowcharts. As such, flowcharts do replace the common practice of writing scripts
for managing a specific sequence of tasks because it is much easier to create flowcharts
within SEAMM. Furthermore, flowcharts are also executable which will be to run on any machine
with a copy of SEAMM installed. So, one can build up a library of flowcharts for common tasks
and share them within their group, collaborators or the community. This method can also be
useful when the user is not an expert on a specific topic or task. Then, the user can receive
or import a flowchart designed by an expert and use it as-is or tweak it towards the task at
hand. Flowcharts in SEAMM provide two additional functionalities that are helpful for improving
productivity: (i) loops, and (ii) control flow structures. These two tools are extremely useful
in building automatic and complex workflows such as running a specific step in flowcharts
over several molecules or performing a parameter scan over a finite range of values.
The generated results from these workflows can be captured and stored in tables and
exported for further analysis by e.g. spreadsheet programs.

The aforementioned features help the users to minimize the required steps for designing
high-throughput and complex workflows while reducing the chance of making mistakes that
are difficult to track down the line. The integrated :term:`job manager` in SEAMM also
helps the users to control the executed jobs and the :term:`job datastore` captures
every job that is run. SEAMM provides every data and functionality required for
your research with convenience at your fingertips.

.. Software links
.. _MOPAC: http://openmopac.net
.. _DFTB+: https://dftbplus.org
.. _GAMESS: https://www.msg.chem.iastate.edu/gamess
.. _NWChem: https://www.nwchem-sw.org
.. _Psi4: https://psicode.org
.. _VASP: https://www.vasp.at
.. _Quantum Espresso: https://www.quantum-espresso.org
.. _FHI-aims: https://fhi-aims.org
.. _GROMACS: https://www.gromacs.org
.. _NAMD: https://www.ks.uiuc.edu/Research/namd
.. _LAMMPS: https://www.lammps.org
.. _Cassandra: https://cassandra.nd.edu
.. _Towhee: http://towhee.sourceforge.net
.. _Packmol: http://leandro.iqm.unicamp.br/m3g/packmol/home.shtml
.. _Open Babel: https://openbabel.org/wiki/Main_Page
.. _RDKit: https://www.rdkit.org
