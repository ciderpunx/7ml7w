import Graphics.Element (..)
import Graphics.Collage (..)
import Color (..)
import Signal
import Text (asText)
import Time (every, second)
import Mouse
import Window


main = 
  Signal.map3 show Window.dimensions Mouse.isDown Mouse.position
  -- Signal.map asText count

count : Signal.Signal Int
count = 
  Signal.foldp (\click count -> count + 1) 0 (every second)

up   = filled red (circle 24)
down = filled red (circle 44)

drawCircle : Int -> Int -> Bool -> Int -> Int -> Form
drawCircle w h d x y = 
  case d of 
    True  -> down
              |> moveX (normalizeX x w)
              |> moveY (normalizeY y h)
    False -> up
              |> moveX (normalizeX x w)
              |> moveY (normalizeY y h)

normalizeX : Int -> Int -> Float
normalizeX x w = 
  (minmax x w) - toFloat w / 2

normalizeY : Int -> Int -> Float
normalizeY y h = 
  0 - ((minmax y h) - toFloat h / 2)

minmax : Int -> Int -> Float
minmax a d = 
  if | a < 44    -> 44.0
     | a > d-44  -> toFloat (d - 44) 
     | otherwise -> toFloat a 

show : (Int,Int) -> Bool -> (Int,Int) -> Element
show (w,h) d (x,y) = collage w h 
                [ drawCircle w h d x y ]
