> The code currently only works on grayscale images, but the same technique works on colour too. Modify the code to work on colour images like testimage("mandrill")

This was actually a pretty straightforward refactor. For RGB images, the [Images.jl library](https://github.com/timholy/Images.jl) stores each colour component as a grey-like array so you go from having a 2d representation of an image to a 3d one. Which means that processing colour images is just running the grey code for each colour dimension. 

I was able to hack a working implementation together at breakfast one day. Here&#8217;s the code.

> JPEG does prediction of the first coefficient, called the DC offset. The previous block&#8217;s DC value is subtracted from the current block&#8217;s DC value. This encodes an offset instead of a number with full range, saving valuable bits. Try implementing this in code.

Hmmm. I think this is an exercise to return to. I will need to re-read the wikipedia article and probably dig round some implementations to understand exactly what it is asking. I am going to leave it for another day and move on.
