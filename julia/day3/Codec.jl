module Codec

using Images

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

  map(scaleupHighNumber, freqs)
end

function scaleupHighNumber(n)
  if n > 2
    n * 144
  else
    n
  end
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
