.. _flowchart:

*********
Flowchart
*********

A :term:`flowchart` is a simple way to represent a workflow or
protocol for accomplishing something. SEAMM is designed for
computational molecular and materials science, so the
:term:`steps<step>` in a SEAMM flowchart correspond to the
types of things we do. For example, a very simple workflow might be to
create a structure from a SMILES string and optimize the structure
using :term:`DFT` or a more advanced quantum chemical method. The simple
flowchart to do this would have two steps:

.. figure:: /images/dft_flowchart.png
   :align: center
   :scale: 50 %
   :alt: A Simple Flowchart

   A Simple Flowchart

Of course such flowcharts can be much more
complicated. Even in this simple case, if the starting structure is
bad, the DFT calculation might not converge. A more complex
workflow would catch this error and perhaps try a simple, more robust
method to clean up the initial structure, and then run the DFT
optimization again.

The flowcharts in SEAMM can be converted to plain
text -- a process known as `serialization 
<https://en.wikipedia.org/wiki/Serialization>`_ in computer science.
This is important because it lets you and SEAMM do many useful things.
It allows SEAMM to store the flowchart in the :term:`job datastore` and
ship it to other machines when you want to run a :term:`job`. For you
it means that you can save a flowchart to a file, edit it later, email
it to a colleague so they can use it, etc.