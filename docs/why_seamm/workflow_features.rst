.. _workflow-features:

*****************
Workflow Features
*****************

In the previous section, we pointed out that :term:`flowcharts<flowchart>`
promote reusability and reproducibility. Flowcharts offer two other nontrivial
but powerful features: replicability and generalizability. In the present 
discussion, we will also include reproducibility due to its importance and close
relation to the two aforementioned concepts.

Before proceeding with the details, let us formally define reproducibility,
replicability and generalizability following the definitions presented in the
National Academies of Sciences report `Reproducibility and Replicability in Science 
<https://www.nap.edu/catalog/25303/reproducibility-and-replicability-in-science>`_.

Reproducibility
   is obtaining consistent results using the same input data,
   computational steps, methods, and code, and conditions of
   analysis. This definition is synonymous with `computational
   reproducibility`.

Replicability
   is obtaining consistent results across studies aimed at answering
   the same scientific question, each of which has obtained its own
   data. Two studies may be considered to have replicated if they
   obtain consistent results given the level of uncertainty inherent
   in the system under study.

Generalizability
  refers to the extent that results of a study apply in other contexts
  or populations that differ from the original one.


Reproducibility
---------------
Flowcharts are reproducible objects which replicate an identical set of
steps if executed twice on the same or two separate machines. Provided
that the steps themselves are deterministic, the entire workflow will 
yield identical results. On parallel executions using multiple processors
or adopting different versions, the results will likely be similar within 
an estimated level of certainty but not identical.

A variety of computational tasks such as training neural networks,
molecular dynamics simulations and Monte Carlo methods, depend on
random numbers for (pre-)initialization of data. These types of
simulations will differ in details unless the seeding random number is
fixed. In this case, the physical results of duplicate runs should be 
identical in the statistical sense despite having different trajectories. 
The developers of SEAMM :term:`plug-ins<plug-in>` are encouraged 
to ensure the reproducibility of the results by printing the adopted 
seed values in the output and allowing users to modify them, when necessary.

Replicability
-------------
SEAMM relies on plug-ins for the realization of replicability without
providing any guarantees. Plug-ins simplify and clarify the inputs 
to the underlying simulation engines. Furthermore, plug-ins guide 
the relevance of available key parameters adopted in each simulation
while pre-initializing them to reasonable default values.

The usage of flowcharts published by experts in the public domains
will promote replicability through reproducibility and generalizability.
For example, if a professional scientist publishes a flowchart that
calculates the viscosity of a fluid using LAMMPS and another
expert publishes a flowchart to compute the same property using GROMACS,
it is very likely that they will get comparable results. Any researcher
can then import one of the flowcharts in SEAMM and adopt it to study
the properties of a different fluid and get high quality results.
You might want to share your flowchart with a collaborator to be able 
to replicate your results independently.

Generalizability
----------------
Generalizability is one of the superpowers of SEAMM that stems from
the existence of flowcharts and plug-ins. For instance, a flowchart
that calculates a specific properties of a group of small organic
molecules, can also be used to study the a distinct group of organic
molecules of medium to large sizes. That being said, the applicability
of the flowcharts cannot be extended too much towards performing
calculations far outside their original scope. For example, one cannot
use flowcharts that are built to calculate the elastic properties of
solids to fluids or isolated molecules. If the force-field does not
have the parameters associated to the elements or functional groups
in the target molecule(s) or a quantum chemistry code does not have
basis sets for a particular element, the flowchart will not be functional.