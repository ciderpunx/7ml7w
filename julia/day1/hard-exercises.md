> Brush off your linear algebra knowledge and construct a 90-degree rotation matrix. Try rotating the unit vector [1;0;0] by multiplying it by your matrix.

OK, this was pretty hard. I had thought from reading the wikipedia article that I would have to be partially applying the functions, but then I watched a much more useful explanation on khan academy. Here is the video.

<div><iframe class="full-width-embed" src="https://www.youtube.com/embed/gkyuLPzfDV0" frameborder="0" allowfullscreen></iframe></div>

Once I grokked that, it seemed to me like the transformation matrix for rotating 90 degrees about the x-axis ought to be something like this, because my theta is 90 degrees.

<p><code>julia&gt; x90antiClockwise = [1 0 0; 0 cos(90) sin(90); 0 -sin(90) cos(90)]
3x3 Array{Float64,2}:
 1.0   0.0        0.0
 0.0  -0.448074   0.893997
 0.0  -0.893997  -0.448074</code></p>

<p><code>julia> y90antiClockwise = [ cos(90) 0 sin(90); 0 1 0; -sin(90) 0 cos(90) ]
3x3 Array{Float64,2}:
 -0.448074  0.0   0.893997
  0.0       1.0   0.0     
 -0.893997  0.0  -0.448074

julia> z90antiClockwise = [ cos(90) -sin(90) 0; sin(90) cos(90) 0; 0 0 1 ]
3x3 Array{Float64,2}:
 -0.448074  -0.893997  0.0
  0.893997  -0.448074  0.0
  0.0        0.0       1.0</code></p>

Now multiplying the unit vecotr by my various matrices goes thus.

<p><code>julia> x90antiClockwise * unit
3-element Array{Float64,1}:
 1.0
 0.0
 0.0

julia> y90antiClockwise * unit
3-element Array{Float64,1}:
 -0.448074
  0.0     
 -0.893997

julia> z90antiClockwise * unit
3-element Array{Float64,1}:
 -0.448074
  0.893997
  0.0     
</code></p>

It *seems* to make sense in my own imagination at least. Any mathemeticians reading?
