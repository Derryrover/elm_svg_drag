module SvgPolygon exposing (..)

import Html exposing (Html, div, text, input)
import Html.Attributes exposing (style, class,value)
import Svg exposing (circle, line, svg, g, polygon)
import Svg.Attributes exposing (viewBox, width, fill, points, r, cx, cy)

import Coordinate exposing(XY, toSvgString, listToString)
-- import SvgTag 

import List

type alias Model = 
  { one: XY
  , two: XY 
  , three: XY
  }

type Msg = None

init =
    (
      {
        one = { x = -50, y = -50 }
      , two = { x = 50, y = -50 }
      , three = { x = 0, y = 50 }
      }
      , Cmd.batch []
    )

view: Model -> Html a
view model = 
  g 
    [] 
    -- [
    ( List.concat
      [ [ polygon [fill "purple", points (listToString [model.one, model.two, model.three])] [] ]
      -- , [ circle [fill "blue", r "10", cx (String.fromFloat model.one.x), cy (String.fromFloat model.one.y)] [] ]
      , listToSelectionBalls [model.one, model.two, model.three]
      ]
    )
    -- ]

listToSelectionBalls: List Coordinate.XY ->  List (Html a)
listToSelectionBalls list = 
  List.map
    (\xy -> circle [fill "blue", r "10", cx (String.fromFloat xy.x), cy (String.fromFloat xy.y)] []) 
    list

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model = 
  case msg of
    None ->
      (model, Cmd.none)