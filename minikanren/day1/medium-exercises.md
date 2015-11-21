#### Medium exercises

> Use *conde* to create *scientisto*, which suceeds for any of the men or women.

This was quite a hard exercise until I realized it actually wasn&#8217;t. We are just making a relation that is either man or woman. And that is pretty much what you write. Albeit in a Lisp-ish manner.

<p><code class="clojure">user=&gt; (defn scientisto [e]
  #\_=&gt;   (conde
  #\_=&gt;     [(womano e)]
  #\_=&gt;     [(mano e)]
  #\_=&gt; ))
#'user/scientisto
user=&gt; (with-db facts (run\* [q] (scientisto q)))
(:grace-hopper :leslie-lamport :frances-allen :john-mccarthy :barbara-liskov :alonzo-church :ada-lovelace :alan-turing)</code></p>

> Construct a logic program that finds all the scientists who&#8217;ve won Turing Awards.

This seemed straightword enough and worked right away.

<p><code class="clojure">
user=&gt; (with-db facts
  #\_=&gt;   (run\* [q]
  #\_=&gt;     (fresh [p y]
  #\_=&gt;       (turingo p y)
  #\_=&gt;       (== q [p y]))))
([:leslie-lamport :2013] [:barbara-liskov :2008] [:frances-allen :2006] [:john-mccarthy :1971])
</code></p>
