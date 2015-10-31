Julia day 1 notes

To cover: types, operators, dicts, arrays.
Install

<div><code>$ sudo aptitude install julia julia-factcheck</code></div>

NB: factcheck is a test framework. 

### types intro

<div><code>
$ julia 
               _
   _       _ _(_)_     |  A fresh approach to technical computing
  (_)     | (_) (_)    |  Documentation: http://docs.julialang.org
   _ _   _| |_  __ _   |  Type "help()" for help.
  | | | | | | |/ _` |  |
  | | |_| | | | (_| |  |  Version 0.3.2
 _/ |\__'_|_|_|\__'_|  |  
|__/                   |  x86_64-linux-gnu

julia&gt; println("Hallo Julia World")
Hallo Julia World

julia&gt; typeof(5)
Int64

julia&gt; typeof(5.75)
Float64

julia&gt; typeof(5.75/11)
Float64

julia&gt; typeof(5.75//11)
ERROR: `//` has no method matching //(::Float64, ::Int64)

julia&gt; typeof(5//11)
Rational{Int64} (constructor with 1 method)

julia&gt; typeof(:foo)
Symbol

julia&gt; typeof(true)
Bool

julia&gt; typeof("str")
ASCIIString (constructor with 2 methods)

julia&gt; typeof(typeof)
Function

julia&gt; typeof((2, "tuple"))
(Int64,ASCIIString)

julia&gt; typeof(["array","of","things"])
Array{ASCIIString,1}

julia&gt; typeof({:dict=>"map"}
       )
Dict{Any,Any} (constructor with 3 methods)
</code></div>

### operators intro

<code><div>
julia&gt; 1+2
3

julia&gt; 2+4.5
6.5

julia&gt; 5/1
5.0

julia&gt; # this is reversed division -- useful in linear algebra. and comments can be with #s

julia&gt; 2\5
2.5

julia&gt; # integer division

julia&gt; div(7,3)
2

julia&gt; mod (7,3)
1

julia&gt; ## bits gives you a binary rep of value. 

julia&gt; bits(5)
"0000000000000000000000000000000000000000000000000000000000000101"

julia&gt; ## bitwise operators similar to c

julia&gt; 6 & 5
4

julia&gt; 5 | 6
7

julia&gt; # negation and xor

julia&gt; ~0
-1

julia&gt; ~1

julia&gt; # boolean operators

julia&gt; true || false
true

julia&gt; false || true
true

julia&gt; false && true
false

julia&gt; !true
false

julia&gt; !!true
true

julia&gt; # comparison

julia&gt; 4==4
true

julia&gt; 4 &lt; 8 &lt; 16
true

julia&gt; 4 &lt; 8 &lt; 6
false

-2

julia&gt; 5 $ 6
3

julia&gt; ## Dicts and Sets

julia&gt; # similar sketch to haskell -- k,v of same type but type can be Any. Can be explicit about types using [...] or dynamic using {...} 

julia&gt; implicit = {:a => 1, :b => 2, :c => 3}
Dict{Any,Any} with 3 entries:
  :b => 2
  :c => 3
  :a => 1

julia&gt; explicit = [:a => 1, :b => 2, :c => 3]
Dict{Symbol,Int64} with 3 entries:
  :b => 2
  :c => 3
  :a => 1

julia&gt; ## NB: what's the advantage of the implicit form?

julia&gt; ## NB: Keys are not ordered by the look of it. Feels perlish.

julia&gt; # retrieving ks and vs

julia&gt; explicit[:a]
1

julia&gt; implicit[:a]
1

julia&gt; # retrieve with default value

julia&gt; get(explicit, :d, 4)
4

julia&gt; keys(explicit)
KeyIterator for a Dict{Symbol,Int64} with 3 entries. Keys:
  :b
  :c
  :a

julia&gt; ## construct an array from items in an iterator

julia&gt; collect(keys(explicit))
3-element Array{Symbol,1}:
 :b
 :c
 :a

julia&gt; ## test for if something in an array

julia&gt; :a in collect(keys(explicit))
true

julia&gt; :q in collect(keys(explicit))
false

julia&gt; :a in keys(explicit)
true

julia&gt; in((:a,1), explicit)
true

julia&gt; ## sets -- an unordered set (proper useful this)

julia&gt; myset = Set(1,2,3,4,5,6,1,3,2)
Set{Int64}({4,2,3,5,6,1})

julia&gt; union(Set(1,2),Set(2,3))
Set{Int64}({2,3,1})

julia&gt; intersect(Set(1,2),Set(2,3))
Set{Int64}({2})

julia&gt; setdiff(Set(1,2),Set(2,3))
Set{Int64}({1})

julia&gt; issubset(Set(1,2),Set(2,3))
false

julia&gt; issubset(Set(1,2),Set(2,3,1))
true

julia&gt; ## Arrays "straight out of future" says text!

julia&gt; # Typed, reshapeable, sliceable all of same type

julia&gt; animals = [:lions, :tigers, :bears] # oh my!
3-element Array{Symbol,1}:
 :lions 
 :tigers
 :bears 

julia&gt; [1,2,:c]
3-element Array{Any,1}:
 1  
 2  
  :c

julia&gt; ## [] syntax -- types inferred

julia&gt; # For specific type use Type[] thus

julia&gt; Int64[1,2,3]
3-element Array{Int64,1}:
 1
 2
 3

julia&gt; Int64[1,2,3.0]
3-element Array{Int64,1}:
 1
 2
 3

julia&gt; # oh shouldn't that be a type error rather than casting it?

julia&gt; Int64[1,2,3.5]
ERROR: InexactError()

julia&gt; # hah. ok.

julia&gt; ## array creation

julia&gt; zeros(Int32,5)
5-element Array{Int32,1}:
 0
 0
 0
 0
 0

julia&gt; ones(Float64,5)
5-element Array{Float64,1}:
 1.0
 1.0
 1.0
 1.0
 1.0

julia&gt; fill(:empty,5)
5-element Array{Symbol,1}:
 :empty
 :empty
 :empty
 :empty
 :empty

julia&gt; ## indexing and slicing

julia&gt; animals
3-element Array{Symbol,1}:
 :lions 
 :tigers
 :bears 

julia&gt; ## indexed from 1, not 0. yuk

julia&gt; animals[1]
:lions

julia&gt; animals[end]
:bears

julia&gt; animals[2:end]
2-element Array{Symbol,1}:
 :tigers
 :bears 

julia&gt; animals[2:2]
1-element Array{Symbol,1}:
 :tigers

julia&gt; animals[2]=:meerkats
:meerkats

julia&gt; animals
3-element Array{Symbol,1}:
 :lions   
 :meerkats
 :bears   

julia&gt; animals[2:end]=:meerkats
:meerkats

julia&gt; animals
3-element Array{Symbol,1}:
 :lions   
 :meerkats
 :meerkats

julia&gt; animals[2:end]=[:meerkats :pandas]
1x2 Array{Symbol,2}:
 :meerkats  :pandas

julia&gt; animals
3-element Array{Symbol,1}:
 :lions   
 :meerkats
 :pandas  

julia&gt; ## multidimensional arrays

julia&gt; ## julia designed to be good for linear algebra with vectors and matrices hence excellent md array support

julia&gt; A = [1 2 3; 4 5 6; 7 8 9]
3x3 Array{Int64,2}:
 1  2  3
 4  5  6
 7  8  9

julia&gt; size(A)
(3,3)

julia&gt; A[2,3]
6

julia&gt; A[1:end,3]
3-element Array{Int64,1}:
 3
 6
 9

julia&gt; A[2,:]
1x3 Array{Int64,2}:
 4  5  6

julia&gt; A[2,]
4

julia&gt; A[2:end,2:end]
2x2 Array{Int64,2}:
 5  6
 8  9

julia&gt; A[2:end,2:end] =0
0

julia&gt; A
3x3 Array{Int64,2}:
 1  2  3
 4  0  0
 7  0  0

julia&gt; ## random elts array

julia&gt; rand(Float64,(3,3))
3x3 Array{Float64,2}:
 0.890564  0.775151  0.705244
 0.573838  0.20474   0.9935  
 0.340879  0.708509  0.255056

julia&gt; ## identity matrix with eye

julia&gt; I = eye(3,3)
3x3 Array{Float64,2}:
 1.0  0.0  0.0
 0.0  1.0  0.0
 0.0  0.0  1.0

julia&gt; I * 5
3x3 Array{Float64,2}:
 5.0  0.0  0.0
 0.0  5.0  0.0
 0.0  0.0  5.0

julia&gt; ## elt-wise multiplication uses .* (not *)

julia&gt; v = [1; 2; 3]
3-element Array{Int64,1}:
 1
 2
 3

julia&gt; v .* [0.5; 1.2; 0.1]
3-element Array{Float64,1}:
 0.5
 2.4
 0.3

julia&gt; ## transpose array by adding a quote after it

julia&gt; v' * v
1-element Array{Int64,1}:
 14

julia&gt; A * v
3-element Array{Int64,1}:
 14
  4
  7
</code></div>
