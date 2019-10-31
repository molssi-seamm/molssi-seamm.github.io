****************
A Home for Tools
****************

You've written the latest and greatest code for a particular
task. Perhaps it is a large code like an MD code or a DFT code or
perhaps it is more focused code for analyzing results, driving other
codes for e.g. advanced sampling, or trained a model using machine
learning. Congratulations! It is quite an accomplishment.

But how do you get it in the hands of other people, so they can use
it?

If it is a capable, standalone code that solves the entire problem,
maybe it doesn't need much help. But if it is a code that works with
other codes -- driving them, analyzing their results, etc. or is
e.g. an ML model that is a surrogate for a more expensive method, but
users will ocasionally need to check the results or even do a bit more
training, then you life is more complicated. You might need to choose
one code and integrate yours into its environment. Or try to write
translators so that it can work with several codes.

Or you can put it into SEAMM as a plug-in, which is quite
straightforward, and connect with the other codes that are in SEAMM,
using the translators already in SEAMM. At worst, there is not much
already in SEAMM that is helpful and you have to do the wrok you would
have anyway. But hopefully at there are several useful codes already
in SEAMM, and you don't have to do much work.

Either way, if you put your code into the SEAMM environment, all of
the users of SEAMM can see it and use it. And because you made it easy
to use, and published some example flowcharts, they will have an
easier time getting started. You did do that, right? And in the
future, as other developers add codes to SEAMM, they will work with
yours with little or no extra work.

This is good for you, and good for users. Everyone wins.
