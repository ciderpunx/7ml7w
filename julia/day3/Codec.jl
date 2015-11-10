module Codec

using Images, Colors, ImageView

function smaller_blockdct(img,n)
  sparse(blockdct(img,n))
end

function smaller_blockidct(freqs,n)
  blockidct(full(freqs))
end

function make_mask(width,n)
  row_max = n
  arr=zeros(width,width)
  for i=1:row_max
     for j=1:row_max
        if(j&lt;n-(i+1))
          arr[i,j]=1
        end
     end
  end
  arr
end

function rgb_blockdct (img, n, bs)
  freqs = convert(Array{Float32}, data(separate(img)))
  y,x,cdim = size(freqs)
  for i in 1:cdim
    freqs[1:y,1:x,i]  = inner_blockdct(freqs[1:y,1:x,i],n,bs)
  end
  freqs
end

function rgb_blockidct (freqs, bs)
  y,x,cdim = size(freqs)
  for i in 1:cdim
    freqs[1:y,1:x,i]  = blockidct(freqs[1:y,1:x,i],bs)
  end
  convert(Image{RGB}, freqs)
  # colorim(freqs)
end

function blockdct(img, n, bs)
  pixels = convert(Array{Float32}, img.data)
  inner_blockdct(pixels, n, bs)
end

function blockdct(img, n)
  blockdct(img, n, 8)
end

function blockdct6(img)
  blockdct(img, 6)
end

# this is the actual work part that calls dct (we crack out this part as it is called
# per colo[u]r dimension for colo[u]r images
function inner_blockdct(pixels, n, bs)
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
end

function blockidct(freqs)
  blockidct(freqs,8)
end

function scaleupHighNumber(n)
  if n &gt; 2
    n * 144
  else
    n
  end
end

end # //module
