module SvgPolygon exposing (..)

import Html exposing (Html, div, text, input)
import Html.Attributes exposing (style, class,value)
import Svg exposing (circle, line, svg, g, polygon, text_, text)
import Svg.Attributes exposing (viewBox, width, fill, points, r, cx, cy, x, y)
import Svg.Events exposing(onClick)

import Coordinate exposing(XY, toSvgString, listToString)

import MsgToCmd
import Maybe
import Uuid

import List

type alias Model = 
  { one: XY
  , two: XY 
  , three: XY
  , uuid: Maybe Uuid.Uuid
  }

type Msg = 
    None
  | Uuid (Maybe Uuid.Uuid)

init =
    (
      {
        one = { x = -50, y = -50 }
      , two = { x = 50, y = -50 }
      , three = { x = 0, y = 50 }
      , uuid = Nothing
      }
      , Cmd.batch [MsgToCmd.send (Uuid Nothing)]
    )

view: Model -> Html Msg
view model = 
  g 
    [] 
    -- [
    ( List.concat
      [ [ polygon [
        fill "purple", onClick (Uuid Nothing), points (listToString [model.one, model.two, model.three])] [] 
      ]
      -- , [ circle [fill "blue", r "10", cx (String.fromFloat model.one.x), cy (String.fromFloat model.one.y)] [] ]
      , listToSelectionBalls [model.one, model.two, model.three]
      , case model.uuid of
        Nothing -> [text_  [x "0", y "15", fill "red"] [text "Uuid placeholder!"]]
        Just uuid -> [text_  [x "0", y "15", fill "red"] [text (Uuid.toString uuid)]]
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
    Uuid maybeUuid ->
      case maybeUuid of
        Nothing ->
          (model, Cmd.none)
        Just uuid ->
          ({model | uuid = Just uuid} , Cmd.none)
    