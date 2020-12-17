.. _`Job Datastore`:

*************
Job Datastore
*************

The Job Datastore is where SEAMM stores all the input and output from
:term:`jobs<job>`. The :term:`Dashboard` is the primary way that you
look at the jobs, though it is possible to look at the files directly
if you need to, and it may be possible for a job to scan files from
others jobs. This is useful if you want to gather and reanalyze
results from many jobs after they have been run.

You may also use several Job Datastores. There can be more than one on
a machine, so different users or groups might have different
datastores. However datastores gather results in projects, and allow
control over who can access projects or even individual jobs, so a
sinlge datastore can be shared my different people and groups if they
wish.

You might also use datastores on other machines, either because you
are collaborating with another group andwant to use their datastore,
or because it is more practical to have a datastore "close" to where
the jobs are run so that the outputs don't have to be copied over
e.g. a slow network.
