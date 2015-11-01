> Parallel for loops dispatch loop bodies to other processes. Depending on the size of the loop body, this can have a noticeable overhead. See if you can beat Julia&#8217;s parallel for loop version of pflip_coins by writing something using the lower-level primitives like @spawn or remotecall

I couldn&#8217;t get much faster on time, but my approach did use significantly less memory. Interesting.

<p><code>julia&gt; function mycoins(n)
            sum( map( fetch, map(x -&gt; (@spawn count_flip(n/9)), 1:9) ) )
       end
mycoins (generic function with 1 method)

julia&gt; @time mycoins(1000000000)
elapsed time: 1.798543472 seconds (80364 bytes allocated)
500006291

julia&gt; @time mycoins(1000000000)
elapsed time: 1.794355376 seconds (47740 bytes allocated)
500005100

julia&gt; @time pflip_coins(1000000000)
elapsed time: 1.785307556 seconds (164068 bytes allocated)
500007620</code></p>
