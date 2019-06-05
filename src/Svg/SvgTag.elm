module SvgTag exposing (..)

import Svg exposing (svg)
import Svg.Attributes exposing (viewBox, width)

tag children =
  svg 
    [ viewBox "-100 -100 200 200", width "300px" ] 
    children
