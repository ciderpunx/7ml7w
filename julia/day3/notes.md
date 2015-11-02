# Day 3 notes

Macro system, image processing and larger example.

Macros operate on AST rather than on source code.

## Macros to transfor code instead of data

Quoting a var with : retruns Symbol -- which is  rep of a var in the AST. You can also quote code invocations (might need extra parens to help the parser). Expression type is Expr

names gives properties of data type, Expr has a head, args and typ field. We use frst 2, typ is used for type inference. Head can be :call or :(=) for assignment. Can construct Exprs just like other types and you can explicitly eval them.

<p><code>julia&gt; x=1
1

julia&gt; x
1

julia&gt; :x=1
ERROR: syntax: invalid assignment location

julia&gt; :(x=1)
:(x = 1)

julia&gt; :(println("Hello!"))
:(println("Hello!"))

julia&gt; e = :(println("Hello!"))
:(println("Hello!"))

julia&gt; typeof(e)
Expr

julia&gt; names(e)
3-element Array{Symbol,1}:
 :head
 :args
 :typ 

julia&gt; (e.head,e.args)
(:call,{:println,"Hello!"})

julia&gt; e = :(x = 5)
:(x = 5)

julia&gt; (e.head,e.args)
(:(=),{:x,5})

julia&gt; e = Expr(:call,+,1,2,3)
:((+)(1,2,3))

julia&gt; eval(e)
6</code></p>

Interpolation works within expressions (like unquote in Lisp). You can use quote to build macros in a more convenient way. 

Unless example: can&#8217;t do with functions as the branch gets evaluated before function invocation.

Really like this syntax. Its convenient.

<p><code>
julia&gt; s = "str"
"str"

julia&gt; :(println($s))
:(println("str"))

julia&gt; quote
           println($s)
       end
quote  # none, line 2:
    println("str")
end

julia&gt; ## example macro

julia&gt; macro unless(t, b)
           quote
               if(!$t)
                   $b
               end
           end
       end

julia&gt; a = [1,2,3]
3-element Array{Int64,1}:
 1
 2
 3

julia&gt; @unless isempty(a) println("a has elts")
a has elts

julia&gt; @unless in(a, 4) begin
           println("no 4 in a")
       end
no 4 in a
</code></p>

## Slicing and dicing images

Image compression talkedabout run lenght encoding With images we can transform to frequencies in 2 dimensions. The idea is to work out which parts are less important (lower frquencies) and looking for a better representation or throwing away less important data.

Julia doesn&#8217;t have a lib for loading images from arbitrary formats but does have a nice package manager

<p><code>
julia&gt; Pkg.add("Images")
INFO: Initializing package repository /home/charlie/.julia/v0.3
INFO: Cloning METADATA from git://github.com/JuliaLang/METADATA.jl
INFO: Cloning cache of BinDeps from git://github.com/JuliaLang/BinDeps.jl.git
INFO: Cloning cache of ColorTypes from git://github.com/JuliaGraphics/ColorTypes.jl.git
INFO: Cloning cache of ColorVectorSpace from git://github.com/JuliaGraphics/ColorVectorSpace.jl.git
INFO: Cloning cache of Colors from git://github.com/JuliaGraphics/Colors.jl.git
INFO: Cloning cache of Compat from git://github.com/JuliaLang/Compat.jl.git
INFO: Cloning cache of Dates from git://github.com/quinnj/Dates.jl.git
INFO: Cloning cache of Docile from git://github.com/MichaelHatherly/Docile.jl.git
INFO: Cloning cache of FixedPointNumbers from git://github.com/JeffBezanson/FixedPointNumbers.jl.git
INFO: Cloning cache of Graphics from git://github.com/JuliaLang/Graphics.jl.git
INFO: Cloning cache of HttpCommon from git://github.com/JuliaWeb/HttpCommon.jl.git
INFO: Cloning cache of Images from git://github.com/timholy/Images.jl.git
INFO: Cloning cache of Reexport from git://github.com/simonster/Reexport.jl.git
INFO: Cloning cache of SHA from git://github.com/staticfloat/SHA.jl.git
INFO: Cloning cache of SIUnits from git://github.com/Keno/SIUnits.jl.git
INFO: Cloning cache of TexExtensions from git://github.com/Keno/TexExtensions.jl.git
INFO: Cloning cache of URIParser from git://github.com/JuliaWeb/URIParser.jl.git
INFO: Cloning cache of Zlib from git://github.com/dcjones/Zlib.jl.git
INFO: Installing BinDeps v0.3.19
INFO: Installing ColorTypes v0.1.7
INFO: Installing ColorVectorSpace v0.0.5
INFO: Installing Colors v0.5.4
INFO: Installing Compat v0.7.7
INFO: Installing Dates v0.3.2
INFO: Installing Docile v0.5.19
INFO: Installing FixedPointNumbers v0.0.12
INFO: Installing Graphics v0.1.0
INFO: Installing HttpCommon v0.1.2
INFO: Installing Images v0.4.50
INFO: Installing Reexport v0.0.3
INFO: Installing SHA v0.1.2
INFO: Installing SIUnits v0.0.6
INFO: Installing TexExtensions v0.0.3
INFO: Installing URIParser v0.0.7
INFO: Installing Zlib v0.1.12
INFO: Building Images
INFO: Package database updated

julia&gt; Pkg.add("TestImages")
INFO: Cloning cache of TestImages from git://github.com/timholy/TestImages.jl.git
INFO: Cloning cache of ZipFile from git://github.com/fhs/ZipFile.jl.git
INFO: Installing TestImages v0.0.8
INFO: Installing ZipFile v0.2.5
INFO: Building Images
INFO: Building TestImages
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 4222k  100 4222k    0     0   516k      0  0:00:08  0:00:08 --:--:--  438k
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  622k  100  622k    0     0   250k      0  0:00:02  0:00:02 --:--:--  250k
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  803k  100  803k    0     0   331k      0  0:00:02  0:00:02 --:--:--  331k
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 65670    0 65670    0     0  11553      0 --:--:--  0:00:05 --:--:-- 15740
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 28353  100 28353    0     0  94378      0 --:--:-- --:--:-- --:--:-- 94510
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  768k    0  768k    0     0   245k      0 --:--:--  0:00:03 --:--:--  245k
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 56562  100 56562    0     0  61911      0 --:--:-- --:--:-- --:--:-- 61884
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
100 6358k  100 6358k    0     0  3851k      0  0:00:01  0:00:01 --:--:-- 4418k
INFO: Package database updated

julia&gt; Pkg.add("ImageView")
INFO: Cloning cache of Cairo from git://github.com/JuliaLang/Cairo.jl.git
INFO: Cloning cache of ImageView from git://github.com/timholy/ImageView.jl.git
INFO: Cloning cache of IniFile from git://github.com/JuliaLang/IniFile.jl.git
INFO: Cloning cache of Tk from git://github.com/JuliaLang/Tk.jl.git
INFO: Cloning cache of Winston from git://github.com/nolta/Winston.jl.git
INFO: Installing Cairo v0.2.31
INFO: Installing ImageView v0.1.18
INFO: Installing IniFile v0.2.4
INFO: Installing Tk v0.3.6
INFO: Installing Winston v0.11.13
INFO: Building Cairo
INFO: Building Images
INFO: Building Tk
INFO: Package database updated
</code></p>

Packages ready to use immediately. Load test image, have a look at the image and then have a look at the pixel data (use Float rather than Int as we will need to une some lib fns)

Next do a discrete cosine transform (like a fourier transform) to show the freqs of the pixels. Now have a look at Codec.jl for lossy compression.

<p><code>
julia&gt; using TestImages, ImageView
Warning: could not import Base.Text into Tk
Warning: using ImageView.display in module Main conflicts with an existing identifier.

julia&gt; img = testimage("cameraman")
Gray Image with:
  data: 512x512 Array{Gray{UfixedBase{Uint8,8}},2}
  properties:
    IMcs: Gray
    spatialorder:  x y
    pixelspacing:  1 1

julia&gt; view(img)
(ImageCanvas,ImageSlice2d: zoom = BoundingBox(0.0,512.0,0.0,512.0))

julia&gt; pixels = convert(Array{Float32}, img.data)

julia&gt; freqs = dct(pixels)

julia&gt; round(freqs)

512x512 Array{Float32,2}:
 238.0   45.0   30.0    4.0   8.0  -7.0  -7.0   6.0   3.0  …  -0.0  -0.0   0.0  -0.0   0.0  -0.0  -0.0  -0.0
 -33.0   13.0   20.0    0.0  -4.0  -5.0  -1.0   0.0   3.0      0.0   0.0  -0.0  -0.0   0.0   0.0  -0.0   0.0
  21.0    9.0  -26.0  -17.0  -1.0   1.0  -5.0   2.0   5.0      0.0  -0.0  -0.0   0.0  -0.0  -0.0   0.0  -0.0
  42.0   -5.0  -25.0   -8.0   2.0   6.0  -2.0   3.0  -0.0     -0.0  -0.0  -0.0  -0.0  -0.0   0.0   0.0  -0.0
  16.0  -23.0   -5.0    9.0   1.0   9.0   6.0   2.0  -5.0      0.0  -0.0   0.0   0.0  -0.0  -0.0   0.0  -0.0
   9.0  -15.0   -2.0    5.0   3.0   5.0   5.0  -2.0  -2.0  …  -0.0  -0.0   0.0  -0.0  -0.0   0.0  -0.0  -0.0
   1.0    0.0    3.0   -4.0   2.0   2.0  -7.0  -8.0   2.0      0.0  -0.0   0.0  -0.0   0.0   0.0  -0.0  -0.0
  -1.0    1.0    4.0    5.0  -5.0  -3.0  -3.0  -8.0  -1.0      0.0  -0.0   0.0  -0.0  -0.0   0.0   0.0  -0.0
  -6.0    2.0    2.0    2.0  -2.0  -2.0   5.0   0.0   1.0     -0.0   0.0   0.0   0.0  -0.0  -0.0  -0.0   0.0
  -5.0   -1.0    1.0   -0.0  -1.0  -1.0   7.0   2.0   2.0     -0.0   0.0   0.0   0.0   0.0  -0.0   0.0   0.0
  -3.0   -3.0    6.0    1.0  -3.0   1.0   1.0  -3.0   3.0  …  -0.0  -0.0  -0.0  -0.0  -0.0  -0.0  -0.0  -0.0
  -2.0    2.0    3.0    0.0  -3.0  -1.0  -0.0  -2.0  -0.0      0.0   0.0  -0.0  -0.0  -0.0  -0.0  -0.0  -0.0
  -2.0    6.0   -0.0   -5.0   1.0   0.0  -3.0   4.0   0.0      0.0   0.0   0.0  -0.0   0.0  -0.0  -0.0  -0.0
  -6.0    5.0   -1.0   -2.0   1.0   1.0  -4.0   3.0   4.0     -0.0   0.0   0.0  -0.0  -0.0  -0.0   0.0   0.0
  -5.0    2.0   -4.0    6.0   2.0  -4.0   3.0   1.0  -2.0      0.0  -0.0  -0.0   0.0   0.0   0.0  -0.0  -0.0
   3.0   -0.0   -5.0    1.0   3.0   2.0  -1.0   0.0  -2.0  …  -0.0  -0.0  -0.0   0.0  -0.0   0.0   0.0  -0.0
   3.0   -1.0    0.0   -3.0  -1.0   6.0  -3.0  -2.0   2.0      0.0   0.0  -0.0   0.0  -0.0  -0.0  -0.0  -0.0
  -0.0   -1.0    5.0   -3.0  -0.0  -2.0  -3.0   2.0  -0.0      0.0   0.0   0.0  -0.0   0.0  -0.0   0.0  -0.0
   2.0   -2.0    1.0   -2.0   5.0  -5.0  -2.0   5.0  -3.0     -0.0  -0.0  -0.0  -0.0  -0.0   0.0   0.0   0.0
   4.0   -2.0   -3.0   -1.0   2.0  -0.0   5.0  -3.0  -2.0     -0.0  -0.0   0.0   0.0  -0.0   0.0   0.0  -0.0
   1.0   -2.0    1.0   -0.0  -3.0   2.0   5.0  -3.0  -1.0  …   0.0   0.0   0.0  -0.0  -0.0  -0.0   0.0   0.0
  -2.0   -1.0    4.0    1.0  -4.0   2.0  -2.0   1.0   0.0     -0.0   0.0   0.0  -0.0   0.0  -0.0   0.0   0.0
  -0.0    1.0   -1.0    2.0  -0.0   1.0  -4.0  -0.0   0.0     -0.0  -0.0   0.0   0.0   0.0  -0.0  -0.0  -0.0
   ⋮                                ⋮                      ⋱         ⋮                             ⋮        
   0.0   -0.0   -0.0   -0.0  -0.0   0.0  -0.0  -0.0   0.0  …  -0.0   0.0   0.0  -0.0  -0.0  -0.0  -0.0   0.0
   0.0   -0.0    0.0    0.0  -0.0  -0.0  -0.0  -0.0   0.0     -0.0  -0.0   0.0   0.0   0.0   0.0  -0.0   0.0
   0.0   -0.0    0.0    0.0   0.0  -0.0  -0.0   0.0  -0.0      0.0   0.0  -0.0   0.0   0.0   0.0  -0.0  -0.0
   0.0    0.0   -0.0   -0.0   0.0  -0.0   0.0   0.0  -0.0      0.0   0.0  -0.0   0.0   0.0  -0.0  -0.0  -0.0
  -0.0    0.0    0.0   -0.0  -0.0   0.0  -0.0   0.0   0.0      0.0  -0.0  -0.0   0.0  -0.0   0.0   0.0  -0.0
   0.0   -0.0   -0.0   -0.0   0.0   0.0  -0.0   0.0   0.0  …   0.0  -0.0  -0.0  -0.0   0.0  -0.0  -0.0  -0.0
   0.0   -0.0   -0.0    0.0  -0.0   0.0   0.0   0.0   0.0      0.0   0.0  -0.0  -0.0  -0.0  -0.0  -0.0  -0.0
   0.0   -0.0   -0.0   -0.0   0.0  -0.0   0.0   0.0   0.0     -0.0  -0.0  -0.0  -0.0  -0.0  -0.0   0.0   0.0
  -0.0    0.0    0.0   -0.0   0.0   0.0  -0.0  -0.0   0.0     -0.0  -0.0  -0.0   0.0  -0.0   0.0   0.0  -0.0
   0.0    0.0    0.0   -0.0  -0.0  -0.0  -0.0   0.0  -0.0      0.0   0.0   0.0  -0.0  -0.0   0.0   0.0   0.0
   0.0   -0.0    0.0   -0.0  -0.0  -0.0  -0.0  -0.0  -0.0  …  -0.0   0.0  -0.0   0.0  -0.0   0.0   0.0   0.0
   0.0    0.0   -0.0   -0.0  -0.0  -0.0   0.0  -0.0  -0.0      0.0   0.0  -0.0  -0.0   0.0  -0.0   0.0   0.0
  -0.0    0.0    0.0   -0.0   0.0   0.0   0.0  -0.0  -0.0      0.0  -0.0   0.0   0.0  -0.0   0.0   0.0  -0.0
   0.0   -0.0    0.0    0.0  -0.0  -0.0  -0.0   0.0   0.0      0.0   0.0  -0.0   0.0  -0.0   0.0  -0.0  -0.0
   0.0   -0.0   -0.0    0.0   0.0   0.0   0.0  -0.0   0.0     -0.0   0.0   0.0  -0.0  -0.0  -0.0  -0.0   0.0
   0.0    0.0   -0.0    0.0   0.0  -0.0  -0.0  -0.0   0.0  …  -0.0  -0.0  -0.0   0.0   0.0   0.0  -0.0   0.0
   0.0    0.0   -0.0   -0.0   0.0   0.0   0.0  -0.0   0.0     -0.0   0.0  -0.0   0.0   0.0   0.0   0.0  -0.0
   0.0   -0.0   -0.0   -0.0   0.0   0.0   0.0  -0.0  -0.0      0.0   0.0   0.0  -0.0  -0.0  -0.0   0.0  -0.0
   0.0   -0.0   -0.0   -0.0  -0.0   0.0  -0.0   0.0  -0.0      0.0   0.0  -0.0   0.0  -0.0  -0.0  -0.0   0.0
   0.0    0.0    0.0   -0.0  -0.0  -0.0   0.0  -0.0  -0.0     -0.0  -0.0   0.0  -0.0   0.0   0.0   0.0   0.0
  -0.0    0.0    0.0   -0.0  -0.0  -0.0   0.0  -0.0  -0.0  …  -0.0   0.0   0.0  -0.0   0.0   0.0  -0.0   0.0
   0.0   -0.0    0.0   -0.0   0.0  -0.0   0.0  -0.0   0.0      0.0   0.0   0.0   0.0   0.0   0.0   0.0  -0.0
</code></p>


