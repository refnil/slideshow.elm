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
