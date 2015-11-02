> Write a for loop that counts backward using Julia&#8217;s range notation.

We can use the start:step:end notation like this.

<p><code>julia&gt; for i in 10:-1:1
           println(i)
       end
10
9
8
7
6
5
4
3
2
1

julia&gt; for i in 10:-2:5
           println(i)
       end
10
6
8</code></p>

> Write an iteration over a multidimensional array like [1 2 3; 4 5 6; 7 8 9]. In what order does it get printed out?

Seems trivial to get rows out thus.

<p><code>julia&gt; m = [1 2 3; 4 5 6; 7 8 9]
3x3 Array{Int64,2}:
 1  2  3
 4  5  6
 7  8  9

julia&gt; for i in m
          println(m[i])
       end
1
2
3
4
5
6
7
8
9</code></p>

> Use pmap to take an array of trial counts and produce the number of heads found for each element.

I spent a really long time on this and could not find a sensible way to do it. This seems very clearly a job for a fold/reduce rather than a map. I came up with something that "works" but not sure if it is what the authors were after.

<p><code>julia&gt; heads=[1 0 1 1; 1 1 0 1; 1 0 0 1; 0 1 0 1]
4x4 Array{Int64,2}:
 1  0  1  1
 1  1  0  1
 1  0  0  1
 0  1  0  1

julia&gt; pmap(x-&gt;sum(heads[x,:]), 1:4)
4-element Array{Any,1}:
 3
 3
 2
 2</code></p>
