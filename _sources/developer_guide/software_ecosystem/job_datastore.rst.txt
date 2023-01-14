.. _job-datastore:

*************
Job Datastore
*************

The Job Datastore is where SEAMM stores all input and output files
produced from each :term:`job`. The :term:`dashboard` is the primary
way to inspect the job results. However, it is also possible to inspect
each file directly.

The datastore gathers the results of multiple projects but allow users to control the
access permissions to the projects, including the individual jobs. Thus, a single
datastore and the projects it contains can be shared by different groups of users with
complete control over who can see, change, and add to each project.

In collaborative efforts, the users might wish to use the datastores residing
on a remote machine. It may also be more practical to have a datastore "closer"
to where the jobs are executed so that the outputs do not have to be
copied over a slow network route.
