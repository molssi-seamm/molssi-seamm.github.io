.. _`job-datastore`:

*************
Job Datastore
*************

The Job Datastore is where SEAMM stores all input and output files
produced from each :term:`job`. The :term:`dashboard` is the primary
way to inspect the job results. However, it is also possible to inspect
each file directly.

The users can also employ several Job Datastores on a single machine
so that different user-groups can access them. While the datastores
gather the results of each project, they allow users to control the access
permission(s) to the projects including the individual jobs. Thus, a
single datastore can be shared among different user-groups if they wish
to do so.

In collaborative efforts, the users might wish to use the datastores residing
on a remote machine. It would also be more practical to have a datastore "closer"
to where the jobs are executed so that the outputs do not have to be
copied over a slow network route.