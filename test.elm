import Slideshow as S

ss = [[markdown|
#elm
  
Author name
|],[markdown|
#Plan

    -elm
    -slideshow
|],[markdown|
#Some more list

    -1
    -2
    -3

|]]

main = S.show <| S.toSlideshow ss
