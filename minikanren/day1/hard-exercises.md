> Create a genealogy system using a family tree database and relations like *childo* and *spouseo*. Then write functions that can traverse the tree like *ancestro*, *descendanto*, and *cousino*.

Creating the database for this was boring work. I am not sure that I need both parent and child relationships. Well, whatever.

<p><code class="clojure">user=&gt; (db-rel childo p c)
#'user/childo
user=&gt; (db-rel spouseo p s)
#'user/spouseo
user=&gt; (db-rel parento p r)
#'user/parento
user=&gt; (db-rel persono p)
#'user/persono
user=&gt; (def family
  #\_=&gt;   (db
  #\_=&gt;     [persono :fred-flintstone]
  #\_=&gt;     [persono :wilma-flintstone]
  #\_=&gt;     [persono :barney-rubble]
  #\_=&gt;     [persono :betty-rubble]
  #\_=&gt;     [persono :bamm-bamm-rubble]
  #\_=&gt;     [persono :pebbles-flintstone]
  #\_=&gt;     [persono :roxy-rubble]
  #\_=&gt;     [persono :chip-rubble]
  #\_=&gt;
  #\_=&gt;     [spouseo :fred-flintstone :wilma-flintstone]
  #\_=&gt;     [spouseo :barney-rubble :betty-rubble]
  #\_=&gt;     [spouseo :pebbles-flintstone :bamm-bamm-rubble]
  #\_=&gt;
  #\_=&gt;     [parento :chip-rubble :pebbles-flintstone]
  #\_=&gt;     [parento :chip-rubble :bamm-bamm-rubble]
  #\_=&gt;     [childo :pebbles-flintstone :chip-rubble]
  #\_=&gt;     [childo :bamm-bamm-rubble :chip-rubble]
  #\_=&gt;
  #\_=&gt;     [parento :roxy-rubble :pebbles-flintstone]
  #\_=&gt;     [parento :roxy-rubble :bamm-bamm-rubble]
  #\_=&gt;     [childo :bamm-bamm-rubble :roxy-rubble]
  #\_=&gt;     [childo :pebbles-flintstone :roxy-rubble]
  #\_=&gt;
  #\_=&gt;     [parento :bamm-bamm-rubble :barney-rubble]
  #\_=&gt;     [parento :bamm-bamm-rubble :betty-rubble]
  #\_=&gt;     [childo :betty-rubble :bamm-bamm-rubble]
  #\_=&gt;     [childo :barney-rubble :bamm-bamm-rubble]
  #\_=&gt;
  #\_=&gt;     [parento :pebbles-flintstone :fred-flintstone]
  #\_=&gt;     [parento :pebbles-flintstone :wilma-flintstone]
  #\_=&gt;     [childo :fred-flintstone :pebbles-flintstone]
  #\_=&gt;     [childo :wilma-flintstone :pebbles-flintstone]))
#'user/family</code></p>

> Write a relation called *extendo*, which works like the bult-in *appendo*, mentioned in the easy problems.

I am pretty sure this is right. Let me know in the comments if not!

<p><code class="clojure">user=&gt; (defn extendo [a b l]
  #\_=&gt;   (conde
  #\_=&gt;     [(== a ()) (== b l)]
  #\_=&gt;     [(fresh [h t t2]
  #\_=&gt;        (conso h t a)
  #\_=&gt;        (conso h t2 l)
  #\_=&gt;        (extendo t b t2))])
  #\_=&gt; )
#'user/extendo
user=&gt; (run\* [q] (extendo [1 2] [3 4] q))
((1 2 3 4))
user=&gt; (run\* [q] (extendo [1 2] q [1 2 3 4]))
((3 4))
user=&gt; (run\* [q] (extendo q [3 4] [1 2 3 4]))
((1 2))</code></p>

