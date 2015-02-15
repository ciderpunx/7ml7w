import Graphics.Element (..)
import Graphics.Collage (..)
import Color (..)
import Signal (Signal, map, foldp, (~), (<~))
import Signal as Signal
import Mouse
import Window
import String
import Time (Time, fps)
import Graphics.Input as Input 
import Graphics.Input.Field as F
import Text (..)

moveBy     = 1    -- number of pixels to ove by in each frame
frameRate  = 48   -- frame rate

type alias World = { w:Int, mx:Int, delta:Time }      -- collection of signals 
type alias Car   = { x:Int, ltr:Bool, vx:Int} -- a model of a car

main : Signal Element
main  = map showcar (foldp drive defaultcar world)


world : Signal World
world = World <~ Window.width
               ~ Mouse.x
               ~ (fps frameRate)

defaultcar : Car
defaultcar = {x=150, ltr=True, vx=moveBy}

drive : World -> Car -> Car
drive world car = 
   let ltr'  = if (car.x > ((world.w * 2) - 150)) || (car.x < 150)
               then not (car.ltr)
               else car.ltr
       vx'   = moveBy + round (toFloat (world.mx) / 100.00)
   in if ltr' 
       then { car | ltr<-ltr', x<-car.x+vx', vx<-vx' } 
       else { car | ltr<-ltr', x<-car.x-vx', vx<-vx' } 

showcar : Car -> Element
showcar car = 
  collage (car.x) 500
  [ carBottom
  , carTop |> moveY 30
  , tire |> move (-40, -28)
  , tire |> move (40, -28) 
  ]

carBottom = filled black (rect 160 50)
carTop    = filled black (rect 100 60)
tire      = filled red   (circle 24)
