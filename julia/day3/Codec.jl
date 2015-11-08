module Codec

using Images

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
        if(j<n-(i+1))
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
end

function blockdct(img, n, bs)
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

  freqs
end

function scaleupHighNumber(n)
  if n > 2
    n * 144
  else
    n
  end
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
  y,x = size(freqs)
  bx = 1:8:x
  by = 1:8:y

  pixels = Array(Float32, size(freqs))
  for i=bx, j=by
    pixels[j:j+7, i:i+7] = idct(freqs[j:j+7, i:i+7]) ## ./ 255.0 not needed in later versions of julia
  end
  grayim(pixels)
end

end # //module
