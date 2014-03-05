module Slideshow where

import Keyboard
import Window
import open Graphics.Input

--Model
data Slide = Slide [Element] Element [Element]
data Slideshow = Slideshow [Slide] Slide [Slide]

toSlideshow es = 
    let l = map (\x -> (Slide [] x [])) es
    in (Slideshow [] (head l) (tail l))

toSlide (x::xs) = Slide [] x xs

append (Slideshow l e r) a = Slideshow l e (r ++ a)

--Input
data MoveInput = None | Left | Right | Up | Down
input = 
    let arrowToMove arr = if 
          | arr.y == 1 -> Up
          | arr.y == -1 -> Down
          | arr.x == -1 -> Left
          | arr.x == 1 -> Right
          | otherwise -> None
    in lift arrowToMove Keyboard.arrows


--Update
update move sl = 
    let (Slideshow l s r) = sl
        (Slide u e d) = s
    in if is move sl
    then case move of
        Up -> Slideshow l (Slide (tail u) (head u) (e::d)) r
        Down -> Slideshow l (Slide (e::u) (head d) (tail d)) r
        Left -> Slideshow (tail l) (head l) (s::r)
        Right -> Slideshow (s::l) (head r) (tail r)
        None -> sl
    else sl

--Render
currentSlide (Slideshow _ (Slide _ e _) _) = e

is move slide = case move of 
    None -> True
    Up -> isUp slide
    Down -> isDown slide
    Left -> isLeft slide
    Right -> isRight slide

isUp (Slideshow _ (Slide u _ _ ) _) = if 
    | u == [] -> False
    | otherwise -> True

isDown (Slideshow _ (Slide _ _ u ) _) = if 
    | u == [] -> False
    | otherwise -> True
  
isLeft (Slideshow u _ _) = if 
    | u == [] -> False
    | otherwise -> True

isRight (Slideshow _ _ u) = if 
    | u == [] -> False
    | otherwise -> True

arrow customButton slide = 
    let triangle = filled blue <| ngon 3 30
        size = 60
        rot = map degrees [0,90,180,270]
        pos = [midRight, midTop, midLeft, midBottom]
        event = [Right, Up, Left, Down]
        createButton a e = customButton a e e e
        filler = spacer size size
        place [r,u,l,d] = flow down
            [flow right [filler,u,filler],
             flow right [l,filler,r],
             flow right [filler,d, filler]]
    in map (flip rotate triangle) rot 
        |> map (flip (::) [])
        |> map (collage size size)
        |> zip event
        |> map (uncurry createButton)
        |> place

resize (x,y) e = 
    let s = min ((toFloat x) / (toFloat <| widthOf e)) ((toFloat (y-200)) / (toFloat <| heightOf e))
    in collage x y [scale s (toForm e)] 

show s = 
    let {events, customButton}  = customButtons None
        slideState = foldp update s <| merge input events
        current = currentSlide <~ slideState
        slide = lift2 resize Window.dimensions current
        arr = lift2 (\(x,y) e -> container x y bottomRight e) Window.dimensions <| arrow customButton <~ slideState
    in lift (flow outward) <| combine [slide,arr,lift asText <| merge input events] 
