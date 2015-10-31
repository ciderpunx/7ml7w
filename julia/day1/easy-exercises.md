> Use typeof to find the types of types. Try Symbol or Int64. Can you find the types of operators.

<p><code>julia&gt; typeof(+)
Function

julia&gt; typeof(Symbol)
DataType

julia&gt; typeof(Int64)
DataType

julia&gt; typeof(-)
Function

julia&gt; typeof(typeof)
Function</code></p>

> Create a typed dict with keys that are symbols and values that are floats. What happens when you add ::thisis =&gt; :notanumber to the Dict.


<p><code>julia&gt; mydict = [:a =&gt; 1, :b =&gt; 2, :c =&gt; 3]
Dict{Symbol,Int64} with 3 entries:
  :b =&gt; 2
  :c =&gt; 3
  :a =&gt; 1

julia&gt; mydict[:thisis]=:notanumber
ERROR: `convert` has no method matching convert(::Type{Int64}, ::Symbol)
 in setindex! at ./dict.jl:551</code></p>

It looks like Julia has a crack at co-ercing the types, but gives up when it cannot or if we lose data. For Example:
<p><code>julia&gt; mydict[:thisis]=:notanumber
ERROR: `convert` has no method matching convert(::Type{Int64}, ::Symbol)
 in setindex! at ./dict.jl:551

julia&gt; mydict[:thisis]=9.0
9.0

julia&gt; mydict[:thisis]=9.23
ERROR: InexactError()
 in setindex! at ./dict.jl:556</code></p>

> Create a 5x5x5 array where each 5x5 block in the first 2 dimensions is a single number but that number increases for each block. 

OK well I initialized an all zero array, then populated it in a for loop. There might be a way to do this in one step I guess.
<p><code>a = fill(0,(5,5,5))
for i in 1:5
  a[:,:,i]=i
end
println(a)</code></p>

> Run some arrays of various types through functions like sin and round. What happens?

Nice. It basically does what I think it should -- applying the function to each element of the array and type failing where it should.

<p><code>julia&gt; a=fill(1.9,(2,3))
2x3 Array{Float64,2}:
 1.9  1.9  1.9
 1.9  1.9  1.9

julia&gt; sin(cos(a))
2x3 Array{Float64,2}:
 -0.317687  -0.317687  -0.317687
 -0.317687  -0.317687  -0.317687

julia&gt; a=fill(:hat,(2,3))
2x3 Array{Symbol,2}:
 :hat  :hat  :hat
 :hat  :hat  :hat

julia&gt; sin(cos(a))
ERROR: `cos` has no method matching cos(::Array{Symbol,2})
</code></p>
