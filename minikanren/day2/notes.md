# miniKanren day 2

Implementation from The Reasoned Schemer only takes 2 pages. core.logic is longer as it needs better performance. Focus today on interop with clojure.

## Patterns

David Nolen also wrote *core.match* which is a pattern matching implementation and *core.logic* has pattern matching built in.

Look again at *insideo* -- first op is to deconstruct list with *conso*. Could do with pattern matching instead.

### matche

*matche* is a pattern matching version of *conde* so *insideo* can be written:

<p><code class="clojure">
(defn insideo [e l]
  (matche [l]
    ([[e . _]])
    ([[_ . t]] (insideo e t))))
</code></p>

Quick test that works "as expected".

<p><code class="clojure">user=&gt; (run&#42; [q] (insideo q [:1 :2 :4]))
(:1 :2 :4)
user=&gt; (run&#42; [q] (insideo q [1 2 4]))
(1 2 4)
user=&gt; (run&#42; [q] (insideo [1 2 4] q))

user=&gt; (run 4 [q] (insideo [1 2 4] q))
(([1 2 4] . &#95;0) (&#95;0 [1 2 4] . &#95;1) (&#95;0 &#95;1 [1 2 4] . &#95;2) (&#95;0 &#95;1 &#95;2 [1 2 4] . &#95;3))
user=&gt; </code></p>

### Function patterns

Because *matche* is very commonly used as a basic building block of a function, *defne* lets you save even more typing by implicitly assuming that is what you want to do.

So this

<p><code class="clojure">(defne exampleo [a b c]
  ([:a _ _])
  ([_ :b x] (membero x [:x :y :z])))</code></p>

Expands to

<p><code class="clojure">(defn exampleo [a b c]
  (matche [a b c]
    ([:a _ _])
    ([_ :b x] (membero x [:x :y :z]))))</code></p>

That feels a bit more like Erlang or Hakell which already do  pattern matching as a part of function definitions.

Final version of *insideo* comes out like this. Nicer.

<p><code class="clojure">(defne insideo [e l]
  ([_ [e . _ ]])
  ([_ [_ . t]] (insideo e t)))<!--_--></code></p>

So that's a bit nicer syntax-wise.

## Maps

Clojure unlike Lisp has first class support for maps (hashes, dicts). IN *core.logic* things are mostly the same &mdash; you can even use maps in pattern matching

<p><code class="clojure">(run* [q]
  (fresh [m]
    (== m {:a 1 :b 2})
    (matche [m]
      ([{:a 1}] (== q :found-a))
      ([{:b 2}] (== q :found-b))
      ([{:a 1 :b 2}] (== q :found-a-and-b))))) <!--_*--></code></p>

I would have expected everything to match, but in *core.logic* only exact matches count. May be useful when you know how many k-v pairs you&#8217;re dealing with but to pull out specific pieces, use *featurec*

<p><code class="clojure">user=&gt; (run&#42; [q] (featurec q {:a 1}))
((&#95;0 :- (clojure.core.logic/featurec &#95;0 {:a 1})))</code></p>

You can read :- as such that so we are asking for all maps with a k :a and a v 1 and *core.logic* replies any map st {:a 1} is a solution. If we use *featurec* the code comes out working more like you'd expect.
<p><code class="clojure">(run* [q]
  (fresh [m a b]
    (== m {:a 1 :b 2})
    (conde
      [(featurec m {:a a}) (== q [:found-a a])]
      [(featurec m {:b b}) (== q [:found-b b])]
      [(featurec m {:a a :b b}) (== q [:found-a-and-b a b])]))) <!--_*--> </code></p>

featirec is not featureo because it is not a relation. You cannot run it backward.

## Other kinds of cond

Most languages have single type of conditional but *core.logic* has several. We look at a couple *conda* and *condu* as well as *conde*

### A single universe: conda

We create the relation *whicho* which tells us which of 2 lists an elt appears in. Takes an elt, 2 lists and a result -- either :one :two or :both.

First conde implementation

<p><code class="clojure">
(defn whicho [x s1 s2 r]
  (conde
    [(membero x s1)
     (== r :one)]
    [(membero x s2)
     (== r :two)]
    [(membero x s1)
     (membero x s2)
     (== r :both)]))
</code></p>

This is all good, except when elt occurs in both lists

<p><code class="clojure">
user=> (run* [q] (whicho :a [:a :b :c] [:d :e :c] q))
(:one)
user=> (run* [q] (whicho :d [:a :b :c] [:d :e :c] q))
(:two)
user=> (run* [q] (whicho :c [:a :b :c] [:d :e :c] q))
(:one :two :both)
<!--*--></code></p>

In cases like this we can use conda, note code reorganized to short circuit like a given when in perl 6.

<p><code class="clojure">
(defn whicho [x s1 s2 r]
  (conda
    [(all
      (membero x s1)
      (membero x s2)
      (== r :both))]
    [(all
      (membero x s1)
      (== r :one))]
    [(all
      (membero x s2)
      (== r :two))]))
</code></p>

Now things work like we wanted &mdash; a shortcircuiting if statement like in a proper language. In logic programming the conde form is more common though.

<p><code class="clojure">
user=> (run* [q] (whicho :a [:a :b :c] [:d :e :c] q))
(:one)
user=> (run* [q] (whicho :d [:a :b :c] [:d :e :c] q))
(:two)
user=> (run* [q] (whicho :c [:a :b :c] [:d :e :c] q))
(:both)
<!--*--></code></p>

### Single solution: condu

condu stops completely once a single solution is found. So for example using insodeo instead of finding that:

<p><code class="clojure">
user=> (run* [q] (insideo q [:a :b :c :d]))
(:a :b :c :d)
<!--*--></code></p>

We get that

<p><code class="clojure">
user=> (run* [q] (insideo q [:a :b :c :d]))
(:a)
<!--*--></code></p>

The first match rather than all matches (the committed choice macro is the proper name for it). Here is how that version of insideo is implemented

<p><code class="clojure">
  (defn insideo [e l]
  (condu
    [(fresh [h t]
      (conso h t l)
      (== h e))]
    [(fresh [h t]
      (conso h t l)
      (insideo e t))]))
</code></p>
