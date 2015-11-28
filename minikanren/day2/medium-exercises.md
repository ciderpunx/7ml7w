#### Medium exercises

> Using the database from yesterday, create *unsungo*, which takes a list of computer scientists and succeeds if none of them have won Turing Awards . *conda* may prove useful.

It wasn&#8217;t entirely clear to me what exactly succeeding ought to mean in this case. I did the simplest thing I could think of and called the succeed function. 

This is really just a simple recursive function &mdash; if the head of the list is empty then we have got to the end and we can succeed. If the head is a Turing award winner, then we fail. And otherwise we recurse into the tail of the list.

<p><code class="clojure">(defn unsungo [l a]
  (fresh [h t y]
    (conda
      [(all
        (== () l)
        (== a (succeed a)))]
      [(all
        (conso h t l)
        (turingo h y)
        (== a (fail a) ))]
      [(all
        (conso h t l)
        (unsungo t a))])))</code></p>

And the output.

<p><code class="clojure">user=&gt; (with-db facts (run* [q] (unsungo [:grace-hopper :ada-lovelace :leslie-lamport]  q )))
(nil)
user=&gt; (with-db facts (run* [q] (unsungo [:grace-hopper :ada-lovelace]  q )))
(&#95;0)</code></p>
