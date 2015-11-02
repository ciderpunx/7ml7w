> Parallel for loops dispatch loop bodies to other processes. Depending on the size of the loop body, this can have a noticeable overhead. See if you can beat Julia&#8217;s parallel for loop version of pflip_coins by writing something using the lower-level primitives like @spawn or remotecall.

I wasn&#8217;t able to have a major impact on execution time &mdash; the variance between runs was more than any saving in time over the original function. However taking a more functional approach allowed me to use significantly less memory. The code is a little more complex syntactically and there is a potential bug if the test number is not divisible by 4 (I found that running 4 processes gave me the best results). 

I suppose that the saving is because of the count_flip function body being added to the global environment with @everywhere but I don&#8217;t have any evidence for this.

Incidentally an optimization that sometimes works in Haskell &mdash; combining the functions in the 2 maps into one map with 2 functions in it &mdash; which in this case would mean composing fetch and spawn in the same map call actually made things somewhat slower.

<p><code>julia&gt; @everywhere function count_flip(n)
                       count = 0
                       for i in 1:n
                           count += int(randbool())
                       end
                       count
                    end

julia&gt; function mycoins(n)
            sum( map( fetch, map(x -&gt; (@spawn count_flip(n/4)), 2:5) ) )
       end
mycoins (generic function with 1 method)

julia&gt; @time pflip_coins(1000000000)
elapsed time: 2.150548463 seconds (6429340 bytes allocated)
500020611

julia&gt; @time pflip_coins(1000000000)
elapsed time: 1.713294895 seconds (183048 bytes allocated)
499988013

julia&gt; @time mycoins(1000000000)
elapsed time: 1.681171545 seconds (20912 bytes allocated)
444429739

julia&gt; @time mycoins(1000000000)
elapsed time: 1.638956568 seconds (18944 bytes allocated)
444437840</code></p>
