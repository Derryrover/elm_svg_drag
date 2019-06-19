module SvgTag exposing (..)

import Svg exposing (svg)
import Svg.Attributes exposing (viewBox, width)

import SvgTypes exposing (Viewbox, viewBoxToString)


viewbox: Viewbox
viewbox =
  { xLeft = -100
  , yTop = -100
  , width = 200
  , height = 200
  }


tag children =
  svg 
    [ 
      -- viewBox "-100 -100 200 200"
    -- , 
      viewBox (viewBoxToString viewbox)
    , width "300px" ] 
    (children viewbox)
