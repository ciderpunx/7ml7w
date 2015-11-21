#### Easy exercises

> Try running a logic program that has 2 membero goals, both with q as the first argument. What happens when the same element exists in both collections?

I wasn&#8217;t quite sure what this was after, so I did the simplest possible thing. Clearly q ought to be the thing that is in both collections whether that is an element, an whole collection or nothing, and that is indeed how it behaves.

<p><code class="clojure">user=&gt; (run\* [q] (membero q [1 2 3]) (membero q [3 4 5]))
(3)
user=&gt; (run\* [q] (membero q [1 2 3]) (membero q [1 2 3]))
(1 2 3)
user=&gt; (run\* [q] (membero q [1 2 3]) (membero q [6 6 6]))
()</code></p>


> *appendo* is a *core.logic* built-in that will append 2 lists. Write some logic programs similar to the membero examples to get a feel for how it works. Be sure to use *q* in each of the argument positions to see what happens.

<p><code class="clojure">
</code></p>
