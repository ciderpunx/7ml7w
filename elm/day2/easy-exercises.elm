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
  map2 asTx Mouse.position Mouse.isDown

-- Signal.map3 asTx' Mouse.x Mouse.y Mouse.isDown
toTx' x y d =
  let a = toString x
      b = toString y
      c = if d then " down." else " up."
   in asText ("Mouse is at (" ++ a ++ ", " ++ b ++ ") Mouse is" ++ c)

asTx p d =
  let a = toString (fst p)
      b = toString (snd p)
      c = if d then " Mouse is down." else " Mouse is up."
   in asText ("Mouse is at: (" ++ a ++ ", " ++ b ++ ")" ++ c)

-- main = yOnClick
yOnClick =
  Signal.map asText (Signal.sampleOn Mouse.clicks Mouse.y)

-- signal that fires every second
eSec =
  Signal.map asText (every second)
