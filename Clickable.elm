module Clickable where

import open Graphics.Input
import open Mouse

clickable elem = 
    let (element, event) = hoverable elem
        elemClicked = sampleOn clicks event
    in (element,elemClicked)

onclick elem a =
    let (element, event) = clickable elem
    in (element, keepWhen event a <| constant a)

clickables a =
    let {events, hoverable} = hoverables a
        clickable val elem = hoverable (\x -> if x then val else a) elem
    in {events =keepWhen isClicked a events,clickable = clickable}
