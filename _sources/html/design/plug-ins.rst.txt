********
Plug-ins
********

The plug-ins are composed from three parts:

   1. Parameters: the control parameters for the method implemented by
      the plug-in.
   2. Executable core: the implementation that takes the control
      parameters and does the work.
   3. Graphical User Interface (GUI): the implementation of the GUI
      that the user can use to adjust the parameters.

Each of these parts is subclassed from the appropriate base class
provided by SEAMM, which ensure consistency amongst plug-ins and also
minimizes the work for developers. They only need implement the parts
that make their plugin different. This structure looks like this:

.. figure:: //source/images/Plug-in_UML.png
   :align: center
   :alt: UML diagram for plug-ins
   :figclass: align-center

   UML Diagram of a Plug-in

The classes with **<plug-in>** in the name are the specializations of
the base class supplied with SEAMM. For example, while **Parameters**
is a perfectly useable class, **<plug-in>Parameters**,
e.g. **LAMMPSParameters** is a specialization that sets up the
specific parameters for the module, with their defaults, etc. when it
is instantiated.

Requirements
############

1. **Parameters** must be serializable, that is the object provide a
   method to transform it to a text format such as json, and it must
   be possible to reconstruct the instance from the serialized
   representation.

#. Individual **Parameter** instances must contain meta-data defining
   the type or  *kind* of values, e.g. integer, float, string or
   enumeration. 

#. Whilst a **Parameter** may have a defined *kind* such as integer,
   it must be capable of storing an enumerated value or a mathematical
   equation instead of a specific value.

   a. An enumerated value allows e.g. a convergence criterion to be
      either a numerical value, or a predefined value such as
      'normal', 'tight' or 'loose'.

   #. Mathematical equations -- at least basic ones -- allow
      substitution with either a variable, e.g. 'T' or an expression
      such as 'T + 20' at some point in the execution of the plugin,
      implicitly replacing the parameters with either a numerical
      value (if it is numerical, like 'T') or one of the enumerated
      values.

#. A plugin needs, when it executes, to be able to run in its own
   unique environment.

#. If a plugin executes one or more standalone executables, each
   executbale must have the possibility of executing in its own,
   separate standalone environment. Two or more plugins may share
   executables and their environments, or may require different
   versions and environments for the same executable.

#. Mechanisms must be provided to locate both the plugins and any
   other standalone executables that they use.

#. A mechanism and approach needs to be defined and implemented for
   access both the molecular system(s) needed by the plug-in, and for
   auxilliary information such as basis sets and forcefields. Although
   these might be considered as control parameters they are
   sufficiently large and commonly used so as to warrant special
   handling.

#. A mechanism for returning data from the plugin to the entity that
   executed it must be defined and provided. At a minimum this should
   be able to handle file-based transfer of the data.

