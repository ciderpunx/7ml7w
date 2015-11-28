Day two of MiniKanren starts by covering matching with *matche* which is a macro that allows you to do common matching operations with less boilerplate.

But of course once you start down that route you are going to want to be able to lose the boilerplate from your whole function definition. That&#8217;s what *defne* lets you do. 

Next maps are covered followed by different sorts of cond. 

In *core.logic* there are at least 3 different sorts of cond you might want to use &mdash; *conde* which evaluates all the branches, *condu* (the so-called committed choice cut) wherein only the first choice is taken and *conda* (the soft cut) which works like a normal short-circuiting if statement. From reading around I also came across *condi* which alternates between the solutions in its branches.

## Exercises

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

#### Hard exercises

> Play with *(insideo :a [:a :b :a])*. How many times does it succeed? Make it succeed only once but have *(insideo q [:a :b :a])* return all distinct elements. Hint: Try using the != constraint.

As it turns out I think what is being asked for is right next to the implementation of *membero* in the *core.logic* source. It is called *member1o*. So I just copied that implementation. Which feels a bit like cheating, but I still felt I learned a little from reading the code.

<p><code class="clojure">(defne insideo [e l]
  ([&#95; [e . t]])
  ([&#95; [h . t]]
    (!= e h)
    (insideo e t)))</code></p>

Let&#8217;s see that run.

<p><code class="clojure">user=&gt; (run&#42; [q] (insideo :a [:a :b :a]))
(&#95;0)
user=&gt; (run&#42; [q] (insideo q [:a :b :a]))
(:a :b)
user=&gt; (run&#42; [q] (insideo q [:a :b :a :b :c :a]))
(:a :b :c) </code></p>

## Wrapping up

The second day of miniKanren was interesting. For me it felt a bit more like normal functional programming the I remember [Prolog feeeling](/page/seven_languages_prolog_one) back when I was playing with that language. I think that this is probably partly because of Clojure&#8217;s Lisp-syntax to an extent. 

A problem of learning a lot of languages in a shallow way is that when you try to express even quite simple ideas you find yourself DDGing or Googling trivial syntax rather than engaging with the deeper lessons which the exercises are trying to convey.

In the medium exercise I had originally wanted to pass back the complete list if there were no Turing award winners and the emprty list if not. Believe it or not I got stumped for more than an hour on doing that before having a cup of tea and deciding to just succeed or fail.

That aside, it is interesting and enlightening to see how in quite a straightforward manner you can specify the constraints of your problem and have an answer magically pop out of the computer. Not necessarily the answer you expected, but an answer nonetheless!
