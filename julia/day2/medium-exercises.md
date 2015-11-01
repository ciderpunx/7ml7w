> Write the fatorial function as a parallel for loop

Well, there is a much prettier way to do it that I realized earlier which is just

<p><code>julia&gt; *(1:5...)
120</code></p><!--*-->

However, to make a parallel loop you could

<p><code>julia&gt; function fac(n)
           @parallel (*) for i in 1:n
               i
           end
       end
fac (generic function with 1 method)

julia&gt; fac(5)
120

julia&gt; fac(15)
1307674368000

julia&gt; fac(25)
7034535277573963776</code></p>

> Add a method for concat that can concatenate an integer with a matrix &mdash; concat(5, [1 2; 3 4]) should produce [5 5 1 2; 5 5 3 4]

That is a bit weird. I would have thought it would produce [5 1 2; 5 3 4], so I implemented it that way. I use the library function hcat once I have constructed a vercor of the correct dimension.

<p><code>julia> q = [1 2 5; 2 2 2; 6 6 6]
3x3 Array{Int64,2}:
 1  2  5
 2  2  2
 6  6  6

julia&gt; function concat(n, m)
          tocat = fill(n,size(m)[1])
          hcat(tocat,m)
       end
concat (generic function with 1 method)

julia&gt; concat(5,q)
3x4 Array{Int64,2}:
 5  1  2  5
 5  2  2  2
 5  6  6  6</code></p>

> You can extend built-in functions with new methods too. Add a new method for + to make "jul"+"ia" work.

I assumed that + ought to mean string concatnenation rather than anything more exotic here.

<p><code>julia&gt; function +(a::String, b::String)
           "$a$b"
       end
+ (generic function with 118 methods)

julia&gt; "jul"+"ia"
"julia"</code></p>
