> Write a macro that runs a block of code backwards

Not quite sure what running code backwards really means here. I just deconstruct an expression, reverse its arguments and map eval over that. I suppose that is what was required.

<p><code>julia&gt; macro backwards(b)
         quote  
           map(eval,reverse($b.args))
           return
         end
       end

julia&gt; @backwards :(begin 
           println("one")
           println("two")
       end)
two
one </code></p>

> Experiment with modifying frequencies and observing the effect on an image. What happens when you set some high frequencies to large values? What happens if you add lots of noise? (Hint: try adding scale * rand(size(freqs))

Scaling up the higher numbers makes the image background much less detailed, effectively it ends up being white as you can see from the picture. My implementation is below.

<img src="//static.charlieharvey.org.uk/graphics/projects/cameraman-contrasty.jpg" class="bordered leftfloat" alt="cameraman image contrasty" />

<p class="rightfloat"><code>function blockdct6(img)
  pixels = convert(Array{Float32}, img.data)
  y,x = size(pixels)

  outx = ifloor(x/8)
  outy = ifloor(y/8)

  bx = 1:8:outx*8
  by = 1:8:outy*8

  mask = zeros(8,8)
  mask[1:3,1:3] = [1 1 1; 1 1 0; 1 0 0]  ## keep stuff marked 1, drop stuff that is 0

  freqs = Array(Float32, (outy*8,outx*8))

  for i=bx, j=by
    freqs[j:j+7, i:i+7] = dct(pixels[j:j+7, i:i+7])
    freqs[j:j+7, i:i+7] .*= mask
  end

  map(scaleupHighNumber, freqs)
end

function scaleupHighNumber(n)
  if n &gt; 2
    n * 144
  else
    n
  end
end</code></p>

Adding noise makes the image look significantly blockier, here is how I did that.

<p><code>
function blockdct6(img)
  pixels = convert(Array{Float32}, img.data)
  y,x = size(pixels)

  outx = ifloor(x/8)
  outy = ifloor(y/8)

  bx = 1:8:outx*8
  by = 1:8:outy*8

  mask = zeros(8,8)
  mask[1:3,1:3] = [1 1 1; 1 1 0; 1 0 0]  ## keep stuff marked 1, drop stuff that is 0

  freqs = Array(Float32, (outy*8,outx*8))

  for i=bx, j=by
    freqs[j:j+7, i:i+7] = dct(pixels[j:j+7, i:i+7])
    freqs[j:j+7, i:i+7] .*= mask
  end

  freqs .* rand(size(freqs))
end
</code></p>
