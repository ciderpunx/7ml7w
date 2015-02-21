module LanguageHead where

import Color (..)
import Graphics.Collage (..)
import Graphics.Element (image)
import Keyboard
import List ((::), all, filter, length)
import List as List
import Mouse
import Random
import Random (float, int, generate, initialSeed)
import Signal (..)
import Text
import Text (asText, leftAligned, height, fromString, monospace)
import Time(..)

type State = Play | Pause | GameOver

type alias Input = { space:Bool, x:Int, delta:Time, rand:Int }
type alias Head = { x:Float, y:Float, vx:Float, vy:Float, img:String }
type alias Player = { x:Float, score:Int }
type alias Game = { state:State, heads:List Head, player:Player }

defaultHead n = {x=100.0, y=75, vx=60, vy=0.0, img=headImage' n }
defaultGame = { state   = Pause,
                heads   = [],
                player  = {x=0.0, score=0} }

headImage n =
  if | n == 0 -> "./img/brucetate.png"
     | n == 1 -> "./img/davethomas.png"
     | n == 2 -> "./img/evanczaplicki.png"
     | n == 3 -> "./img/joearmstrong.png"
     | n == 4 -> "./img/josevalim.png"
     | otherwise -> ""

-- Make the game choose a random head from a list of graphics
headList = [ "img/brucetate.png"
           , "img/davethomas.png"
           , "img/evanczaplicki.png"
           , "img/joearmstrong.png"
           , "img/josevalim.png" 
           ]
headListLen = length headList - 1

-- A partial function, to return the nth element of a list
-- like in Haskell We could wrap this in a maybe, but I 
-- bounds check anyway
infixl 9 !!
xs !! n  = List.head (List.drop n xs)

headImage' n = 
  if n > headListLen || n < 0
  then headList !! 1
  else headList !! n

bottom        = 550
secsPerFrame  = 1.0 / 50.0
delta         = inSeconds <~ fps 50

input = sampleOn delta (Input <~ Keyboard.space
                               ~ Mouse.x
                               ~ delta
                               ~ (range 0 headListLen) (every secsPerFrame)  )

-- Reintroduce the functionality of Random.range from 0.13
range x y
  = map (\n -> fst (generate (int x y) (initialSeed (round n))))

main = map display gameState

gameState = foldp stepGame defaultGame input

stepGame input game =
  case game.state of
    Play     -> stepGamePlay input game
    Pause    -> stepGamePaused input game
    GameOver -> stepGameFinished input game

stepGamePlay {space, x, delta, rand} ({state, heads, player} as game) =
  { game | state  <- stepGameOver x heads
         , heads  <- stepHeads heads delta x player.score rand state
         , player <- stepPlayer player x heads }

stepGameOver x heads =
  if allHeadsSafe (toFloat x) heads
  then Play
  else GameOver

allHeadsSafe x heads =
    all (headSafe x) heads

headSafe x head =
    head.y < bottom || abs (head.x - x) < 50

stepHeads heads delta x score rand state =
  spawnHead score heads rand
    |> bounceHeads
    |> removeComplete
    |> moveHeads delta

-- Add some random elements to when the heads get added so that all
-- of the games are no longer the same

-- don't show more than this number of heads at a time
maxConcurrentHeads = 3

-- Probability that a new head will be shown per evaluation
-- of sppawnHead all other factors being equal
newHeadProbability = 0.5


-- Witness the silliness of my random seeding strategy, just use the already
-- calculated rand and do spurious maths with it. It is only a games and this 
-- works OK (it isn't crypto!)
spawnHead score heads rand =
  let (addProbability, seed') = generate (float 0 1) (initialSeed (11+rand*36712))
      divideScoreBy = ((1+rand) * 1000)
      gapOK   = -- biggestHeadDeltaLessThan gapBetweenHeads heads
                all (\h -> h.x > gapBetweenHeads) heads
      addHead = length heads < (score // divideScoreBy + 1)
                && all (\head -> head.x > 107.0) heads
                && addProbability > newHeadProbability
                && List.length heads < maxConcurrentHeads
                && gapOK
  in if addHead 
     then defaultHead rand :: heads
     else heads

-- Don't allow another head to be added too closely to another head

-- I originally tried to keep an x gap of at least n between
-- heads, defined using gapBetweenHeads here, but realized that
-- Far simpler was to check that no head have an x less than
-- this number meaning that another head would not be added until
-- all heads were this far across the screen.
gapBetweenHeads : Float
gapBetweenHeads = 400.0

-- Asserts that all gaps between heads are less than n
-- not used now
biggestHeadDeltaLessThan : Float -> List Head -> Bool
biggestHeadDeltaLessThan n hs =
  all (\h -> h < n) (diffHeadXs (List.reverse hs))

-- get the gaps between all heads in a list of heads
-- assumes that the list is in order of x co-ordinate already
-- otherwise you could have cases 
diffHeadXs : List Head -> List Float
diffHeadXs hs =
  case hs of 
    []           -> []
    [h]          -> []
    h1::h2::tail -> abs (h1.x - h2.x) :: diffHeadXs tail

bounceHeads heads = 
  List.map bounce heads

-- Making heads bounce more times 
-- We can use gravity to mean that heads bounce less high
-- Default is 0.95
gravity = 0.95

bounce head =
  { head | vy <- if head.y > bottom && head.vy > 0
                 then -head.vy * gravity
                 else head.vy }

removeComplete heads =
  filter (\x -> not (complete x)) heads

complete {x} = x > 750

moveHeads delta heads = 
  List.map moveHead heads


-- Make heads bounce more times, reduce x movement
-- Larger number reduces x movement, 1 is default
xMoveFactor = 1

moveHead ({x, y, vx, vy} as head) =
  { head | x <- x + ((vx * secsPerFrame) / xMoveFactor)
         , y <- y + vy * secsPerFrame
         , vy <- vy + secsPerFrame * 400 }

stepPlayer player mouseX heads =
  { player | score <- stepScore player heads
           , x <- toFloat mouseX }

stepScore player heads =
  player.score +
  1 +
  1000 * (length (filter complete heads))

stepGamePaused {space, x, delta} ({state, heads, player} as game) =
  { game | state <- stepState space state
         , player <- { player |  x <- toFloat x } }

stepGameFinished {space, x, delta} ({state, heads, player} as game) =
  if space
  then defaultGame
  else { game | state <- GameOver
              , player <- { player |  x <- toFloat x } }

stepState space state = 
  if space
  then Play
  else state

display ({state, heads, player} as game) =
  let (w, h) = (800, 600)
  in collage w h
       ([ drawBuilding w h
        , drawRoad w h
        , drawPaddle w h player.x
        , drawScore w h player
        , drawMessage w h state
        ] ++ (drawHeads w h heads) )

drawRoad w h =
  -- filled gray (rect (toFloat w) 100)
  toForm (image 800 160 "img/road.jpg") 
  |> moveY (-(half h) + 50)

drawBuilding w h =
  --filled red (rect 100 (toFloat h))
  toForm (image 139 600 "img/tower-block.jpg") 
  |> moveX (-(half w) + 50)

drawHeads w h heads = 
  List.map (drawHead w h) heads

-- Show a different kind of head when one reaches the bottom
skullImg = "img/skull.png"
drawHead w h head =
  let x = half w - head.x
      y = half h - head.y
      src = if head.y >= bottom - 10
            then skullImg
            else head.img
  in toForm (image 75 75 src)
     --toForm (asText head.y)
     |> move (-x, y)
     |> rotate (degrees (x * 2 - 100))

drawPaddle w h x =
  filled black (rect 80 10)
  |> moveX ((minmaxPaddle x w) - toFloat w / 2)
  |> moveY (-(half h - 30))

-- I added this to keep the paddle in the game area
minmaxPaddle x w = 
  if | x < 50    -> 50.0
     | x > w- 50 -> toFloat (w - 50)
     | otherwise -> toFloat x


half x = toFloat x / 2

quarter x = toFloat x / 4

drawScore w h player =
  toForm (fullScore player)
  |> move (half w - 150, half h - 40)

fullScore player = 
  txt (Text.height 50) (toString player.score)

txt f = 
  leftAligned << f << monospace << Text.color blue << fromString

drawMessage w h state =
  toForm (txt (Text.height 50) (stateMessage state))
  |> move (50, 50)

-- Added another state here for showing press spacebar when 
-- game is in Paused state
stateMessage state =
  case state of
    GameOver  -> "Game Over" 
    Pause     -> "Press spacebar to start" 
    otherwise -> "Language Head"

