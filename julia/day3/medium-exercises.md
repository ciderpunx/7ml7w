> Modify the code to allow masking arbitrarily many coefficient, but always the N most important ones. Instead of calling blockdct6(img), you would call blockdct(img,6)

In implementing this one, I made the assumption that <q>arbitrarily many</q> would be bounded by our block size, so up a maximum of to 8x8 == 64 cells could be masked by calling make_mask(16) as we are working with 8x8 blocks. The algorithim could remain substantially the same, if you wanted to support different sized blocks.

I make a subsidiary function to deal with the mask making, it takes the width of the block being processed and an n for the number of "significant" coefficients.

<code><p>function make_mask(width,n)
  row_max = n
  arr=zeros(width,width)
  println(arr)
  for i=1:row_max
     for j=1:row_max
        if(j&lt;n-(i+1))
          arr[i,j]=1
        end
     end
  end
  arr
end

function blockdct(img, n)
  pixels = convert(Array{Float32}, img.data)
  y,x = size(pixels)

  outx = ifloor(x/8)
  outy = ifloor(y/8)

  bx = 1:8:outx*8
  by = 1:8:outy*8

  mask = make_mask(8,n)

  freqs = Array(Float32, (outy*8,outx*8))

  for i=bx, j=by
    freqs[j:j+7, i:i+7] = dct(pixels[j:j+7, i:i+7])
    freqs[j:j+7, i:i+7] .*= mask
  end

  freqs
end </p></code>

> Our codec outputs a frequency array as big as its input, even though most frequencies are zero. Instead, output only the non-zero frequencies for each block so that the output is smaller than the input. Modify the decoder to use the smaller input as well.

I spent a fair while trying to implement this myself, then in the process of reading the manual came across sparse and full which basically did what was neded. So in the spirit of not doing difficult shit when there is a library funtion to do it.

<code><p>function smaller_blockdct(img,n)
  sparse(blockdct(img,n))
end

function smaller_blockidct(freqs,n)
  blockidct(full(freqs))
end</p></code>

> Experiment with different block sizes to see how block size affects the appearance of coding artefacts. Try a large block size on an image containing lots of text and see what happens.

Everything gets a lot blockier! I parameterized the original functions on blocksize first of all. Now the code read as follows.

<code><p>function blockdct(img, n, bs)
  pixels = convert(Array{Float32}, img.data)
  y,x = size(pixels)

  outx = ifloor(x/bs)
  outy = ifloor(y/bs)

  bx = 1:bs:outx*bs
  by = 1:bs:outy*bs

  mask = make_mask(bs,n)

  freqs = Array(Float32, (outy*bs,outx*bs))

  for i=bx, j=by
    freqs[j:j+bs-1, i:i+bs-1] = dct(pixels[j:j+bs-1, i:i+bs-1])
    freqs[j:j+bs-1, i:i+bs-1] .*= mask
  end

  freqs
end
function blockidct(freqs,bs)
  y,x = size(freqs)
  bx = 1:bs:x
  by = 1:bs:y

  pixels = Array(Float32, size(freqs))
  for i=bx, j=by
    pixels[j:j+bs-1, i:i+bs-1] = idct(freqs[j:j+bs-1, i:i+bs-1]) 
  end
  grayim(pixels)
end</p></code>
