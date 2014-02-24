module Slideshow where

import Keyboard
import Window

--Model
data Slide = Slide [Element] Element [Element]
data Slideshow = Slideshow [Slide] Slide [Slide]

toSlideshow es = 
    let l = map (\x -> (Slide [] x [])) es
    in (Slideshow [] (head l) (tail l))

toSlide (x::xs) = Slide [] x xs

--Input
input = Keyboard.arrows

--Update
upDown y (Slideshow l s r) = 
    let (Slide u e d) = s
    in if | (y < 0) && (not (isEmpty d)) -> 
            (Slideshow l (Slide (e::u) (head d) (tail d)) r)
          | (y > 0) && (not (isEmpty u)) -> 
            (Slideshow l (Slide (tail u) (head u) (e::d)) r)
          | otherwise -> Slideshow l s r
          
leftRigth x (Slideshow l s r) = 
    if  | (x < 0) && (not (isEmpty l)) ->
            Slideshow (tail l) (head l) (s::r)
        | (x > 0) && (not (isEmpty r)) ->
            Slideshow (s::l) (head r) (tail r)
        | otherwise -> Slideshow l s r
                
update i s = upDown i.y (leftRigth i.x s)

--Render
currentSlide (Slideshow _ (Slide _ e _) _) = e

aggrandi (x,y) e = collage x y [scale 2 (toForm e)]

show s = 
    let gameState = foldp update s input
        c = currentSlide <~ gameState
    in lift2 aggrandi Window.dimensions c