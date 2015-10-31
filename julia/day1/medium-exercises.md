> Create a matrix and multiply it by its inverse. Hint: inv computes the inverse of a matrix, but not all matrices are invertible.

I had a look at the post on matix inversion on [math is fun](https://www.mathsisfun.com/algebra/matrix-inverse.html). It is basically like the reciprocal for numbers and used if you want to do something like division. In order to have an inverse, the matric better have the same number of rows and columns and a non-zero determinant. There is a way of finding the determinant that looks a bit of a mess or just use det(M) in Julia.

Also note here that Julia figures out that I will need Float64s in the resulting matrix for the invertible matrix and sorts that out for me. Cool.

<p><code>julia> noninvertibleNotSquare = [1 1 2; 1 1 2]
2x3 Array{Int64,2}:
 1  1  2
 1  1  2

julia> noninvertibleZeroDeterminant = [1 1; 1 1]
2x2 Array{Int64,2}:
 1  1
 1  1

julia> det(noninvertibleZeroDeterminant)
0.0

julia> inv(noninvertibleZeroDeterminant)
ERROR: SingularException(2)
 in inv at ./linalg/lu.jl:149
 in inv at ./linalg/dense.jl:328

julia> invertible = [2 4; 6 8]
2x2 Array{Int64,2}:
 2  4
 6  8

julia> det(invertible)
-8.0

julia> inv(invertible)
2x2 Array{Float64,2}:
 -1.0    0.5 
  0.75  -0.25</code></p>

> Create 2 dictionaries and merge them. Hint: Look up merge in the manual. 

<p><code>julia> d1 = {:cider =&gt; 9, :beer =&gt; 7, :coffee =&gt; 8}
Dict{Any,Any} with 3 entries:
  :beer   =&gt; 7
  :coffee =&gt; 8
  :cider  =&gt; 9

julia> d2 = {:wine =&gt; 2, :baileys =&gt; -1}
Dict{Any,Any} with 2 entries:
  :wine    =&gt; 2
  :baileys =&gt; -1

julia> merge(d1,d2)
Dict{Any,Any} with 5 entries:
  :beer    =&gt; 7 :coffee  =&gt; 8
  :wine    =&gt; 2
  :cider   =&gt; 9
  :baileys =&gt; -1</code></p>

> sort and sort! both operate on arrays. what is the difference between them?

Just like Ruby, sort will return a sorted copy of your array and sort! will sort it in place.
