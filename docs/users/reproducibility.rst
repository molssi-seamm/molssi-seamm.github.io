.. _reproducibility:

*********************************
Reproducibility and Replicability
*********************************

The Productivity_ section mentioned that the
:term:`flowcharts<flowchart>` are reusable and shareable. Let's look
into that a bit more, because it is a much more powerful feature than
is perhaps obvious at first glance. But before that, let's define some
terms, because there is a lot of confusion in the literature and
common usage. We will follow the National Academies of Sciences report
`Reproducibility and Replicability in Science`_

Reproducibility
   is obtaining consistent results using the same input data,
   computational steps, methods, and code, and conditions of
   analysis. This definition is synonymous with “computational
   reproducibility”.

Replicability
   is obtaining consistent results across studies aimed at answering
   the same scientific question, each of which has obtained its own
   data. Two studies may be considered to have replicated if they
   obtain consistent results given the level of uncertainty inherent
   in the system under study.

Generalizability
  another term frequently used in science, refers to the extent that
  results of a study apply in other contexts or populations that
  differ from the original one.


Reproducibility
---------------
How does SEAMM help with this? Flowcharts are reproducible, by
definition. If you run a flowchart twice on the same system or
systems, it will replicate the steps identically. Provided the steps
themselves are deterministic, then the entire workflow will create
identical results. Of course, many codes give slightly different
results if run on different numbers of cores, or between versions, in
which case the results will be similar but not identical.

Some algorithms, such as molecular dynamics and Monte Carlo methods,
depend on random numbers for initialization, in which case the
simulation will differ in detail unless the random numbers are the
same. Normally you'd actually like separate runs to be different, so
the codes usually set the seed for the random number generator
randomly. In this case, while the physical results of duplicate runs
should be identical within the statistical error bars, the details
including the trajectory will be quite different. It is a good
practice for the :term:`plug-ins<plug-in>` to ensure that the seed
actually used is printed, and the setup allows you to specifiy the
seed so that you can indeed reproduce the run. Whether the plug-ins
follow this advice is up to them, not SEAMM.

Replicability
-------------
SEAMM does not guarantee replicability -- after all, replicability
implies that two different people or groups tackle the same scientific
problem, but don't share e.g. flowcharts. Nonetheless, SEAMM and the
plug-ins can help a great deal. Because plug-ins simplify and clarify
the input to the underlying codes, and should provide guidance to
which parameters are relevant as well as provide use default values
where possible, it is more likely that independent researchers will
use similar, reasonable settings. Even if using different codes, the
plug-ins still insulate users from more of the detail, and provide the
concepts of the code in a more general way. This helps!

If people share flowcharts -- particulalrly if experts publish
flowcharts that emobdy their knowlege and experience, replicability
can be achieved through reproducibility and generalizability. For
example, if an expert publishes a flowchart to calculate e.g. the
viscosity of fluids using LAMMPS, and another expert publishes a
flowchart using GROMACS, they almost certainly will get comparable
results. After all, they are experts! You can then use one of the
flowcharts for different fluids and are likely to also get good
results. Another researcher starting for the same flowchart as you, or
the one using the other code, is still quite likely to replicate your
results.

Generalizability
----------------
This is the area where SEAMM really shines. The flowcharts and
plug-ins are designed with this in mind, so where possible flowcharts
can be applied to similar molecules. Obviously you can't extend
calculations to far. You can't calculate the elastic properties, which
are property of solids, for fluids or individual molecules. If the
forcefield doesn't have parameters for the elements or functional
groups in the new molecule, or a quantum chemistry code doesn't have
basis sets for an element, the flowchart won't work. But for similar
enough molecules it will. And with care, flowcharts can be quite
general. 

  
.. _Productivity: /html/productivity.html
.. _Reproducibility and Replicability in Science: https://www.nap.edu/catalog/25303/reproducibility-and-replicability-in-science
