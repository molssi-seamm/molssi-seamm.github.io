******
Status
******

The current build status for the modules and :term:`plug-ins<plug-in>`:

.. csv-table:: Core Modules
   :header-rows: 1

   "Core Module",   "Pull Requests", "Build Status", "Code Coverage", "------ Code Quality ------", "Documentation", "Dependencies", "--------- PyPi ---------"
   seamm_,             |seamm0|,     |seamm1|,       |seamm2|,         |seamm3|,   	   |seamm4|,      |seamm5|,     |seamm6|
   seamm_util_,        |su0|,        |su1|,          |su2|,            |su3|,      	   |su4|,         |su5|,        |su6|
   seamm_widgets_,     |sw0|,        |sw1|,          |sw2|,            |sw3|,      	   |sw4|,         |sw5|,        |sw6|
   seamm_jobserver_,   |sj0|,        |sj1|,          |sj2|,            |sj3|,      	   |sj4|,         |sj5|,        |sj6|
   seamm_ff_util_,     |sf0|,        |sf1|,          |sf2|,            |sf3|,      	   |sf4|,         |sf5|,        |sf6|
   molsystem_,         |sy0|,        |sy1|,          |sy2|,            |sy3|,      	   |sy4|,         |sy5|,        |sy6|
   reference_handler_, |rh0|,        |rh1|,          |rh2|,            |rh3|,      	   |rh4|,         |rh5|,        |rh6|



.. csv-table:: Plug-Ins
   :header-rows: 1

   Plug-In,                "Pull Requests", "Build Status", "Code Coverage", "------ Code Quality ------", "Documentation", "Dependencies", "--------- PyPi---------"
   control_parameters_step_, |control0|,  |control1|,     |control2|,      |control3|, 	     	       	 |control4|,      |control5|,     |control6|
   crystal_builder_step_, |crystal0|,     |crystal1|,     |crystal2|,      |crystal3|, 	     	       	 |crystal4|,      |crystal5|,     |crystal6|
   custom_step_,          |custom0|,      |custom1|,      |custom2|,       |custom3|,  	     	       	 |custom4|,       |custom5|,      |custom6|
   dftbplus_step_,        |dftb0|,        |dftb1|,        |dftb2|,         |dftb3|,  	     	       	 |dftb4|,         |dftb5|,        |dftb6|
   forcefield_step_,      |ffield0|,      |ffield1|,      |ffield2|,       |ffield3|,  	     	       	 |ffield4|,       |ffield5|,      |ffield6|
   from_smiles_step_,     |smiles0|,      |smiles1|,      |smiles2|,       |smiles3|,  	     	       	 |smiles4|,       |smiles5|,      |smiles6|
   lammps_step_,          |lammps0|,      |lammps1|,      |lammps2|,       |lammps3|,  	     	       	 |lammps4|,       |lammps5|,      |lammps6|
   loop_step_,            |loop0|,        |loop1|,        |loop2|,         |loop3|,    	     	       	 |loop4|,         |loop5|,        |loop6|
   mopac_step_,           |mopac0|,       |mopac1|,       |mopac2|,        |mopac3|,   	     	       	 |mopac4|,        |mopac5|,       |mopac6|
   packmol_step_,         |packmol0|,     |packmol1|,     |packmol2|,      |packmol3|, 	     	       	 |packmol4|,      |packmol5|,     |packmol6|
   psi4_step_,            |psi4_0|,       |psi4_1|,       |psi4_2|,        |psi4_3|, 	     	       	 |psi4_4|,        |psi4_5|,       |psi4_6|
   read_structure_step_,  |structure0|,   |structure1|,   |structure2|,    |structure3|,     	       	 |structure4|,    |structure5|,   |structure6|
   set_cell_step_,        |set_cell0|,    |set_cell1|,    |set_cell2|,     |set_cell3|,	     	       	 |set_cell4|,     |set_cell5|,    |set_cell6|
   solvate_step_,         |solvate0|,     |solvate1|,     |solvate2|,      |solvate3|,	     	       	 |solvate4|,      |solvate5|,     |solvate6|
   supercell_step_,       |supercell0|,   |supercell1|,   |supercell2|,    |supercell3|,		 |supercell4|,    |supercell5|,   |supercell6|
   table_step_,           |table0|,       |table1|,       |table2|,        |table3|,   	     	       	 |table4|,        |table5|,       |table6|



.. seamm badges

.. _seamm: https://github.com/molssi-seamm/seamm

.. |seamm0| image:: https://img.shields.io/github/issues-pr-raw/molssi-seamm/seamm
   :target: https://github.com/molssi-seamm/seamm/pulls
   :alt: GitHub pull requests

.. |seamm1| image:: https://github.com/molssi-seamm/seamm/workflows/CI/badge.svg
   :target: https://github.com/molssi-seamm/seamm/actions/workflows/CI.yaml
   :alt: Build Status

.. |seamm2| image:: https://codecov.io/gh/molssi-seamm/seamm/branch/master/graph/badge.svg
   :target: https://codecov.io/gh/molssi-seamm/seamm
   :alt: Code Coverage

.. |seamm3| image:: https://img.shields.io/lgtm/grade/python/g/molssi-seamm/seamm.svg?logo=lgtm&logoWidth=18
   :target: https://lgtm.com/projects/g/molssi-seamm/seamm/context:python
   :alt: Code Quality

.. |seamm4| image:: https://github.com/molssi-seamm/seamm/workflows/Documentation/badge.svg
   :target: https://github.com/molssi-seamm/seamm/actions/workflows/Docs.yaml
   :alt: Documentation Status

.. |seamm5| image:: https://pyup.io/repos/github/molssi-seamm/seamm/shield.svg
   :target: https://pyup.io/repos/github/molssi-seamm/seamm/
   :alt: Updates for Dependencies

.. |seamm6| image:: https://img.shields.io/pypi/v/seamm.svg
   :target: https://pypi.python.org/pypi/seamm
   :alt: PyPi VERSION

.. seamm_util badges

.. _seamm_util: https://github.com/molssi-seamm/seamm_util

.. |su0| image:: https://img.shields.io/github/issues-pr-raw/molssi-seamm/seamm_util
   :target: https://github.com/molssi-seamm/seamm_util/pulls
   :alt: GitHub pull requests

.. |su1| image:: https://github.com/molssi-seamm/seamm_util/workflows/CI/badge.svg
   :target: https://github.com/molssi-seamm/seamm_util/actions/workflows/CI.yaml
   :alt: Build Status

.. |su2| image:: https://codecov.io/gh/molssi-seamm/seamm_util/branch/master/graph/badge.svg
   :target: https://codecov.io/gh/molssi-seamm/seamm_util
   :alt: Code Coverage

.. |su3| image:: https://img.shields.io/lgtm/grade/python/g/molssi-seamm/seamm_util.svg?logo=lgtm&logoWidth=18
   :target: https://lgtm.com/projects/g/molssi-seamm/seamm_util/context:python
   :alt: Code Quality

.. |su4| image:: https://github.com/molssi-seamm/seamm_util/workflows/Documentation/badge.svg
   :target: https://github.com/molssi-seamm/seamm_util/actions/workflows/Docs.yaml
   :alt: Documentation Status

.. |su5| image:: https://pyup.io/repos/github/molssi-seamm/seamm_util/shield.svg
   :target: https://pyup.io/repos/github/molssi-seamm/seamm_util/
   :alt: Updates for Dependencies

.. |su6| image:: https://img.shields.io/pypi/v/seamm_util.svg
   :target: https://pypi.python.org/pypi/seamm_util
   :alt: PyPi VERSION

.. seamm_widgets badges

.. _seamm_widgets: https://github.com/molssi-seamm/seamm_widgets

.. |sw0| image:: https://img.shields.io/github/issues-pr-raw/molssi-seamm/seamm_widgets
   :target: https://github.com/molssi-seamm/seamm_widgets/pulls
   :alt: GitHub pull requests

.. |sw1| image:: https://github.com/molssi-seamm/seamm_widgets/workflows/CI/badge.svg
   :target: https://github.com/molssi-seamm/seamm_widgets/actions/workflows/CI.yaml
   :alt: Build Status

.. |sw2| image:: https://codecov.io/gh/molssi-seamm/seamm_widgets/branch/master/graph/badge.svg
   :target: https://codecov.io/gh/molssi-seamm/seamm_widgets
   :alt: Code Coverage

.. |sw3| image:: https://img.shields.io/lgtm/grade/python/g/molssi-seamm/seamm_widgets.svg?logo=lgtm&logoWidth=18
   :target: https://lgtm.com/projects/g/molssi-seamm/seamm_widgets/context:python
   :alt: Code Quality

.. |sw4| image:: https://github.com/molssi-seamm/seamm_widgets/workflows/Documentation/badge.svg
   :target: https://github.com/molssi-seamm/seamm_widgets/actions/workflows/Docs.yaml
   :alt: Documentation Status

.. |sw5| image:: https://pyup.io/repos/github/molssi-seamm/seamm_widgets/shield.svg
   :target: https://pyup.io/repos/github/molssi-seamm/seamm_widgets/
   :alt: Updates for Dependencies

.. |sw6| image:: https://img.shields.io/pypi/v/seamm_widgets.svg
   :target: https://pypi.python.org/pypi/seamm_widgets
   :alt: PyPi VERSION

.. seamm_jobserver badges

.. _seamm_jobserver: https://github.com/molssi-seamm/seamm_jobserver

.. |sj0| image:: https://img.shields.io/github/issues-pr-raw/molssi-seamm/seamm_jobserver
   :target: https://github.com/molssi-seamm/seamm_jobserver/pulls
   :alt: GitHub pull requests

.. |sj1| image:: https://github.com/molssi-seamm/seamm_jobserver/workflows/CI/badge.svg
   :target: https://github.com/molssi-seamm/seamm_jobserver/actions/workflows/CI.yaml
   :alt: Build Status

.. |sj2| image:: https://codecov.io/gh/molssi-seamm/seamm_jobserver/branch/master/graph/badge.svg
   :target: https://codecov.io/gh/molssi-seamm/seamm_jobserver
   :alt: Code Coverage

.. |sj3| image:: https://img.shields.io/lgtm/grade/python/g/molssi-seamm/seamm_jobserver.svg?logo=lgtm&logoWidth=18
   :target: https://lgtm.com/projects/g/molssi-seamm/seamm_jobserver/context:python
   :alt: Code Quality

.. |sj4| image:: https://github.com/molssi-seamm/seamm_jobserver/workflows/Documentation/badge.svg
   :target: https://github.com/molssi-seamm/seamm_jobserver/actions/workflows/Docs.yaml
   :alt: Documentation Status

.. |sj5| image:: https://pyup.io/repos/github/molssi-seamm/seamm_jobserver/shield.svg
   :target: https://pyup.io/repos/github/molssi-seamm/seamm_jobserver/
   :alt: Updates for Dependencies

.. |sj6| image:: https://img.shields.io/pypi/v/seamm_jobserver.svg
   :target: https://pypi.python.org/pypi/seamm_jobserver
   :alt: PyPi VERSION

.. seamm_ff_util badges

.. _seamm_ff_util: https://github.com/molssi-seamm/seamm_ff_util

.. |sf0| image:: https://img.shields.io/github/issues-pr-raw/molssi-seamm/seamm_widgets
   :target: https://github.com/molssi-seamm/seamm_widgets/pulls
   :alt: GitHub pull requests

.. |sf1| image:: https://github.com/molssi-seamm/seamm_ff_util/workflows/CI/badge.svg
   :target: https://github.com/molssi-seamm/seamm_ff_util/actions/workflows/CI.yaml
   :alt: Build Status

.. |sf2| image:: https://codecov.io/gh/molssi-seamm/seamm_ff_util/branch/master/graph/badge.svg
   :target: https://codecov.io/gh/molssi-seamm/seamm_ff_util
   :alt: Code Coverage

.. |sf3| image:: https://img.shields.io/lgtm/grade/python/g/molssi-seamm/seamm_ff_util.svg?logo=lgtm&logoWidth=18
   :target: https://lgtm.com/projects/g/molssi-seamm/seamm_ff_util/context:python
   :alt: Code Quality

.. |sf4| image:: https://github.com/molssi-seamm/seamm_ff_util/workflows/Documentation/badge.svg
   :target: https://github.com/molssi-seamm/seamm_ff_util/actions/workflows/Docs.yaml
   :alt: Documentation Status

.. |sf5| image:: https://pyup.io/repos/github/molssi-seamm/seamm_ff_util/shield.svg
   :target: https://pyup.io/repos/github/molssi-seamm/seamm_ff_util/
   :alt: Updates for Dependencies

.. |sf6| image:: https://img.shields.io/pypi/v/seamm_ff_util.svg
   :target: https://pypi.python.org/pypi/seamm_ff_util
   :alt: PyPi VERSION

.. molsystem badges

.. _molsystem: https://github.com/molssi-seamm/molsystem

.. |sy0| image:: https://img.shields.io/github/issues-pr-raw/molssi-seamm/molsystem
   :target: https://github.com/molssi-seamm/molsystem/pulls
   :alt: GitHub pull requests

.. |sy1| image:: https://github.com/molssi-seamm/molsystem/workflows/CI/badge.svg
   :target: https://github.com/molssi-seamm/molsystem/actions/workflows/CI.yaml
   :alt: Build Status

.. |sy2| image:: https://codecov.io/gh/molssi-seamm/molsystem/branch/master/graph/badge.svg
   :target: https://codecov.io/gh/molssi-seamm/molsystem
   :alt: Code Coverage

.. |sy3| image:: https://img.shields.io/lgtm/grade/python/g/molssi-seamm/molsystem.svg?logo=lgtm&logoWidth=18
   :target: https://lgtm.com/projects/g/molssi-seamm/molsystem/context:python
   :alt: Code Quality

.. |sy4| image:: https://github.com/molssi-seamm/molsystem/workflows/Documentation/badge.svg
   :target: https://github.com/molssi-seamm/molsystem/actions/workflows/Docs.yaml
   :alt: Documentation Status

.. |sy5| image:: https://pyup.io/repos/github/molssi-seamm/molsystem/shield.svg
   :target: https://pyup.io/repos/github/molssi-seamm/molsystem/
   :alt: Updates for Dependencies

.. |sy6| image:: https://img.shields.io/pypi/v/molsystem.svg
   :target: https://pypi.python.org/pypi/molsystem
   :alt: PyPi VERSION

.. reference_handler badges

.. _reference_handler: https://github.com/molssi/reference_handler

.. |rh0| image:: https://img.shields.io/github/issues-pr-raw/molssi/reference_handler
   :target: https://github.com/molssi-seamm/reference/pulls
   :alt: GitHub pull requests

.. |rh1| image:: https://github.com/molssi-seamm/reference_handler/workflows/CI/badge.svg
   :target: https://github.com/molssi-seamm/reference_handler/actions/workflows/CI.yaml
   :alt: Build Status

.. |rh2| image:: https://codecov.io/gh/molssi/reference_handler/branch/master/graph/badge.svg
   :target: https://codecov.io/gh/molssi/reference_handler
   :alt: Code Coverage

.. |rh3| image:: https://img.shields.io/lgtm/grade/python/g/MolSSI/reference_handler.svg?logo=lgtm&logoWidth=18
   :target: https://lgtm.com/projects/g/MolSSI/reference_handler/context:python
   :alt: Code Quality

.. |rh4| image:: https://github.com/molssi-seamm/reference_handler/workflows/Documentation/badge.svg
   :target: https://github.com/molssi-seamm/reference_handler/actions/workflows/Docs.yaml
   :alt: Documentation Status

.. |rh5| image:: https://pyup.io/repos/github/molssi/reference_handler/shield.svg
   :target: https://pyup.io/repos/github/molssi/reference_handler/
   :alt: Updates for Dependencies

.. |rh6| image:: https://img.shields.io/pypi/v/reference_handler.svg
   :target: https://pypi.python.org/pypi/reference_handler
   :alt: PyPi VERSION

.. control parameters step badges

.. _control_parameters_step: https://github.com/molssi-seamm/control_parameters_step

.. |control0| image:: https://img.shields.io/github/issues-pr-raw/molssi-seamm/control_parameters_step
   :target: https://github.com/molssi-seamm/control_parameters_step/pulls
   :alt: GitHub pull requests

.. |control1| image:: https://github.com/molssi-seamm/control_parameters_step/workflows/CI/badge.svg
   :target: https://github.com/molssi-seamm/control_parameters_step/actions/workflows/CI.yaml
   :alt: Build Status

.. |control2| image:: https://codecov.io/gh/molssi-seamm/control_parameters_step/branch/master/graph/badge.svg
   :target: https://codecov.io/gh/molssi-seamm/control_parameters_step
   :alt: Code Coverage

.. |control3| image:: https://img.shields.io/lgtm/grade/python/g/molssi-seamm/control_parameters_step.svg?logo=lgtm&logoWidth=18
   :target: https://lgtm.com/projects/g/molssi-seamm/control_parameters_step/context:python
   :alt: Code Quality

.. |control4| image:: https://github.com/molssi-seamm/control_parameters_step/workflows/Documentation/badge.svg
   :target: https://github.com/molssi-seamm/control_parameters_step/actions/workflows/Docs.yaml
   :alt: Documentation Status

.. |control5| image:: https://pyup.io/repos/github/molssi-seamm/control_parameters_step/shield.svg
   :target: https://pyup.io/repos/github/molssi-seamm/control_parameters_step/
   :alt: Updates for Dependencies

.. |control6| image:: https://img.shields.io/pypi/v/control_parameters_step.svg
   :target: https://pypi.python.org/pypi/control_parameters_step
   :alt: PyPi VERSION

.. crystal builder step badges

.. _crystal_builder_step: https://github.com/molssi-seamm/crystal_builder_step

.. |crystal0| image:: https://img.shields.io/github/issues-pr-raw/molssi-seamm/crystal_builder_step
   :target: https://github.com/molssi-seamm/crystal_builder_step/pulls
   :alt: GitHub pull requests

.. |crystal1| image:: https://github.com/molssi-seamm/crystal_builder_step/workflows/CI/badge.svg
   :target: https://github.com/molssi-seamm/crystal_builder_step/actions/workflows/CI.yaml
   :alt: Build Status

.. |crystal2| image:: https://codecov.io/gh/molssi-seamm/crystal_builder_step/branch/master/graph/badge.svg
   :target: https://codecov.io/gh/molssi-seamm/crystal_builder_step
   :alt: Code Coverage

.. |crystal3| image:: https://img.shields.io/lgtm/grade/python/g/molssi-seamm/crystal_builder_step.svg?logo=lgtm&logoWidth=18
   :target: https://lgtm.com/projects/g/molssi-seamm/crystal_builder_step/context:python
   :alt: Code Quality

.. |crystal4| image:: https://github.com/molssi-seamm/crystal_builder_step/workflows/Documentation/badge.svg
   :target: https://github.com/molssi-seamm/crystal_builder_step/actions/workflows/Documentation.yam
   :alt: Documentation Status

.. |crystal5| image:: https://pyup.io/repos/github/molssi-seamm/crystal_builder_step/shield.svg
   :target: https://pyup.io/repos/github/molssi-seamm/crystal_builder_step/
   :alt: Updates for Dependencies

.. |crystal6| image:: https://img.shields.io/pypi/v/crystal_builder_step.svg
   :target: https://pypi.python.org/pypi/crystal_builder_step
   :alt: PyPi VERSION

.. custom step badges

.. _custom_step: https://github.com/molssi-seamm/custom_step

.. |custom0| image:: https://img.shields.io/github/issues-pr-raw/molssi-seamm/custom_step
   :target: https://github.com/molssi-seamm/custom_step/pulls
   :alt: GitHub pull requests

.. |custom1| image:: https://github.com/molssi-seamm/custom_step/workflows/CI/badge.svg
   :target: https://github.com/molssi-seamm/custom_step/actions/workflows/CI.yaml
   :alt: Build Status

.. |custom2| image:: https://codecov.io/gh/molssi-seamm/custom_step/branch/master/graph/badge.svg
   :target: https://codecov.io/gh/molssi-seamm/custom_step
   :alt: Code Coverage

.. |custom3| image:: https://img.shields.io/lgtm/grade/python/g/molssi-seamm/custom_step.svg?logo=lgtm&logoWidth=18
   :target: https://lgtm.com/projects/g/molssi-seamm/custom_step/context:python
   :alt: Code Quality

.. |custom4| image:: https://github.com/molssi-seamm/custom_step/workflows/Documentation/badge.svg
   :target: https://github.com/molssi-seamm/custom_step/actions/workflows/Docs.yaml
   :alt: Documentation Status

.. |custom5| image:: https://pyup.io/repos/github/molssi-seamm/custom_step/shield.svg
   :target: https://pyup.io/repos/github/molssi-seamm/custom_step/
   :alt: Updates for Dependencies

.. |custom6| image:: https://img.shields.io/pypi/v/custom_step.svg
   :target: https://pypi.python.org/pypi/custom_step
   :alt: PyPi VERSION

.. dftb+ step badges

.. _dftbplus_step: https://github.com/molssi-seamm/dftbplus_step

.. |dftb0| image:: https://img.shields.io/github/issues-pr-raw/molssi-seamm/dftbplus_step
   :target: https://github.com/molssi-seamm/dftbplus_step/pulls
   :alt: GitHub pull requests

.. |dftb1| image:: https://github.com/molssi-seamm/dftbplus_step/workflows/CI/badge.svg
   :target: https://github.com/molssi-seamm/dftbplus_step/actions/workflows/CI.yaml
   :alt: Build Status

.. |dftb2| image:: https://codecov.io/gh/molssi-seamm/dftbplus_step/branch/master/graph/badge.svg
   :target: https://codecov.io/gh/molssi-seamm/dftbplus_step
   :alt: Code Coverage

.. |dftb3| image:: https://img.shields.io/lgtm/grade/python/g/molssi-seamm/dftbplus_step.svg?logo=lgtm&logoWidth=18
   :target: https://lgtm.com/projects/g/molssi-seamm/dftbplus_step/context:python
   :alt: Code Quality

.. |dftb4| image:: https://github.com/molssi-seamm/dftbplus_step/workflows/Documentation/badge.svg
   :target: https://github.com/molssi-seamm/dftbplus_step/actions/workflows/Docs.yaml
   :alt: Documentation Status

.. |dftb5| image:: https://pyup.io/repos/github/molssi-seamm/dftbplus_step/shield.svg
   :target: https://pyup.io/repos/github/molssi-seamm/dftbplus_step/
   :alt: Updates for Dependencies

.. |dftb6| image:: https://img.shields.io/pypi/v/dftbplus_step.svg
   :target: https://pypi.python.org/pypi/dftbplus_step
   :alt: PyPi VERSION

.. forcefield step badges

.. _forcefield_step: https://github.com/molssi-seamm/forcefield_step

.. |ffield0| image:: https://img.shields.io/github/issues-pr-raw/molssi-seamm/forcefield_step
   :target: https://github.com/molssi-seamm/forcefield_step/pulls
   :alt: GitHub pull requests

.. |ffield1| image:: https://github.com/molssi-seamm/forcefield_step/workflows/CI/badge.svg
   :target: https://github.com/molssi-seamm/forcefield_step/actions/workflows/CI.yaml
   :alt: Build Status

.. |ffield2| image:: https://codecov.io/gh/molssi-seamm/forcefield_step/branch/master/graph/badge.svg
   :target: https://codecov.io/gh/molssi-seamm/forcefield_step
   :alt: Code Coverage

.. |ffield3| image:: https://img.shields.io/lgtm/grade/python/g/molssi-seamm/forcefield_step.svg?logo=lgtm&logoWidth=18
   :target: https://lgtm.com/projects/g/molssi-seamm/forcefield_step/context:python
   :alt: Code Quality

.. |ffield4| image:: https://github.com/molssi-seamm/forcefield_step/workflows/Documentation/badge.svg
   :target: https://github.com/molssi-seamm/forcefield_step/actions/workflows/Docs.yaml
   :alt: Documentation Status

.. |ffield5| image:: https://pyup.io/repos/github/molssi-seamm/forcefield_step/shield.svg
   :target: https://pyup.io/repos/github/molssi-seamm/forcefield_step/
   :alt: Updates for Dependencies

.. |ffield6| image:: https://img.shields.io/pypi/v/forcefield_step.svg
   :target: https://pypi.python.org/pypi/forcefield_step
   :alt: PyPi VERSION

.. from SMILES step badges

.. _from_smiles_step: https://github.com/molssi-seamm/from_smiles_step

.. |smiles0| image:: https://img.shields.io/github/issues-pr-raw/molssi-seamm/from_smiles_step
   :target: https://github.com/molssi-seamm/from_smiles_step/pulls
   :alt: GitHub pull requests

.. |smiles1| image:: https://github.com/molssi-seamm/from_smiles_step/workflows/CI/badge.svg
   :target: https://github.com/molssi-seamm/from_smiles_step/actions/workflows/CI.yaml
   :alt: Build Status

.. |smiles2| image:: https://codecov.io/gh/molssi-seamm/from_smiles_step/branch/master/graph/badge.svg
   :target: https://codecov.io/gh/molssi-seamm/from_smiles_step
   :alt: Code Coverage

.. |smiles3| image:: https://img.shields.io/lgtm/grade/python/g/molssi-seamm/from_smiles_step.svg?logo=lgtm&logoWidth=18
   :target: https://lgtm.com/projects/g/molssi-seamm/from_smiles_step/context:python
   :alt: Code Quality

.. |smiles4| image:: https://github.com/molssi-seamm/from_smiles_step/workflows/Documentation/badge.svg
   :target: https://github.com/molssi-seamm/from_smiles_step/actions/workflows/Docs.yaml
   :alt: Documentation Status

.. |smiles5| image:: https://pyup.io/repos/github/molssi-seamm/from_smiles_step/shield.svg
   :target: https://pyup.io/repos/github/molssi-seamm/from_smiles_step/
   :alt: Updates for Dependencies

.. |smiles6| image:: https://img.shields.io/pypi/v/from_smiles_step.svg
   :target: https://pypi.python.org/pypi/from_smiles_step
   :alt: PyPi VERSION

.. LAMMPS step badges

.. _lammps_step: https://github.com/molssi-seamm/lammps_step

.. |lammps0| image:: https://img.shields.io/github/issues-pr-raw/molssi-seamm/lammps_step
   :target: https://github.com/molssi-seamm/lammps_step/pulls
   :alt: GitHub pull requests

.. |lammps1| image:: https://github.com/molssi-seamm/lammps_step/workflows/CI/badge.svg
   :target: https://github.com/molssi-seamm/lammps_step/actions/workflows/CI.yaml
   :alt: Build Status

.. |lammps2| image:: https://codecov.io/gh/molssi-seamm/lammps_step/branch/master/graph/badge.svg
   :target: https://codecov.io/gh/molssi-seamm/lammps_step
   :alt: Code Coverage

.. |lammps3| image:: https://img.shields.io/lgtm/grade/python/g/molssi-seamm/lammps_step.svg?logo=lgtm&logoWidth=18
   :target: https://lgtm.com/projects/g/molssi-seamm/lammps_step/context:python
   :alt: Code Quality

.. |lammps4| image:: https://github.com/molssi-seamm/lammps_step/workflows/Documentation/badge.svg
   :target: https://github.com/molssi-seamm/lammps_step/actions/workflows/Docs.yaml
   :alt: Documentation Status

.. |lammps5| image:: https://pyup.io/repos/github/molssi-seamm/lammps_step/shield.svg
   :target: https://pyup.io/repos/github/molssi-seamm/lammps_step/
   :alt: Updates for Dependencies

.. |lammps6| image:: https://img.shields.io/pypi/v/lammps_step.svg
   :target: https://pypi.python.org/pypi/lammps_step
   :alt: PyPi VERSION

.. Loop step badges

.. _loop_step: https://github.com/molssi-seamm/loop_step

.. |loop0| image:: https://img.shields.io/github/issues-pr-raw/molssi-seamm/loop_step
   :target: https://github.com/molssi-seamm/loop_step/pulls
   :alt: GitHub pull requests

.. |loop1| image:: https://github.com/molssi-seamm/loop_step/workflows/CI/badge.svg
   :target: https://github.com/molssi-seamm/loop_step/actions/workflows/CI.yaml
   :alt: Build Status

.. |loop2| image:: https://codecov.io/gh/molssi-seamm/loop_step/branch/master/graph/badge.svg
   :target: https://codecov.io/gh/molssi-seamm/loop_step
   :alt: Code Coverage

.. |loop3| image:: https://img.shields.io/lgtm/grade/python/g/molssi-seamm/loop_step.svg?logo=lgtm&logoWidth=18
   :target: https://lgtm.com/projects/g/molssi-seamm/loop_step/context:python
   :alt: Code Quality

.. |loop4| image:: https://github.com/molssi-seamm/loop_step/workflows/Documentation/badge.svg
   :target: https://github.com/molssi-seamm/loop_step/actions/workflows/Docs.yaml
   :alt: Documentation Status

.. |loop5| image:: https://pyup.io/repos/github/molssi-seamm/loop_step/shield.svg
   :target: https://pyup.io/repos/github/molssi-seamm/loop_step/
   :alt: Updates for Dependencies

.. |loop6| image:: https://img.shields.io/pypi/v/loop_step.svg
   :target: https://pypi.python.org/pypi/loop_step
   :alt: PyPi VERSION

.. MOPAC step badges

.. _mopac_step: https://github.com/molssi-seamm/mopac_step

.. |mopac0| image:: https://img.shields.io/github/issues-pr-raw/molssi-seamm/mopac_step
   :target: https://github.com/molssi-seamm/mopac_step/pulls
   :alt: GitHub pull requests

.. |mopac1| image:: https://github.com/molssi-seamm/mopac_step/workflows/CI/badge.svg
   :target: https://github.com/molssi-seamm/mopac_step/actions/workflows/CI.yaml
   :alt: Build Status

.. |mopac2| image:: https://codecov.io/gh/molssi-seamm/mopac_step/branch/master/graph/badge.svg
   :target: https://codecov.io/gh/molssi-seamm/mopac_step
   :alt: Code Coverage

.. |mopac3| image:: https://img.shields.io/lgtm/grade/python/g/molssi-seamm/mopac_step.svg?logo=lgtm&logoWidth=18
   :target: https://lgtm.com/projects/g/molssi-seamm/mopac_step/context:python
   :alt: Code Quality

.. |mopac4| image:: https://github.com/molssi-seamm/mopac_step/workflows/Documentation/badge.svg
   :target: https://github.com/molssi-seamm/mopac_step/actions/workflows/Docs.yaml
   :alt: Documentation Status

.. |mopac5| image:: https://pyup.io/repos/github/molssi-seamm/mopac_step/shield.svg
   :target: https://pyup.io/repos/github/molssi-seamm/mopac_step/
   :alt: Updates for Dependencies

.. |mopac6| image:: https://img.shields.io/pypi/v/mopac_step.svg
   :target: https://pypi.python.org/pypi/mopac_step
   :alt: PyPi VERSION

.. PACKMOL step badges

.. _packmol_step: https://github.com/molssi-seamm/packmol_step

.. |packmol0| image:: https://img.shields.io/github/issues-pr-raw/molssi-seamm/packmol_step
   :target: https://github.com/molssi-seamm/packmol_step/pulls
   :alt: GitHub pull requests

.. |packmol1| image:: https://github.com/molssi-seamm/packmol_step/workflows/CI/badge.svg
   :target: https://github.com/molssi-seamm/packmol_step/actions/workflows/CI.yaml
   :alt: Build Status

.. |packmol2| image:: https://codecov.io/gh/molssi-seamm/packmol_step/branch/master/graph/badge.svg
   :target: https://codecov.io/gh/molssi-seamm/packmol_step
   :alt: Code Coverage

.. |packmol3| image:: https://img.shields.io/lgtm/grade/python/g/molssi-seamm/packmol_step.svg?logo=lgtm&logoWidth=18
   :target: https://lgtm.com/projects/g/molssi-seamm/packmol_step/context:python
   :alt: Code Quality

.. |packmol4| image:: https://github.com/molssi-seamm/packmol_step/workflows/Documentation/badge.svg
   :target: https://github.com/molssi-seamm/packmol_step/actions/workflows/Docs.yaml
   :alt: Documentation Status

.. |packmol5| image:: https://pyup.io/repos/github/molssi-seamm/packmol_step/shield.svg
   :target: https://pyup.io/repos/github/molssi-seamm/packmol_step/
   :alt: Updates for Dependencies

.. |packmol6| image:: https://img.shields.io/pypi/v/packmol_step.svg
   :target: https://pypi.python.org/pypi/packmol_step
   :alt: PyPi VERSION


.. Psi4 step badges

.. _psi4_step: https://github.com/molssi-seamm/psi4_step

.. |psi4_0| image:: https://img.shields.io/github/issues-pr-raw/molssi-seamm/psi4_step
   :target: https://github.com/molssi-seamm/psi4_step/pulls
   :alt: GitHub pull requests

.. |psi4_1| image:: https://github.com/molssi-seamm/psi4_step/workflows/CI/badge.svg
   :target: https://github.com/molssi-seamm/psi4_step/actions/workflows/CI.yaml
   :alt: Build Status

.. |psi4_2| image:: https://codecov.io/gh/molssi-seamm/psi4_step/branch/master/graph/badge.svg
   :target: https://codecov.io/gh/molssi-seamm/psi4_step
   :alt: Code Coverage

.. |psi4_3| image:: https://img.shields.io/lgtm/grade/python/g/molssi-seamm/psi4_step.svg?logo=lgtm&logoWidth=18
   :target: https://lgtm.com/projects/g/molssi-seamm/psi4_step/context:python
   :alt: Code Quality

.. |psi4_4| image:: https://github.com/molssi-seamm/psi4_step/workflows/Documentation/badge.svg
   :target: https://github.com/molssi-seamm/psi4_step/actions/workflows/Docs.yaml
   :alt: Documentation Status

.. |psi4_5| image:: https://pyup.io/repos/github/molssi-seamm/psi4_step/shield.svg
   :target: https://pyup.io/repos/github/molssi-seamm/psi4_step/
   :alt: Updates for Dependencies

.. |psi4_6| image:: https://img.shields.io/pypi/v/psi4_step.svg
   :target: https://pypi.python.org/pypi/psi4_step
   :alt: PyPi VERSION

.. Read Structure step badges

.. _read_structure_step: https://github.com/molssi-seamm/read_structure_step

.. |structure0| image:: https://img.shields.io/github/issues-pr-raw/molssi-seamm/read_structure_step
   :target: https://github.com/molssi-seamm/read_structure_step/pulls
   :alt: GitHub pull requests

.. |structure1| image:: https://github.com/molssi-seamm/read_structure_step/workflows/CI/badge.svg
   :target: https://github.com/molssi-seamm/read_structure_step/actions/workflows/CI.yaml
   :alt: Build Status

.. |structure2| image:: https://codecov.io/gh/molssi-seamm/read_structure_step/branch/master/graph/badge.svg
   :target: https://codecov.io/gh/molssi-seamm/read_structure_step
   :alt: Code Coverage

.. |structure3| image:: https://img.shields.io/lgtm/grade/python/g/molssi-seamm/read_structure_step.svg?logo=lgtm&logoWidth=18
   :target: https://lgtm.com/projects/g/molssi-seamm/read_structure_step/context:python
   :alt: Code Quality

.. |structure4| image:: https://github.com/molssi-seamm/read_structure_step/workflows/Documentation/badge.svg
   :target: https://github.com/molssi-seamm/read_structure_step/actions/workflows/Docs.yaml
   :alt: Documentation Status

.. |structure5| image:: https://pyup.io/repos/github/molssi-seamm/read_structure_step/shield.svg
   :target: https://pyup.io/repos/github/molssi-seamm/read_structure_step/
   :alt: Updates for Dependencies

.. |structure6| image:: https://img.shields.io/pypi/v/read_structure_step.svg
   :target: https://pypi.python.org/pypi/read_structure_step
   :alt: PyPi VERSION

.. Set Cell step badges

.. _set_cell_step: https://github.com/molssi-seamm/set_cell_step

.. |set_cell0| image:: https://img.shields.io/github/issues-pr-raw/molssi-seamm/set_cell_step
   :target: https://github.com/molssi-seamm/set_cell_step/pulls
   :alt: GitHub pull requests

.. |set_cell1| image:: https://github.com/molssi-seamm/set_cell_step/workflows/CI/badge.svg
   :target: https://github.com/molssi-seamm/set_cell_step/actions/workflows/CI.yaml
   :alt: Build Status

.. |set_cell2| image:: https://codecov.io/gh/molssi-seamm/set_cell_step/branch/master/graph/badge.svg
   :target: https://codecov.io/gh/molssi-seamm/set_cell_step
   :alt: Code Coverage

.. |set_cell3| image:: https://img.shields.io/lgtm/grade/python/g/molssi-seamm/set_cell_step.svg?logo=lgtm&logoWidth=18
   :target: https://lgtm.com/projects/g/molssi-seamm/set_cell_step/context:python
   :alt: Code Quality

.. |set_cell4| image:: https://github.com/molssi-seamm/set_cell_step/workflows/Documentation/badge.svg
   :target: https://github.com/molssi-seamm/set_cell_step/actions/workflows/Docs.yaml
   :alt: Documentation Status

.. |set_cell5| image:: https://pyup.io/repos/github/molssi-seamm/set_cell_step/shield.svg
   :target: https://pyup.io/repos/github/molssi-seamm/set_cell_step/
   :alt: Updates for Dependencies

.. |set_cell6| image:: https://img.shields.io/pypi/v/set_cell_step.svg
   :target: https://pypi.python.org/pypi/set_cell_step
   :alt: PyPi VERSION

.. Solvate step badges

.. _solvate_step: https://github.com/molssi-seamm/solvate_step

.. |solvate0| image:: https://img.shields.io/github/issues-pr-raw/molssi-seamm/solvate_step
   :target: https://github.com/molssi-seamm/solvate_step/pulls
   :alt: GitHub pull requests

.. |solvate1| image:: https://github.com/molssi-seamm/solvate_step/workflows/CI/badge.svg
   :target: https://github.com/molssi-seamm/solvate_step/actions/workflows/CI.yaml
   :alt: Build Status

.. |solvate2| image:: https://codecov.io/gh/molssi-seamm/solvate_step/branch/master/graph/badge.svg
   :target: https://codecov.io/gh/molssi-seamm/solvate_step
   :alt: Code Coverage

.. |solvate3| image:: https://img.shields.io/lgtm/grade/python/g/molssi-seamm/solvate_step.svg?logo=lgtm&logoWidth=18
   :target: https://lgtm.com/projects/g/molssi-seamm/solvate_step/context:python
   :alt: Code Quality

.. |solvate4| image:: https://github.com/molssi-seamm/solvate_step/workflows/Documentation/badge.svg
   :target: https://github.com/molssi-seamm/solvate_step/actions/workflows/Docs.yaml
   :alt: Documentation Status

.. |solvate5| image:: https://pyup.io/repos/github/molssi-seamm/solvate_step/shield.svg
   :target: https://pyup.io/repos/github/molssi-seamm/solvate_step/
   :alt: Updates for Dependencies

.. |solvate6| image:: https://img.shields.io/pypi/v/solvate_step.svg
   :target: https://pypi.python.org/pypi/solvate_step
   :alt: PyPi VERSION

.. Supercell step badges

.. _supercell_step: https://github.com/molssi-seamm/supercell_step

.. |supercell0| image:: https://img.shields.io/github/issues-pr-raw/molssi-seamm/supercell_step
   :target: https://github.com/molssi-seamm/supercell_step/pulls
   :alt: GitHub pull requests

.. |supercell1| image:: https://github.com/molssi-seamm/supercell_step/workflows/CI/badge.svg
   :target: https://github.com/molssi-seamm/supercell_step/actions/workflows/CI.yaml
   :alt: Build Status

.. |supercell2| image:: https://codecov.io/gh/molssi-seamm/supercell_step/branch/master/graph/badge.svg
   :target: https://codecov.io/gh/molssi-seamm/supercell_step
   :alt: Code Coverage

.. |supercell3| image:: https://img.shields.io/lgtm/grade/python/g/molssi-seamm/supercell_step.svg?logo=lgtm&logoWidth=18
   :target: https://lgtm.com/projects/g/molssi-seamm/supercell_step/context:python
   :alt: Code Quality

.. |supercell4| image:: https://github.com/molssi-seamm/supercell_step/workflows/Documentation/badge.svg
   :target: https://github.com/molssi-seamm/supercell_step/actions/workflows/Docs.yaml
   :alt: Documentation Status

.. |supercell5| image:: https://pyup.io/repos/github/molssi-seamm/supercell_step/shield.svg
   :target: https://pyup.io/repos/github/molssi-seamm/supercell_step/
   :alt: Updates for Dependencies

.. |supercell6| image:: https://img.shields.io/pypi/v/supercell_step.svg
   :target: https://pypi.python.org/pypi/supercell_step
   :alt: PyPi VERSION

.. Table step badges

.. _table_step: https://github.com/molssi-seamm/table_step

.. |table0| image:: https://img.shields.io/github/issues-pr-raw/molssi-seamm/table_step
   :target: https://github.com/molssi-seamm/table_step/pulls
   :alt: GitHub pull requests

.. |table1| image:: https://github.com/molssi-seamm/table_step/workflows/CI/badge.svg
   :target: https://github.com/molssi-seamm/table_step/actions/workflows/CI.yaml
   :alt: Build Status

.. |table2| image:: https://codecov.io/gh/molssi-seamm/table_step/branch/master/graph/badge.svg
   :target: https://codecov.io/gh/molssi-seamm/table_step
   :alt: Code Coverage

.. |table3| image:: https://img.shields.io/lgtm/grade/python/g/molssi-seamm/table_step.svg?logo=lgtm&logoWidth=18
   :target: https://lgtm.com/projects/g/molssi-seamm/table_step/context:python
   :alt: Code Quality

.. |table4| image:: https://github.com/molssi-seamm/table_step/workflows/Documentation/badge.svg
   :target: https://github.com/molssi-seamm/table_step/actions/workflows/Docs.yaml
   :alt: Documentation Status

.. |table5| image:: https://pyup.io/repos/github/molssi-seamm/table_step/shield.svg
   :target: https://pyup.io/repos/github/molssi-seamm/table_step/
   :alt: Updates for Dependencies

.. |table6| image:: https://img.shields.io/pypi/v/table_step.svg
   :target: https://pypi.python.org/pypi/table_step
   :alt: PyPi VERSION
