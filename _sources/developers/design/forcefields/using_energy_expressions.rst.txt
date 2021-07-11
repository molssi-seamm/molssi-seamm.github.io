***************************
Using the Energy Expression
***************************

Now we turn our attention to the plug-in for the simulation code that wishes to use the
forcefield. There are two approaches to handling the previous steps of selecting and
setting up the forcefield and energy expression. The first approach is to keep it
separate from the simulation codes using the `forcefield_step` or a similar plug-in to
handle the forcefield setup. The advantage of this approach is that the forcefield setup
is global, so if a flowchart has several simulation steps using either the same code or
different ones, the user only has to setup the forcefield once and then all simulations
will use that setup. This approach reduces redundancy, inconsistencies, and errors.

The other approach is for the simulation plug-in to handle all the aspects of the
forcefield setup and use. This is clearly the preferred approach where the forcefield
is hidden from the user and captive to the simulation or only one forcefield is
usable. Examples where this would be a good approach might be

* for cleaning up poor structures, which might use a variety of algorithms and
  specialized to more general forcefields to progressively clean the structure.
* for a plug-in specialized to a certain property or class of structures where the
  results are tuned for a specific forcefield or group of forcefileds and the user has
  limited choice and control by design.
* for initial implementations of simulation engines using their native tools and files,
  though hopefully over time the implementation will be generalized to allow the users
  to use other forcefields with the engine, any forcefields sepcific to that engine with
  other codes.

If a plug-in is using forcefields provided by plug-ins in either of the two scenarios
then the plug-in first needs to verify that it can handle the requested forcefield, and
if so it needs to translate the generic SEAMM energy expression to the form needed.

Checking that the requested forcefiled can be handled is straightforward. The energy
expression provides metadata about the terms and their functional forms in the energy
expression. The plug-in needs to check that it can handle all of the terms and
functional forms. If not it needs to throw an appropriate error.

Once it is determined that the energy expression can be handled, the next step is to
translate the energy expression provide by SEAMM into the form the simulation code
uses. This is of course specific to the code being used, but in general it involves
creating an input file (e.g. LAMMPS) or a topology file (e.g. AMBER and GROMACS). This
is the main task of the plug-in, along with gethering and setting up the control
parameters for the simulation, e.g. the temperature, pressure, stepsize, length of
simulation, etc.

Once the simulation is setup the plug-in is responsible for running the calculation,
usually using the standard SEAMM framework, and then processing and analyzing the
results of the simulation, as needed.

The SEAMM cookiecutter will provide initial versions of the files need to the plug-in,
along with much of the code for e.g. running the calculation. You task as a developer
will be to tweak some of the details, such as the executables to run, and fill out the
code with the specific translation and analysis needed for the simulation.
