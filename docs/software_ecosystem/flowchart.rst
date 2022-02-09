.. _flowchart:

*********
Flowchart
*********

A :term:`flowchart` is a key concept in SEAMM to represent a workflow.
Because SEAMM is designed to host a wide variety of computational molecular
and materials science simulation engines, flowcharts are designed in a
way that can handle a variety of subjects and tasks within each :term:`step`.
An example of a very simple workflow might involve the creation of a chemical
structure from SMILES and its optimization using :term:`DFT` or any other
advanced quantum chemical method. The aforementioned simple two-step flowchart
would look like the following:

.. figure:: /images/dft_flowchart.png
   :align: center
   :scale: 50 %
   :alt: A Simple Flowchart

   A Simple Flowchart

Of course, due to the flexibility of the flowcharts, they can handle
much more complicated workflows. In the simple case illustrated above,
a non-physical initial geometry can lead to the numerical divergence
of the iterative DFT calculation. A more complex workflow can be designed to
be able to catch this error or pre-optimize the geometry at a lower level
before preforming the final DFT optimization step.

The flowcharts in SEAMM can be converted to plain text -- a process known
as `serialization <https://en.wikipedia.org/wiki/Serialization>`_.
Serialization allows SEAMM to store the flowcharts in the 
:term:`job datastore` and ship them to users. As such, flowcharts can be
stored (as a text file), modified, or shared with a colleague so they can
use them in their own research workflow(s).