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
