.. _2020_general_improvements:

********************
General Improvements
********************

Goals and Motivation
--------------------
We can always improve SEAMM -- the installation, the functionality in
:term:`flowcharts<flowchart>`, how you run :term:`jobs<job>` and look
at the results -- no matter which part you are using today, you can
probably see ways to make it better and easier, so you can do your
work better. Often several such improvements go together to make some
major piece of functionality better, or they are tied together by a
specific project. In such cases, we try to put them together in a
subproject.

However, sometime there is an improvement here, another one there, and
yet another over there, with no obvious relationship between
them. This is the place for those general improvements that don't fit
elsewhere.


Tasks:
------
1. Develop an **Input** :term:`plug-in` to provide both a GUI for
   setting variables as well as commandline argument definitions.
#. Serialization of the execution state within an executing
   flowchart. The "execution state" is the collection of
   variables created by and used by the plug-ins in the
   flowchart. This includes the molecular system object, which is
   stored in a global variable in the execution state.
#. Restart in flowcharts, at the granularity of the plug-ins. This
   requires storing the execution state between executing plug-ins,
   along with the location in the flowchart.

Results and Discussion
----------------------

