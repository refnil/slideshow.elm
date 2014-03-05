import Slideshow as S

downing : S.Slide
downing = S.toSlide [ [markdown|
#First

test
|], [markdown|
#Second

better test
|] ] 

ss = [[markdown|
#elm
  
Author name
|],[markdown|
#Plan

    -elm
    -slideshow
|]]



main = S.show <| S.append (S.toSlideshow ss) [downing]
