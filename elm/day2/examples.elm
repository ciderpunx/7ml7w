import Graphics.Element (..)
import Graphics.Collage (..)
import Color (..)
import Signal (Signal, channel, map, map2, foldp, sampleOn, send, subscribe)
import Signal as Signal
import Keyboard
import Mouse
import Window
import String
import Graphics.Input as Input 
import Graphics.Input.Field as F
import Text (..)

main =
  map2 display Window.dimensions Mouse.x
--  collage 300 300
--  [ carBottom
--  , carTop |> moveY 30
--  , tire |> move (-40, -28)
--  , tire |> move (40, -28)
--  ]
--  map scene (Signal.subscribe content)
--  keepArrows
--  map2 (div) Mouse.y Window.height
--  map asText clickPosition
  

shout = String.toUpper

whisper = String.toLower

echo xs = (shout xs) ++ " " ++ (whisper xs)

-- Things have changed a lot in 0.14. The following example
-- was super helpful infiguring out what was different:
-- http://elm-lang.org/edit/examples/Reactive/TextField.elm
scene : F.Content -> Element
scene fieldContent = 
  flow down
  [ F.field F.defaultStyle (send content) "Speak" fieldContent
  , plainText (echo fieldContent.string)
  ]
  
count = 
  foldp (\click total -> total + 1) 0 
  
clickPosition = 
  sampleOn Mouse.clicks Mouse.position
  
div x y = asText ((toFloat x) / (toFloat y))

keepArrows = map asText (foldp (\dir presses -> presses +dir.x) 0 Keyboard.arrows)

content : Signal.Channel F.Content
content = channel F.noContent

carBottom = filled black (rect 160 50)
carTop    = filled black (rect 100 60)
tire      = filled red (circle 24)

drawPaddle w h x = 
  filled black (rect 80 10)
  |> moveX ((minmax x w) - toFloat w / 2)
  |> moveY (toFloat h * -0.45 )

minmax x w = 
  if | x < 50    -> 50.0
     | x > w- 50 -> toFloat (w - 50)
     | otherwise -> toFloat x

display (w,h) x = 
  collage w h [drawPaddle w h x]
