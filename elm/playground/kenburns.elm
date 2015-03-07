import Color (..)
import Graphics.Collage (..)
import Graphics.Element (..)
import Signal (..)
import Mouse as Mouse
import Time (Time, fps, inMilliseconds, timestamp, every, second)
import Window
import List (head, tail)
import List as List
import Text (asText)
import Random (generate, float, initialSeed, Seed)
import AnimationFrame

-- The images for the slideshow
slideImages : List String
slideImages = [ "ciderniks-kingston-black.jpg"
              , "newtown-ciderpunx.jpg"
              , "westons-scrumpy.jpg"
              , "ross-on-wye-fucking-dry-cider.jpg"
              , "malvern-oak-cider.jpg"
              , "barkaiztegi-cider.jpg"
              , "crossmans-cider.jpg"
              ]
-- Where the files are (don't forget trailing /)
filePath : String
filePath = "/graphics/reviews/"

-- default slide (also first)
defSlideImg : String
defSlideImg = "henneys_vintage.jpg"

-- Width and height of your slides (they'll be shown a little smaller)
wdth = 810
hght = 480

-- Maximum amount you want to zoom in
maxZoom     = 1.8

-- Minimum zoom amount nb: this can mean images flying out of the canvas
minZoom     = 1.25

-- How much to pan and zoom by
pan  = 8
zoom = 0.8

-- Time fade in begins
fadeInTime = 2

-- How fast the fade in is
fadeInSpeed = 0.5

-- How long to show slides for
secsPerSlide = 4

-- Some tuneable defaults, that mostly work
initialZoom = 0.88
maxX = wdth/3
maxY = hght/3
minX = 0-maxX
minY = 0-maxY

-- TYPES
-- We are either playing our slides or not 
type Status = Playing | Paused

-- Convenience record for holding a random Float and a seed
type alias RndTuple = (Float, Seed)

-- Our various inputs
type alias World = { w:Int
                   , h:Int
                   , seed:Seed
                   , delta:Time
                   }

-- The slideshow itself
type alias Slideshow = { curSlide:Slide
                       , nextSlide:Slide
                       , slides:List Slide
                       , seed:Seed
                       , rndReady:Bool
                       , frames:Int
                       , status:Status
                       }
-- A slide
type alias Slide = { pic:Element 
                   , opacity:Float
                   , x:Float
                   , xv:Float
                   , y:Float
                   , yv:Float
                   , zoom:Float
                   , zv:Float
                   }

-- DEFAULTS

-- The default slideshow we will use, start paused
-- and the cur slide can be empty. Being paused means we
-- will immediately trigger a next slide, which will be nxt
defSlideshow : Slideshow
defSlideshow = 
  let cur =  defSlide
      nxt =  defSlide
  in  { curSlide  = cur
      , nextSlide = { nxt | xv <- 0.04, yv <- -0.02, zv<-0.002 }
      , slides    = mkSlides slideImages
      , seed      = initialSeed 1
      , rndReady  = False
      , frames    = 0
      , status    = Paused
      }

-- Default slide for when we need to make them
defSlide : Slide
defSlide = { opacity = 0
            , pic    = mkImg defSlideImg
            , x      = 0
            , xv     = 0
            , y      = 0
            , yv     = -0
            , zoom   = initialZoom
            , zv     = 0.0001
            }

-- A time signal
delta : Signal Float
delta = AnimationFrame.frame -- or fps 60

-- Default world, containing our input signals
defWorld : Signal World
defWorld = World <~ Window.width 
                  ~ Window.height 
                  ~ seed
                  ~ delta

-- ACTIONS

-- Render a slideshow in the world
show : World -> Slideshow -> Element
show w s =
  let cur = s.curSlide
      nxt = s.nextSlide
  in  collage (wdth - wdth//4) (hght - hght//4)
      [  renderSlidePic cur
      ,  renderSlidePic nxt
      --,  move (0,-120) <| toForm <| color green <| asText (cur.xv)
      ] 
      |> container w.w w.h middle
      |> color black

-- Given a world and a slideshow, return a slideshow stepped once in time
stepShow : World -> Slideshow -> Slideshow
stepShow w s =
  let cur     = panZoomFade s.curSlide 
      nxt     = panZoomFade s.nextSlide
      time    = s.frames//60
      fadeIn  = if time > fadeInTime then nxt.opacity + (fadeInSpeed/100) else nxt.opacity
      fadeOut = 1 - (2*fadeIn)
      advance = inBounds nxt cur time w
   in if advance && s.status == Playing
      then {s  | curSlide  <- { cur | opacity <- fadeOut }
               , nextSlide <- { nxt | opacity <- fadeIn  }
               , frames    <- s.frames+1 }
      else nextSlide w s

-- Prepare next slide for showing, initialize slide after that
nextSlide : World -> Slideshow -> Slideshow
nextSlide w s = 
  let slides'     = cycle s.slides
      -- If we have not yet initialized our random seed, grab
      -- it from the world. Otherwise, use what we have
      seed'       = if s.rndReady then s.seed else w.seed 
      (x,y,z,iz)  = getRandomSlideParams seed'
      cur         = s.nextSlide
      nxt         = getNextSlide slides'
   in { s | curSlide  <- cur
          , nextSlide <- { nxt | x  <- 0
                               , xv <- (fst x)/5
                               , y  <- 0
                               , yv <- (fst y)/5
                               , zv <- 0.0003 + (fst z)/1000
                               , opacity <- 0
                               , zoom    <- fst iz
                               }
          , slides    <- slides'
          , seed      <- snd iz
          , rndReady  <- True
          , frames    <- 0 
          , status    <- Playing }

-- HELPERS

-- Given a slide, hand back a Form scaled and zoomed by the correct 
-- amount
renderSlidePic : Slide -> Form
renderSlidePic s = scale s.zoom 
                        <| move (s.x,s.y)
                        <| toForm
                        <| opacity s.opacity
                        <| s.pic

-- Are our current and next slides within the frame, and 
-- is their cross fade incomplete? 
inBounds n c t w = c.x < (toFloat w.w) - (toFloat wdth) 
               && c.zoom < maxZoom
               && n.opacity < 1
               && (t <= secsPerSlide)

-- Apply x and y panning and zooming to a slide
panZoomFade : Slide -> Slide
panZoomFade s = zoomCalc <| panY s.y <| (panX s.x s)

-- Return a slide, zoomed
zoomCalc : Slide -> Slide
zoomCalc s = {s | zoom <- s.zoom + (s.zv * zoom)}

-- Return a slide panned x in X compared with s
panX : Float -> Slide -> Slide
panX x s = 
   let xv' = if s.x > maxX || s.x < minX then 0 else s.xv 
       x'  = if xv' == 0 then s.x else s.x + (s.xv * pan)
    in { s | x<-x', xv<-xv' }

-- Return a slide panned y in Y compared with s
panY y s = 
   let yv' = if s.x > maxY || s.y < minY then 0 else s.yv 
       y'  = if yv' == 0 then s.y else s.x + (s.yv * pan)
    in { s | y<-y', yv<-yv' }

-- Given a list of filenames, give me a list of Slides with 
-- those strings as their pics
mkSlides : List String -> List Slide
mkSlides = List.map mkSlide 

-- Make a slide for a single picture string
mkSlide : String -> Slide
mkSlide str = { defSlide | pic <- mkImg str }

-- Makes a fitted image for a slide's pic element
mkImg : String -> Element
mkImg str = (fittedImage wdth hght (mkImgStr str))

-- Prepends filePath to images, saves some typing
mkImgStr : String -> String
mkImgStr s =  filePath ++ s

-- Creates a random time-based signal (to pipe into the world)
seed : Signal Seed
seed = (\ (t, _) -> initialSeed <| round t) <~ timestamp (constant ())

-- Used by nextSlide to get some random params for zooming, panning and whatnot
getRandomSlideParams : Seed -> (RndTuple, RndTuple, RndTuple, RndTuple)
getRandomSlideParams seed =
  let z = nextZoom seed
      x = nextPan (snd z)
      y = nextPan (snd x)
      iz = newInitZoom (snd y)
   in (x,y,z,iz)

-- Used to generate random Floats in the right range for 
-- getRandomSlideParams
nextZoom s    = (generate (float 0 1) s)
newInitZoom s = (generate (float minZoom (maxZoom * 0.75)) s)
nextPan  s    = (generate (float -1 1) s)

-- Pulls the next slide off the head of a list of slides
getNextSlide : List Slide -> Slide
getNextSlide slides = head slides

-- Given a list advance the list by one, putting
-- the head at the back of the list. Used to get next slide
cycle slides = tail slides ++ [head slides]

main : Signal Element
main = map2 show defWorld (foldp stepShow defSlideshow defWorld)
