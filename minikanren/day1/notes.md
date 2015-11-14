# miniKanren day1

## Intro blarb

Logic programming. Bit like real magic. cf: Harry Potter. Many implementations of miniKanren, we use clojure version, core.logic &mdash; bridges logical programming and "normal" world quite nicely.

## Install process

Installs an older version, so avoid:

<p><code class="bash">$ sudo aptitude install leiningen</code></p>

Instead
<p><code class="bash">$ wget https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein
$ sudo ln -s lein /usr/local/bin/lein</code></p>

Next set up project and sort out deps:
<p><code class="bash">$ lein new logical
$ cd logical
$ vim project.clj</code></p>

That file should look like
<p><code class="clojure">(defproject logical "0.1.0-SNAPSHOT"
  :description "Seven More Languages In Seven Weeks: miniKanren day1"
  :url "http://charlieharvey.org.uk"
  :license {:name "GNU Public License 2"
            :url "https://www.gnu.org/licenses/gpl-2.0.html"}
  :dependencies [[org.clojure/clojure "1.7.0"]
                 [org.clojure/core.logic "0.8.5"]]) </code></p>

Now you can start REPL with 

<p><code class="bash">
$ lein repl
Retrieving org/clojure/core.logic/0.8.5/core.logic-0.8.5.pom from central
Retrieving org/clojure/clojure/1.4.0/clojure-1.4.0.pom from central
Retrieving org/sonatype/oss/oss-parent/5/oss-parent-5.pom from central
Retrieving org/clojure/core.logic/0.8.5/core.logic-0.8.5.jar from central
nREPL server started on port 34017 on host 127.0.0.1 - nrepl://127.0.0.1:34017
REPL-y 0.3.7, nREPL 0.2.10
Clojure 1.7.0
OpenJDK 64-Bit Server VM 1.7.0_85-b01
    Docs: (doc function-name-here)
          (find-doc "part-of-name-here")
  Source: (source function-name-here)
 Javadoc: (javadoc java-object-or-class-here)
    Exit: Control+D or (exit) or (quit)
 Results: Stored in vars *1, *2, *3, an exception in *e

user=&gt;
</code></p>

## Goal to succeed

Logic programming &mdash; give some constraints and information, computer figures out the rest.

Start with programs

At this point I fucked up because I was trying to write:

<p><code>user=&gt; (use 'clojure.core.logic') </code></p>

Instead of

<p><code>user=&gt; (use 'clojure.core.logic) </code></p>

Note no trailing '. Once I got past that things got to be more fun!

<p><code>user=> (use 'clojure.core.logic)
WARNING: == already refers to: #'clojure.core/== in namespace: user, being replaced by: #'clojure.core.logic/==
nil
user=&gt; (run\* [q] (== q 1))
(1)
user=&gt; (run\* [q] (== q 4))
(4)
</code></p>

The run\* function runs a logic program and returns a set of solutions which is then bound to q. == stands for unification, not equality so you are saying "unify q with 1" (make L && R sides same if possible). 1 is a good solution for this.
You can try and unify multiple goals (like &&) but they may be mutually incompatible as in

<p><code class="clojure">user=&gt; (run\* [q] (== q 4) (== q 3))
()</code></p>

BEcause q cannot be both 4 and 3. Well, duh!

## Getting relational

Logical functions:

<p><code class="clojure">user=&gt; (run\* [q] (membero q [1 4 7]))
(1 4 7)</code></p>

The membero function says that arg0 is member of collection arg1. q gets bound to the values for which the goal succeeds. You can limit number of answers like this

<p><code class="clojure">
user=&gt; (run 2 [q] (membero q [1 4 7]))
(1 4)</code></p>

You can reverse the args of membero

<p><code class="clojure">
user=&gt; (run 5 [q] (membero [1 4 7] q))
(([1 4 7] . _0) (_0 [1 4 7] . _1) (_0 _1 [1 4 7] . _2) (_0 _1 _2 [1 4 7] . _3) (_0 _1 _2 _3 [1 4 7] . _4))</code></p> <!--_-->

What you are really asking here is which collections contain [1 4 7] as a member. The way to read this is . is head of a list \_0 is an unbound elt. So first answer is "any list with [1 4 7] as head". Next ans "Any list with [1 4 7] as second elt. And so on."

## Programming with facts

Core.logic includes a database pldb which lets you construct relations a bit like a table in an sql db.


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
user=&gt; (def facts
  #_=&gt;   (db 
  #_=&gt;     [mano :alan-turing]
  #_=&gt;     [womano :grace-hopper]
  #_=&gt;     [mano :leslie-lamport]
  #_=&gt;     [transo :laverne-cox]
  #_=&gt;     [womano :barbara-liskov]))
[#object[clojure.lang.AFunction$1 0x27763e5f "clojure.lang.AFunction$1@27763e5f"] :laverne-cox][#object[clojure.lang.AFunction$1 0x1f4847ca "clojure.lang.AFunction$1@1f4847ca"] :barbara-liskov]#'user/facts
user=&gt; (with-db facts
  #_=&gt;   (run* [q] (womano q)))
(:grace-hopper :barbara-liskov) </code></p> <!--_-->

So we created a some gender identity db relations then some people associated with the identities and then pulled out all the ones that we'd made womano.

Same trick with vitalo (alive/dead) and turingo (have won Turing award).

<p><code class="clojure">user=&gt; (db-rel vitalo p s)
#'user/vitalo
user=&gt; (db-rel turingo p y)
#'user/turingo
user=&gt; (def facts
  #_=&gt;   (-> facts
  #_=&gt;     (db-fact vitalo :alan-turing :dead)
  #_=&gt;     (db-fact vitalo :grace-hopper :dead)
  #_=&gt;     (db-fact vitalo :leslie-lamport :alive)
  #_=&gt;     (db-fact vitalo :laverne-cox :alive)
  #_=&gt;     (db-fact vitalo :barbara-liskov :alive)
  #_=&gt;     (db-fact turingo :barbara-liskov :2008)
  #_=&gt;     (db-fact turingo :leslie-lamport :2013)
  #_=&gt; ))
#'user/facts
user=&gt; (with-db facts
  #_=&gt;   (run* [q]
  #_=&gt;     (womano q)
(:barbara-liskov)
  #_=>     (vitalo q :alive)))</code></p><!--_-->


