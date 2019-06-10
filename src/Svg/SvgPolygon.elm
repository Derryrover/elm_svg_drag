module SvgPolygon exposing (..)

import Html exposing (Html, div, text, input)
import Html.Attributes exposing (style, class,value)
import Svg exposing (circle, line, svg, g, polygon, text_, text)
import Svg.Attributes exposing (viewBox, width, fill, points, r, cx, cy, x, y)
import Svg.Events exposing(onClick, onMouseDown)

import Coordinate exposing(XY, toSvgString, listToString)
import UuidTag
import SvgDragModel exposing(WhichCorner(..))

import MsgToCmd
import Maybe
import Uuid

import List

type alias UuidCoordinat = UuidTag.UuidTagged Coordinate.XY

type alias TaggedTriangle = { xy: XY, w: WhichCorner }

type alias Model = 
  { one: TaggedTriangle
  , two: TaggedTriangle
  , three: TaggedTriangle
  , uuid: Maybe Uuid.Uuid
  , drag: SvgDragModel.Model
  }

type Msg = 
    None
  | Uuid (Maybe Uuid.Uuid)
  | MouseDownSelectionBall WhichCorner Coordinate.XY



init: (Model, Cmd Msg)
init =
    (
      {
        one = { xy = { x = -50, y = -50.0 }, w = One }
      , two = { xy = { x = 50.0, y = -50.0 }, w = Two }
      , three = { xy = { x = 0.0, y = 50.0 }, w = Three }
      , uuid = Nothing
      , drag = Nothing
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
        fill "purple", onClick (Uuid Nothing), points (listToString [model.one.xy, model.two.xy, model.three.xy])] [] 
      ]
      -- , [ circle [fill "blue", r "10", cx (String.fromFloat model.one.x), cy (String.fromFloat model.one.y)] [] ]
      , listToSelectionBalls [model.one, model.two, model.three]
      , case model.uuid of
        Nothing -> [text_  [x "0", y "15", fill "red"] [text "Uuid placeholder!"]]
        Just uuid -> [text_  [x "0", y "15", fill "red"] [text (Uuid.toString uuid)]]
      ]
    )
    -- ]

--listToSelectionBalls: List Coordinate.XY ->  List (Html a)
listToSelectionBalls list = 
  List.map
    (\item -> circle 
      [fill "blue", r "10", cx (String.fromFloat item.xy.x), cy (String.fromFloat item.xy.y), onMouseDown (MouseDownSelectionBall item.w {x=1, y=1})] 
      []) 
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
    MouseDownSelectionBall whichCorner xy ->
      ({model | 
        drag = Just {
          itemDragged = whichCorner
        , dragStart = xy
        }
      },Cmd.none)