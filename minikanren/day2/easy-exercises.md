#### Easy exercises

> Rewrite *extendo* from day 1 using *matche* or *defne*.

This is a little bit nicer to write. However, it took me a while to work out that I could say () for empty list. I don&#8217;t know why I had a mental block on that.

<p><code class="clojure">(defne extendo [a b l]
  ([() _ b])
  ([[h . t] _ [h . t2]] (extendo t b t2)))</code></p>

> Create a goal not-rooto which takes a map with a *:username* key and succeeds only if the value is not root.

I spent quite some time working this out. I believe it to be correct.

<p><code class="clojure">(defn non-rooto [m l]
   (fresh [a]
    (conda
      [(all
        (featurec m {:username a}) (!= 'root a)
        (== l m))])))</code></p>

Let&#8217;s see if it works.

<p><code class="clojure">user=&gt; (run&#42; [q] (non-rooto {:username 'rot :pass 'somebcrypt} q))
({:username rot, :pass somebcrypt})
user=&gt; (run&#42; [q] (non-rooto {:username 'root :pass 'somebcrypt} q))
() </code></p>


> Run *whicho* in reverse, asking for elements in one or both of the sets.

<p><code class="clojure">user=&gt; (run&#42; [q] (whicho q [:a :b :c] [:d :e :c] :both))
(:c)
user=&gt; (run&#42; [q] (whicho q [:a :b :c] [:d :e :c] :one))
(:a :b :c) </code></p>

> Add a *:none* branch to *whicho*. What happens when you use the *:none* branch in the *:whicho* built on *conde*?

My original attempt would always return :none. I couldn't figure out a nice way of saying x is not a member of s1 (or s2) other than implementing a subsidiary nonmembero function. Interesting.

<p><code class="clojure">(defne nonmembero [e l]
  ([_ ()])
  ([_ [h . t]]
     (!= e h)
     (nonmembero e t)))

(defn whicho [x s1 s2 r]
  (conde
    [(membero x s1)
     (== r :one)]
    [(membero x s2) 
     (== r :two)]
    [(membero x s1)
     (membero x s2)
     (== r :both)]
    [(nonmembero x s1)
     (nonmembero x s2)
     (== r :none)])) </code></p>

And that does indeed now behave as I imagine it should.

<p><code class="clojure">user=&gt; (run&#42; [q] (whicho :f [:a :b :c] [:d :e :c] q))
(:none)
user=&gt; (run&#42; [q] (whicho :a [:a :b :c] [:d :e :c] q))
(:one)
user=&gt; (run&#42; [q] (whicho :c [:a :b :c] [:d :e :c] q))
(:one :two :both)
user=&gt; (run&#42; [q] (whicho :d [:a :b :c] [:d :e :c] q))
(:two)</code></p>
