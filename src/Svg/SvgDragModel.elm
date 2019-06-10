module SvgDragModel exposing(..)

import Coordinate
import Maybe

type WhichCorner =  One
  | Two
  | Three


type alias Model = 
  Maybe 
  {
    itemDragged: WhichCorner
  , dragStart: Coordinate.XY
  }

init = Nothing