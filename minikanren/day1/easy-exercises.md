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

Oh nice. It can work out what input would be required to create the list in the final place.

<p><code class="clojure">user=&gt; (run\* [q] (appendo [1 2] [3 4] q))
((1 2 3 4))
user=&gt; (run\* [q] (appendo [1 2] q [3 4]))
()
user=&gt; (run\* [q] (appendo q [1 2] [3 4]))
()
user=&gt; (run\* [q] (appendo [1 2] q [1 2 3 4]))
((3 4))
user=&gt; (run\* [q] (appendo q [3 4] [1 2 3 4]))
((1 2))
user=&gt; (run\* [q] (appendo q [1 2] [1 2 3 4]))
()</code></p>

> Create *languageo* and *systemo* database relations and add the relevant facts based on what category bst classifies the person&#8217;s work.

Here is the data base setup form the book. I added some extra gender identities.

<p><code class="clojure">user=&gt; (use 'clojure.core.logic.pldb)
nil
user=&gt; (db-rel mano x)
#'user/mano
user=&gt; (db-rel womano x)
#'user/womano
user=&gt; (db-rel transo x)
#'user/transo
user=&gt; (db-rel intersexo x)
#'user/intersexo
user=&gt; (db-rel genderqueero x)
#'user/genderqueero
user=&gt; (db-rel vitalo p s)
#'user/vitalo
user=&gt; (db-rel turingo p y)
#'user/turingo
user=&gt; (db-rel languageo p l)
#'user/languageo
user=&gt; (db-rel systemo p m)
#'user/systemo
user=&gt; (def facts
  #\_=&gt;   (db
  #\_=&gt;     [mano :alan-turing]
  #\_=&gt;     [womano :grace-hopper]
  #\_=&gt;     [transo :laverne-cox]
  #\_=&gt;     [mano :leslie-lamport]
  #\_=&gt;     [mano :alonzo-church]
  #\_=&gt;     [womano :ada-lovelace]
  #\_=&gt;     [womano :barbara-liskov]
  #\_=&gt;     [womano :frances-allen]
  #\_=&gt;     [mano :john-mccarthy]))
#'user/facts
user=&gt; (def facts
  #\_=&gt;   (-> facts
  #\_=&gt;     (db-fact vitalo :alan-turing :dead)
  #\_=&gt;     (db-fact vitalo :grace-hopper :dead)
  #\_=&gt;     (db-fact vitalo :laverne-cox :alive)
  #\_=&gt;     (db-fact vitalo :leslie-lamport :alive)
  #\_=&gt;     (db-fact vitalo :alonzo-church :dead)
  #\_=&gt;     (db-fact vitalo :ada-lovelace :dead)
  #\_=&gt;     (db-fact vitalo :barbara-liskov :alive)
  #\_=&gt;     (db-fact vitalo :frances-allen :alive)
  #\_=&gt;     (db-fact vitalo :john-mccarthy :dead)
  #\_=&gt;     (db-fact turingo :leslie-lamport :2013)
  #\_=&gt;     (db-fact turingo :barbara-liskov :2008)
  #\_=&gt;     (db-fact turingo :john-mccarthy :1971)
  #\_=&gt;     (db-fact turingo :frances-allen :2006)))</code></p>

Now that I have that base, adding some extra facts is pretty trivial (note that I set up the relations already).

<p><code class="clojure">#'user/facts
user=&gt; (def facts
  #\_=&gt;   (-> facts
  #\_=&gt;     (db-fact languageo :alan-turing :turing)
  #\_=&gt;     (db-fact languageo :grace-hopper :cobol)
  #\_=&gt;     (db-fact languageo :grace-hopper :fortran)
  #\_=&gt;     (db-fact languageo :leslie-lamport :tla)
  #\_=&gt;     (db-fact languageo :alonzo-church :lambda-calculus)
  #\_=&gt;     (db-fact languageo :ada-lovalace :note-g)
  #\_=&gt;     (db-fact languageo :barbara-liskov :clu)
  #\_=&gt;     (db-fact languageo :frances-allen :fortran)
  #\_=&gt;     (db-fact languageo :frances-allen :autocoder)
  #\_=&gt;     (db-fact languageo :john-mccarthy :lisp)
  #\_=&gt;     (db-fact systemo :alan-turing :pilot-ace)
  #\_=&gt;     (db-fact systemo :alan-turing :bombe)
  #\_=&gt;     (db-fact systemo :alan-turing :turing-machine)
  #\_=&gt;     (db-fact systemo :grace-hopper :univac)
  #\_=&gt;     (db-fact systemo :ada-lovelace :analytical-engine)
  #\_=&gt; ))</code></p>

And now I can find living women who worked on CLU or the languages of all living folk in the database.

<p><code class="clojure">#'user/facts
user=&gt; (with-db facts
  #\_=&gt;   (run\* [q]
  #\_=&gt;     (womano q)
  #\_=&gt;     (vitalo q :alive)
  #\_=&gt;     (languageo q :clu)))
(:barbara-liskov)
user=&gt; (with-db facts
  #\_=&gt;   (run\* [q]
  #\_=&gt;     (fresh [p l]
  #\_=&gt;       (vitalo p :alive)
  #\_=&gt;       (languageo p l)
  #\_=&gt;       (== q [p l]))))
([:frances-allen :fortran] [:frances-allen :autocoder] [:barbara-liskov :clu] [:leslie-lamport :tla]) </code></p>
