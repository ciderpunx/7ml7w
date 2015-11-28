# miniKanren day 3: writing stories with logic

Plan: build a bigger example -- a story generator. First need to look at finite domains.

## Finite domains

Logic programming implemented using directed search algorithims [TD: more research]. maps, elts and lists are composed of a finite set of concreete elts (but can be infinite in size?). For membero q [1 2 3] *core.logic* just has to search all the elements.

How about (<= q 1)? Infinite # of answers, also possibilities to try. Also may never find a solution depending on when you search and how (i.e. if you start at 2 and go up you're fucked)

We need to constrain q to the positive integers or any finite set of #s. In *core.logic* we can make such constraints with finite domains, which add knowledge about the set of valid states in the search problem.

<p><code class="clojure">user=&gt; (use 'clojure.core.logic)
WARNING: == already refers to: #'clojure.core/== in namespace: user, being replaced by: #'clojure.core.logic/==
nil
user=&gt; (require '[clojure.core.logic.fd :as fd])
nil
user=&gt; (run&#42; [q]
  #&#95;=&gt;   (fd/in q (fd/interval 0 10))
  #&#95;=&gt;   (fd/<= q 1))
(0 1)</code></p>

i.e. q is "in" "interval" 0..10
&&   q <= 1

Something more complex -- every triple of distinct #s which add up to 100

<p><code class="clojure">(run 4 [q]
  (fresh [x y z a]
    (== q [x y z])
    (fd/in x y z a (fd/interval 1 100))
    (fd/distinct [x y z])
    (fd/&lt; x y)
    (fd/&lt; y z)
    (fd/+ x y a)
    (fd/+ a z 100)))
([1 2 97] [2 3 95] [1 3 96] [1 4 95])</code></p>

Its fast and works pretty well, but the temp var is a bit ugly, we can use *fd/eq* to make it a bit nider to read.

<p><code class="clojure">(run 4 [q]
  (fresh [x y z]
    (== q [x y z])
    (fd/in x y z (fd/interval 1 100))
    (fd/distinct [x y z])
    (fd/&lt; x y)
    (fd/&lt; y z)
    (fd/eq (= (+ x y z) 100))))
([1 2 97] [2 3 95] [1 3 96] [1 4 95])</code></p>

## Magical stories

Start of larger problem combining stuff we&#8217;ve learned.

The idea is to write a story from a database of plot elements. Inspired by "Linear Logic Programming" by Chris Martens. cf. http://www.infoq.com/presentations/linear-logic-programming

We use *core.logic* to generate stories and Clojure to postprocess and select ones that fit criteria.

## Problem details

1. Story elts.
2. Way to move between story elts
3. Will store plot points in db, plot points nicked from the film *clue*

Linear logic extends normal logic with use and manipulation of resources so instead of A implies B you can say A consumes Z and produces B. eg. consume motorist, produce dead motorist. 

Reflection: Interesting comparison to design by contract&#8217;s pre and post conditions and a bit like a finite state machine.

Can use *core.logic* to do this!

Each plot elt has a resource it needs and resource it produces. Representation: 2 elt vector [:need :produce].

We have a starting state -- initial available resources. A relation governs selecting legal story given the state and moving to a new state. We control where the story goes by putting requirements in the final state. And then we need to print the stories out in human readable format.

## Story elements

Grab these from [github](https://github.com/ahmadsalim/seven-more-languages/blob/master/minikanren/logical/src/logical/story.clj). Its a vector of vectors -- with the in, out and textual description. See story.clj

## Build database and initial state

Create a relation ploto (need resource to output resource). We use reduce (which is like map) to effect the transformation.

<p><code class="clojure">(def story-db
  (reduce (fn [dbase elems]
            (apply db-fact dbase ploto (take 2 elems)))
          (db)
          story-elements))</code></p>

Next we need an initial state. This is fixed (like a Markov chain).

<p><code class="clojure">(def start-state
  [:maybe-telegram-girl :maybe-motorist
   :wadsworth :mr-boddy :cook :yvette])</code></p>

## Plotting along

Next create transition relation to move the story along. This is the meat and spunk of the generator.

<p><code class="clojure">
(defn actiono [state new-state action] 
  (fresh in out tmp
    (membero in state)
    (ploto in out)
    (rembero in state tmp)
    (conso out tmp new-state)
    (== action [in out])))
</code></p>

At this point we can

<p><code class="clojure">user=&gt; (with-db story/story-db
  #&#95;=&gt;   (run 2 [q]
  #&#95;=&gt;     (fresh [act state]
  #&#95;=&gt;       (== q [act state])
  #&#95;=&gt;       (story/actiono [:motorist] state act))))
([[:motorist :policeman] (:policeman)] [[:motorist :dead-motorist] (:dead-motorist)])</code></p>

So now we want to do the same thing backwards. We know the final state and we want to find the sequence of conditions which led to it.

We create the storyo function which calls storyo\* and takes care of initial state for user (shuffling the start state produces random sequence).

So let&#8217;s look at storyo on the REPL.

<p><code class="clojure">user=&gt; (with-db story/story-db
  #&#95;=&gt;   (run 5 [q]
  #&#95;=&gt;     (story/storyo [:dead-wadsworth] q)))
(([:wadsworth :dead-wadsworth]) ([:cook :dead-cook] [:dead-cook :guilty-scarlet] [:wadsworth :dead-wadsworth]) ([:cook :dead-cook] [:wadsworth :dead-wadsworth]) ([:cook :dead-cook] [:dead-cook :guilty-peacock] [:wadsworth :dead-wadsworth]) ([:yvette :dead-yvette] [:dead-yvette :guilty-scarlet] [:wadsworth :dead-wadsworth]))</code></p>
In each story the goal of Wadsworth being dead is reached, note that it is not deterministic which stories we get in a run.

<p><code class="clojure">
user=&gt; (with-db story/story-db
  #&#95;=&gt;   (run 5 [q]
  #&#95;=&gt;     (story/storyo [:dead-wadsworth] q)))
(([:wadsworth :dead-wadsworth]) ([:maybe-telegram-girl :telegram-girl] [:wadsworth :dead-wadsworth]) ([:mr-boddy :dead-mr-boddy] [:wadsworth :dead-wadsworth]) ([:maybe-telegram-girl :telegram-girl] [:mr-boddy :dead-mr-boddy] [:wadsworth :dead-wadsworth]) ([:maybe-telegram-girl :telegram-girl] [:telegram-girl :dead-telegram-girl] [:dead-telegram-girl :guilty-scarlet] [:wadsworth :dead-wadsworth]))
</code></p>

## Readable stories

To make the stories readable, we pull out the description string fro the story elts. Transform *story-elements* into a map from actions -> strings in output, which means we can then easily print out the descriptions.

The reduce works by associating a 2 elt key vector with a value -- the description which is the last entry in the story elt.

<p><code class="clojure">(def story-map
  (reduce (fn [m elems]
            (assoc m (vec (take 2 elems)) (nth elems 2)))
          {}
          story-elements))

(defn print-story [actions]
  (println "PLOT SUMMARY:")
  (doseq [a actions]
    (println (story-map a))))</code></p>

OK now we can get a nice plot summary.

<p><code class="clojure">user=&gt; (def stories
  #&#95;=&gt;   (with-db story/story-db
  #&#95;=&gt;     (run&#42; [q]
  #&#95;=&gt;       (story/storyo [:guilty-scarlet] q))))
#'user/stories
user=&gt; (story/print-story (first (drop 1 stories)))
PLOT SUMMARY:
The cook is found stabbed in the kitchen.
Miss Scarlet killed the cook to silence her.
nil
user=&gt; (story/print-story (first (drop 10 stories)))
PLOT SUMMARY:
Yvette, the maid, is found strangled with the rope in the billiard room.
Mrs. Peacock killed Yvette.
A singing telegram girl arrives.
The telegram girl is murdered in the hall with a revolver.
Miss Scarlet killed the telegram girl so she wouldn't talk.
nil</code></p>

## Mining stories

We use Clojure&#8217;s stream processing tools to postprocess the stories &mdash; *core.logic* is generating a lazy stream of stories, so only evaled when called.

<p><code class="clojure">(defn story-stream [& goals]
  (with-db story/story-db
    (run* [q]
          (storyo (vec goals) q))))</code></p>

Now we can do shit like  ask for stories consisting of 10 elts in which Yvette dies and Mrs Peacock is a murderer.

<p><code class="clojure">
user=> (story/print-story
  #&#95;=>   (first
  #&#95;=>     (filter #(> (count %) 10)
  #&#95;=>       (story-stream :guilty-peacock :dead-yvette))))
PLOT SUMMARY:
A singing telegram girl arrives.
The telegram girl is murdered in the hall with a revolver.
Miss Scarlet killed the telegram girl so she wouldn't talk.
The cook is found stabbed in the kitchen.
Mrs. Peacock killed her cook, who used to work for her.
Mr. Boddy's body is found in the hall beaten to death with a candlestick.
Wadsworth is found shot dead in the hall.
Mr. Green, an undercover FBI agent, shot Wadsworth.
A stranded motorist comes asking for help.
Investigating an abandoned car, a policeman appears.
Yvette, the maid, is found strangled with the rope in the billiard room.
nil
</code></p>

Or this sort of thing

<p><code class="clojure">user=&gt; (story/print-story
  #&#95;=&gt;   (first
  #&#95;=&gt;     (filter #(> (count %) 12)
  #&#95;=&gt;       (story-stream :dead-cook :guilty-peacock))))
PLOT SUMMARY:
Wadsworth is found shot dead in the hall.
Mr. Green, an undercover FBI agent, shot Wadsworth.
A stranded motorist comes asking for help.
Investigating an abandoned car, a policeman appears.
The policeman is killed in the library with a lead pipe.
Mrs. Peacock killed the policeman.
Mr. Boddy's body is found in the hall beaten to death with a candlestick.
Yvette, the maid, is found strangled with the rope in the billiard room.
Miss Scarlet killed her old employee, Yvette.
A singing telegram girl arrives.
The telegram girl is murdered in the hall with a revolver.
Miss Scarlet killed the telegram girl so she wouldn't talk.
The cook is found stabbed in the kitchen.
nil</code></p>

Some goals are never reached &mdash; dead Scarlet for example &mdash; because they aren&#8217;t in the database.
