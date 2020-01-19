.. _validation_of_statistical_analysis_2020:

********************************************
Validation of Statistical Analysis for MD/MC
********************************************

Goals and Motivation
--------------------
Well documented, tested statistical analysis is a cornerstone of
science, and is extremely relevant to molecular dynamics (MD) and
Monte Carlo (MC) simulations in our field. However, our field is not
terribly fluent in statistical analysis, and many codes do at best a
partial job of the analysis. Therefore it is is important for SEAMM to
provide a convenient library for plugins, examples of implementation,
and approaches and flowcharts for testing implementations.

Tasks
-----
1. Figure out how to test!

   a. Are there standard, known datasets to use?
   #. Test using another code, such as R?
   #. Is it viable to run e.g. 100 simulations, using the simple
      statistics of the results to test the implementation within one
      run?
      
Results and Discussion
----------------------
