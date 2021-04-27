**********************
Selecting a Forcefield
**********************

This discussion is limited to the mechanics of presenting forcefields to the user so
that they can select one. It is **not** a discussion of which forcefield to choose, the
scientific merits of different forcefields, etc. That is a vastly large and more
complicated topic which we can't answer well at all. So let's stick to what we can!

As noted in the `plugin_anatomy`_ section, the forcefield handlers or interfaces to
simulation codes can use the entry points in the `org.molssi.seamm.forcefields`
namespace to locate the implemented forcefeilds. They can interrogate each for it
metadata using the `description` method. With this information the handlers can filter
the list for appropriate forcefields and, if desired, present a list to the user along
with more in-depth descriptions to help the user choose the forcefield they wish.

.. todo:: This needs to be implemented in the forcefield step.
