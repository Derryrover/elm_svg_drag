module SvgDragModel exposing(..)

import Html
import Json.Decode as Json
import Svg exposing (Svg)
import Svg.Attributes exposing (..)
import Svg.Events exposing(..)
import Task
import VirtualDom

import Coordinate
import Maybe

type WhichCorner =  One
  | Two
  | Three

type MouseMove = MouseMove Position

type alias Model = 
  Maybe 
  {
    itemDragged: WhichCorner
  , dragStart: Coordinate.XY
  , originalPositionBall: Coordinate.XY
  }

init = Nothing

{-| These options are an attempt to prevent double- and triple-clicking from
propagating and selecting text outside the SVG scene. Doesn't work.
-}
options =
    { preventDefault = True, stopPropagation = True }

type alias Position =
  { x : Int, y : Int }

offsetPosition : Json.Decoder Position
offsetPosition =
  Json.map2 Position (Json.field "offsetX" Json.int) (Json.field "offsetY" Json.int)

-- customMouseDown = VirtualDom.onWithOptions "mousemove" options (Json.map MouseMove offsetPosition)
--customMouseDown = VirtualDom.on "mousemove" (Json.map MouseMove offsetPosition)

--onClick : msg -> Attribute msg
onClick msg =
  --on "click" (Json.succeed msg)
  on "click" (Json.map2 Position (Json.field "offsetX" Json.int) (Json.field "offsetY" Json.int))