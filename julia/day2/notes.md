# Day 2 Julia notes

Topics covered: control flow, abstract and user defined types, functions, multiple dispatch, concurrency

## Control flow

If, while (like Ruby/Python). For loops iterate over various things. 

Unlike python, whitespace not significant

<p><code>
julia&gt; x=10
10

julia&gt; if x &lt; 10
        println("small")
       elseif x &gt; 10
        println("big")
       else
        println("just right")
       end
just right
</code></p>

Expr has to evaluate to Boolean (i.e. not 1 || 0). Empty collections not co-ercible to Booleans.

<p><code>
julia&gt; x = 8
8

julia&gt; while x &lt; 11
           x = x + 1
           println("again")
       end
again
again
again
</code></p>

Different for loop iterations

<p><code>
julia&gt; for a = [1,2,3]
           println("$a")
       end
1
2
3

julia&gt; for b in [3,2,1]
           println("$b")
       end
3
2
1

julia&gt; sum = 0 
0

julia&gt; for a = 1:10
           sum += a
       end

julia&gt; sum
55

julia&gt; ## also Dicts are iterable with for like this

julia&gt; numbers = [:one =&gt; 1, :two =&gt; 2, :three =&gt; 3]
Dict{Symbol,Int64} with 3 entries:
  :three =&gt; 3
  :two   =&gt; 2
  :one   =&gt; 1

julia&gt; for (k,v) in numbers
           println("$v: $k")
       end
3: three
2: two
1: one
</code></p>

## User defined types and functions

Can define your own types, abstract types and limited subtypes. They are a bit like structs in c or rcords in haskell. Types can be of Any.

<p><code>
julia&gt; # constructing a type

julia&gt; type FilmCharacter
           heart :: Bool # :: == has type like in haskell
           name
       end

julia&gt; cowardly_lion = Fil
FileMonitor   FileOffset     FilmCharacter  Filter
julia&gt; cowardly_lion = Fil
FileMonitor   FileOffset     FilmCharacter  Filter
julia&gt; cowardly_lion = FilmCharacter(false, "Lion")
FilmCharacter(false,"Lion")

julia&gt; cowardly_lion.name
"Lion"

julia&gt; cowardly_lion.heart
false

julia&gt; typeof(cowardly_lion.heart)
Bool

julia&gt; typeof(cowardly_lion.name)
ASCIIString (constructor with 2 methods)
</code></p>

Abstract types: no fields, cannot be constructed, can be used as field type specifiers or in typed array literals. Define subtype with <: -- one level only, introspection with super(), subtypes()

<p><code>
julia&gt; # abstract types and subtypes

julia&gt; abstract Story

julia&gt; story()
ERROR: story not defined

julia&gt; Story()
ERROR: type cannot be constructed

julia&gt; type Book &lt;: Story
           title
           author
       end

julia&gt; type Epic &lt;: Story
           title
       end

julia&gt; type Movie &lt;: Story
           title
           director
       end

julia&gt; super(Book)
Story

julia&gt; super(Story)
Any

julia&gt; subtypes(Story)
3-element Array{Any,1}:
 Book 
 Epic 
 Movie

julia&gt; # one level only!

julia&gt; type Short &lt;: Movie
           plot
       end
ERROR: invalid subtyping in definition of Short
</code></p>

### Functions and stuff

Functions return last expression in body (like Perl)

<p><code>
julia> # functions

julia> function hello(name)
           "Hello $(name)!"
       end
hello (generic function with 1 method)

julia> hello("julia")
"Hello julia!"

julia> # default args

julia> function wd(a, b=10,c=11)
           println("a:$a b:$b c:$c")
       end
wd (generic function with 3 methods)

julia> wd(1,2)
a:1 b:2 c:11

julia> wd(1)
a:1 b:10 c:11

julia> wd()
ERROR: `wd` has no method matching wd()

julia> # using ... to turn last arg into collection

julia> function argv(args...)
           for arg in args
               println(arg)
           end
       end
argv (generic function with 1 method)

julia> argv(1,2,3,4,5)
1
2
3
4
5

julia> ## operators are just functions

julia> +(1,2)
3

julia> numbers = 1:10
1:10

julia> +(numbers...)
55
</code></p>

### Multiple dispatch

New concept, from Lisp. But like overloading, except you can overload by all argument types, rather than just the object which owns the method (or the first arg).

Versions of a function are called methods. But not like OOP methods.
<p><code>
julia&gt; # multiple dispatch for concatenation

julia&gt; function concat(a :: Int64, b :: Int64) ## the :: is what makes this a method not a fn
           zeros = int(ceil(log10(b+1)))
           a * 10^zeros +b
       end
concat (generic function with 1 method)

julia&gt; concat(11,12)
1112

julia&gt; # cant be used unless types fit

julia&gt; concat(11,"hat")
ERROR: `concat` has no method matching concat(::Int64, ::ASCIIString)

julia&gt; # so make one that does

julia&gt; function concat(a :: Int64, b :: ASCIIString) 
           "$a$b"
       end
concat (generic function with 2 methods)

julia&gt; concat(11,"hat")
"11hat"

julia&gt; # example of this being used in the libraries

julia&gt; methods(+)
# 117 methods for generic function "+":
+(x::Bool) at bool.jl:36
+(x::Bool,y::Bool) at bool.jl:39
+(y::FloatingPoint,x::Bool) at bool.jl:49
+(A::BitArray{N},B::BitArray{N}) at bitarray.jl:848
+(A::Union(DenseArray{Bool,N},SubArray{Bool,N,A&lt;:DenseArray{T,N},I&lt;:(Union(Int64,Range{Int64})...,)}),B::Union(DenseArray{Bool,N},SubArray{Bool,N,A&lt;:DenseArray{T,N},I&lt;:(Union(Int64,Range{Int64})...,)})) at array.jl:797
+{S,T}(A::Union(DenseArray{S,N},SubArray{S,N,A&lt;:DenseArray{T,N},I&lt;:(Union(Int64,Range{Int64})...,)}),B::Union(SubArray{T,N,A&lt;:DenseArray{T,N},I&lt;:(Union(Int64,Range{Int64})...,)},DenseArray{T,N})) at array.jl:719
+{T&lt;:Union(Int8,Int32,Int16)}(x::T&lt;:Union(Int8,Int32,Int16),y::T&lt;:Union(Int8,Int32,Int16)) at int.jl:16
+{T&lt;:Union(Uint32,Uint16,Uint8)}(x::T&lt;:Union(Uint32,Uint16,Uint8),y::T&lt;:Union(Uint32,Uint16,Uint8)) at int.jl:20
+(x::Int64,y::Int64) at int.jl:33
+(x::Uint64,y::Uint64) at int.jl:34
+(x::Int128,y::Int128) at int.jl:35
+(x::Uint128,y::Uint128) at int.jl:36
+(x::Float32,y::Float32) at float.jl:119
+(x::Float64,y::Float64) at float.jl:120
+(z::Complex{T&lt;:Real},w::Complex{T&lt;:Real}) at complex.jl:110
+(x::Real,z::Complex{T&lt;:Real}) at complex.jl:120
+(z::Complex{T&lt;:Real},x::Real) at complex.jl:121
+(x::Rational{T&lt;:Integer},y::Rational{T&lt;:Integer}) at rational.jl:113
+(x::Char,y::Char) at char.jl:23
+(x::Char,y::Integer) at char.jl:26
+(x::Integer,y::Char) at char.jl:27
+(a::Float16,b::Float16) at float16.jl:132
+(x::BigInt,y::BigInt) at gmp.jl:195
+(a::BigInt,b::BigInt,c::BigInt) at gmp.jl:218
+(a::BigInt,b::BigInt,c::BigInt,d::BigInt) at gmp.jl:224
+(a::BigInt,b::BigInt,c::BigInt,d::BigInt,e::BigInt) at gmp.jl:231
+(x::BigInt,c::Union(Uint32,Uint16,Uint8,Uint64)) at gmp.jl:243
+(c::Union(Uint32,Uint16,Uint8,Uint64),x::BigInt) at gmp.jl:247
+(x::BigInt,c::Union(Int64,Int8,Int32,Int16)) at gmp.jl:259
+(c::Union(Int64,Int8,Int32,Int16),x::BigInt) at gmp.jl:260
+(x::BigFloat,y::BigFloat) at mpfr.jl:149
+(x::BigFloat,c::Union(Uint32,Uint16,Uint8,Uint64)) at mpfr.jl:156
+(c::Union(Uint32,Uint16,Uint8,Uint64),x::BigFloat) at mpfr.jl:160
+(x::BigFloat,c::Union(Int64,Int8,Int32,Int16)) at mpfr.jl:164
+(c::Union(Int64,Int8,Int32,Int16),x::BigFloat) at mpfr.jl:168
+(x::BigFloat,c::Union(Float32,Float16,Float64)) at mpfr.jl:172
+(c::Union(Float32,Float16,Float64),x::BigFloat) at mpfr.jl:176
+(x::BigFloat,c::BigInt) at mpfr.jl:180
+(c::BigInt,x::BigFloat) at mpfr.jl:184
+(a::BigFloat,b::BigFloat,c::BigFloat) at mpfr.jl:255
+(a::BigFloat,b::BigFloat,c::BigFloat,d::BigFloat) at mpfr.jl:261
+(a::BigFloat,b::BigFloat,c::BigFloat,d::BigFloat,e::BigFloat) at mpfr.jl:268
+(x::MathConst{sym},y::MathConst{sym}) at constants.jl:23
+{T&lt;:Number}(x::T&lt;:Number,y::T&lt;:Number) at promotion.jl:188
+{T&lt;:FloatingPoint}(x::Bool,y::T&lt;:FloatingPoint) at bool.jl:46
+(x::Number,y::Number) at promotion.jl:158
+(x::Integer,y::Ptr{T}) at pointer.jl:68
+(x::Bool,A::AbstractArray{Bool,N}) at array.jl:767
+(x::Number) at operators.jl:71
+(r1::OrdinalRange{T,S},r2::OrdinalRange{T,S}) at operators.jl:325
+{T&lt;:FloatingPoint}(r1::FloatRange{T&lt;:FloatingPoint},r2::FloatRange{T&lt;:FloatingPoint}) at operators.jl:331
+(r1::FloatRange{T&lt;:FloatingPoint},r2::FloatRange{T&lt;:FloatingPoint}) at operators.jl:348
+(r1::FloatRange{T&lt;:FloatingPoint},r2::OrdinalRange{T,S}) at operators.jl:349
+(r1::OrdinalRange{T,S},r2::FloatRange{T&lt;:FloatingPoint}) at operators.jl:350
+(x::Ptr{T},y::Integer) at pointer.jl:66
+{S,T&lt;:Real}(A::Union(DenseArray{S,N},SubArray{S,N,A&lt;:DenseArray{T,N},I&lt;:(Union(Int64,Range{Int64})...,)}),B::Range{T&lt;:Real}) at array.jl:727
+{S&lt;:Real,T}(A::Range{S&lt;:Real},B::Union(SubArray{T,N,A&lt;:DenseArray{T,N},I&lt;:(Union(Int64,Range{Int64})...,)},DenseArray{T,N})) at array.jl:736
+(A::AbstractArray{Bool,N},x::Bool) at array.jl:766
+{Tv,Ti}(A::SparseMatrixCSC{Tv,Ti},B::SparseMatrixCSC{Tv,Ti}) at sparse/sparsematrix.jl:530
+{TvA,TiA,TvB,TiB}(A::SparseMatrixCSC{TvA,TiA},B::SparseMatrixCSC{TvB,TiB}) at sparse/sparsematrix.jl:522
+(A::SparseMatrixCSC{Tv,Ti&lt;:Integer},B::Array{T,N}) at sparse/sparsematrix.jl:621
+(A::Array{T,N},B::SparseMatrixCSC{Tv,Ti&lt;:Integer}) at sparse/sparsematrix.jl:623
+(A::SymTridiagonal{T},B::SymTridiagonal{T}) at linalg/tridiag.jl:45
+(A::Tridiagonal{T},B::Tridiagonal{T}) at linalg/tridiag.jl:207
+(A::Tridiagonal{T},B::SymTridiagonal{T}) at linalg/special.jl:99
+(A::SymTridiagonal{T},B::Tridiagonal{T}) at linalg/special.jl:98
+{T,MT,uplo}(A::Triangular{T,MT,uplo,IsUnit},B::Triangular{T,MT,uplo,IsUnit}) at linalg/triangular.jl:11
+{T,MT,uplo1,uplo2}(A::Triangular{T,MT,uplo1,IsUnit},B::Triangular{T,MT,uplo2,IsUnit}) at linalg/triangular.jl:12
+(Da::Diagonal{T},Db::Diagonal{T}) at linalg/diagonal.jl:44
+(A::Bidiagonal{T},B::Bidiagonal{T}) at linalg/bidiag.jl:92
+{T}(B::BitArray{2},J::UniformScaling{T}) at linalg/uniformscaling.jl:26
+(A::Diagonal{T},B::Bidiagonal{T}) at linalg/special.jl:89
+(A::Bidiagonal{T},B::Diagonal{T}) at linalg/special.jl:90
+(A::Diagonal{T},B::Tridiagonal{T}) at linalg/special.jl:89
+(A::Tridiagonal{T},B::Diagonal{T}) at linalg/special.jl:90
+(A::Diagonal{T},B::Triangular{T,S&lt;:AbstractArray{T,2},UpLo,IsUnit}) at linalg/special.jl:89
+(A::Triangular{T,S&lt;:AbstractArray{T,2},UpLo,IsUnit},B::Diagonal{T}) at linalg/special.jl:90
+(A::Diagonal{T},B::Array{T,2}) at linalg/special.jl:89
+(A::Array{T,2},B::Diagonal{T}) at linalg/special.jl:90
+(A::Bidiagonal{T},B::Tridiagonal{T}) at linalg/special.jl:89
+(A::Tridiagonal{T},B::Bidiagonal{T}) at linalg/special.jl:90
+(A::Bidiagonal{T},B::Triangular{T,S&lt;:AbstractArray{T,2},UpLo,IsUnit}) at linalg/special.jl:89
+(A::Triangular{T,S&lt;:AbstractArray{T,2},UpLo,IsUnit},B::Bidiagonal{T}) at linalg/special.jl:90
+(A::Bidiagonal{T},B::Array{T,2}) at linalg/special.jl:89
+(A::Array{T,2},B::Bidiagonal{T}) at linalg/special.jl:90
+(A::Tridiagonal{T},B::Triangular{T,S&lt;:AbstractArray{T,2},UpLo,IsUnit}) at linalg/special.jl:89
+(A::Triangular{T,S&lt;:AbstractArray{T,2},UpLo,IsUnit},B::Tridiagonal{T}) at linalg/special.jl:90
+(A::Tridiagonal{T},B::Array{T,2}) at linalg/special.jl:89
+(A::Array{T,2},B::Tridiagonal{T}) at linalg/special.jl:90
+(A::Triangular{T,S&lt;:AbstractArray{T,2},UpLo,IsUnit},B::Array{T,2}) at linalg/special.jl:89
+(A::Array{T,2},B::Triangular{T,S&lt;:AbstractArray{T,2},UpLo,IsUnit}) at linalg/special.jl:90
+(A::SymTridiagonal{T},B::Triangular{T,S&lt;:AbstractArray{T,2},UpLo,IsUnit}) at linalg/special.jl:98
+(A::Triangular{T,S&lt;:AbstractArray{T,2},UpLo,IsUnit},B::SymTridiagonal{T}) at linalg/special.jl:99
+(A::SymTridiagonal{T},B::Array{T,2}) at linalg/special.jl:98
+(A::Array{T,2},B::SymTridiagonal{T}) at linalg/special.jl:99
+(A::Diagonal{T},B::SymTridiagonal{T}) at linalg/special.jl:107
+(A::SymTridiagonal{T},B::Diagonal{T}) at linalg/special.jl:108
+(A::Bidiagonal{T},B::SymTridiagonal{T}) at linalg/special.jl:107
+(A::SymTridiagonal{T},B::Bidiagonal{T}) at linalg/special.jl:108
+{T&lt;:Number}(x::AbstractArray{T&lt;:Number,N}) at abstractarray.jl:362
+(A::AbstractArray{T,N},x::Number) at array.jl:770
+(x::Number,A::AbstractArray{T,N}) at array.jl:771
+(J1::UniformScaling{T&lt;:Number},J2::UniformScaling{T&lt;:Number}) at linalg/uniformscaling.jl:25
+(J::UniformScaling{T&lt;:Number},B::BitArray{2}) at linalg/uniformscaling.jl:27
+(J::UniformScaling{T&lt;:Number},A::AbstractArray{T,2}) at linalg/uniformscaling.jl:28
+(J::UniformScaling{T&lt;:Number},x::Number) at linalg/uniformscaling.jl:29
+(x::Number,J::UniformScaling{T&lt;:Number}) at linalg/uniformscaling.jl:30
+{TA,TJ}(A::AbstractArray{TA,2},J::UniformScaling{TJ}) at linalg/uniformscaling.jl:33
+{T}(a::HierarchicalValue{T},b::HierarchicalValue{T}) at pkg/resolve/versionweight.jl:19
+(a::VWPreBuildItem,b::VWPreBuildItem) at pkg/resolve/versionweight.jl:82
+(a::VWPreBuild,b::VWPreBuild) at pkg/resolve/versionweight.jl:120
+(a::VersionWeight,b::VersionWeight) at pkg/resolve/versionweight.jl:164
+(a::FieldValue,b::FieldValue) at pkg/resolve/fieldvalue.jl:41
+(a::Vec2,b::Vec2) at graphics.jl:60
+(bb1::BoundingBox,bb2::BoundingBox) at graphics.jl:123
+(a,b,c) at operators.jl:82
+(a,b,c,xs...) at operators.jl:83
</code></p>

## Concurrency

Because of focus on sci comp and numerical code, need good concurrency support. Works a lot like erlang -- message passing. You can start julia with -pN to specify that N processes should be launched or you can call addprocs, which creates new procs and returns their ids. You send and receive messages with remotecall and fetch (primitives)

<p><code>
julia&gt; # concurrency primitives

julia&gt; addprocs(2)
2-element Array{Any,1}:
 2
 3

julia&gt; workers()
2-element Array{Int64,1}:
 2
 3

julia&gt; rands0 = remotecall(2, rand, 1000000)
RemoteRef(2,1,4)

julia&gt; rands1 = remotecall(3, rand, 1000000)
RemoteRef(3,1,5)

julia&gt; println("not blocking")
not blocking

julia&gt; rand_list=fetch(rand0)
ERROR: rand0 not defined

julia&gt; rand_list=fetch(rands0)
1000000-element Array{Float64,1}:
 0.529314  
 0.576692  
 0.176814  
 0.656793  
 0.25648   
 0.0356286 
 0.847236  
 0.615763  
 0.176696  
 0.880948  
 0.273569  
 0.138948  
 0.00793348
 0.286705  
 0.535762  
 0.997137  
 0.150647  
 0.215143  
 0.00081997
 0.522468  
 0.167639  
 0.914874  
 0.58749   
 ⋮         
 0.0270976 
 0.835634  
 0.741396  
 0.94542   
 0.016425  
 0.969782  
 0.412281  
 0.332411  
 0.550159  
 0.50921   
 0.879257  
 0.0123729 
 0.424436  
 0.212398  
 0.0308748 
 0.392213  
 0.42321   
 0.626509  
 0.79847   
 0.500501  
 0.384461  
 0.97059 </code></p>

 Built in primitives are a bit dull, you can use some syntactic sugar (made of macros) instead. Coin flip example

<p><code>
julia&gt; function flip_serial(t)
           count = 0
           for i in 1:t
               count += int(randbool())
           end
           count
       end
flip_serial (generic function with 1 method)

julia&gt; flip_serial(10)
7

julia&gt; flip_serial(10)
2

julia&gt; flip_serial(10)
4

julia&gt; flip_serial(10)
3

julia&gt; @time flip_serial(1000000000)
elapsed time: 3.88902704 seconds (13896 bytes allocated)
499991996

julia&gt; # lets parallelize this. Nb: should be commutative bcs we don't know what order this will happen in!

julia&gt; function flip_parallel(t)
           @parallel (+) for i in 1:t
               int(randbool())
           end
       end
flip_parallel (generic function with 1 method)

julia&gt; @time flip_parallel(1000000000)
elapsed time: 2.824627988 seconds (11708888 bytes allocated)
500023195

julia&gt; @time flip_parallel(1000000000)
elapsed time: 2.18320093 seconds (47496 bytes allocated)
500013687

julia&gt; @time flip_serial(1000000000)
elapsed time: 3.898389312 seconds (96 bytes allocated)
500011222

julia&gt; # interesting memory consumption is a lot lower for both on second invocation parallel uses a lot more memory though!
</code></p>

Very brief look at some more syntax that is entailed in putting together an histogram.
<p><code>
julia&gt; function coin_histogram (trials, times)
           bars=zeros(times+1)
           for i in 1:trials
               bars[flip_parallel(times) + 1] += 1
           end
           hist = pmap((len -&gt; repeat("*", int(len))), bars)
           for line in hist
               println("|$line")
           end
       end
coin_histogram (generic function with 1 method)

julia&gt; coin_histogram(100,10)
|
|***
|****
|*******
|********************
|***************************
|************************
|************
|***
|
|

julia&gt; coin_histogram(1000,10)
|
|********
|***************************************************
|*****************************************************************************************************************************************
|***********************************************************************************************************************************************************************************************************************
|***************************************************************************************************************************************************************************************************************************
|************************************************************************************************************************************************************************************************************
|*******************************************************************************************************
|*************************************************
|**************
|

julia&gt; # OK so you would need some sort of scaling algotithim to make it fit in the screen

julia&gt; # and the RNG looks less random than I'd like too.
</code></p>
