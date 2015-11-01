> The parallel computing part of the Julia manual (specifically @spawn, @everywhere)

http://docs.julialang.org/en/release-0.4/manual/parallel-computing/

@spawn -- like remotecall in that it returns a remote reference, given an expression (not a function). It picks where the op happens for you.

@everywhere makes a command run on all processes (could use with remotecall_fetch which is more performant than doing fetch(remotecall(n)))

> Wikipedia page on multiple dispatch
