module SvgPolygon exposing (..)

import Html exposing (Html, div, text, input)
import Html.Attributes exposing (style, class,value)
import Svg exposing (circle, line, svg, g, polygon, text_, text)
import Svg.Attributes exposing (viewBox, width, fill, points, r, cx, cy, x, y)
import Svg.Events exposing(onClick, onMouseDown, onMouseUp, on)

import Coordinate exposing(XY, toSvgString, listToString)
import UuidTag
import SvgDragModel exposing(WhichCorner(..))

import MsgToCmd
import Maybe
import Uuid
import Json.Decode as Json


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
  | MouseDownSelectionBall WhichCorner Coordinate.XY Coordinate.XY
  | MouseMove Coordinate.XY
  | MouseUp



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
    [ onMouseUp MouseUp
    , onMouseMoveWithCoordinates
    ] 
    -- [
    ( List.concat
      [ [ polygon [
        fill "purple", onMouseUp MouseUp, onClick (Uuid Nothing), points (listToString [model.one.xy, model.two.xy, model.three.xy])] [] 
      ]
      -- , [ circle [fill "blue", r "10", cx (String.fromFloat model.one.x), cy (String.fromFloat model.one.y)] [] ]
      , listToSelectionBalls [model.one, model.two, model.three]
      -- , case model.uuid of
      --   Nothing -> [text_  [x "0", y "15", fill "red"] [text "Uuid placeholder!"]]
      --   Just uuid -> [text_  [x "0", y "15", fill "red"] [text (Uuid.toString uuid)]]
      , case model.drag of
        Nothing -> [text_  [x "0", y "15", fill "red"] [text "drag placeholder!"]]
        Just drag -> [text_  [x "0", y "15", fill "red"] [text (String.fromFloat drag.dragStart.x)]]
      ]
    )
    -- ]


-- onMouseDownWithCoordinates msg =
--   --on "click" (Json.succeed msg)
--   on "mouseDown" (Json.map2 Position (Json.field "offsetX" Json.int) (Json.field "offsetY" Json.int))

onMouseDownWithCoordinates whichTriangle circleCoordinates =
  on 
    "mousedown" 
    ( Json.map2 
      (\x y -> MouseDownSelectionBall whichTriangle {x=toFloat x,y=toFloat y} circleCoordinates) 
      -- (Json.field "offsetX" Json.int) 
      -- (Json.field "offsetY" Json.int)
      -- (Json.field "clientX" Json.int) 
      -- (Json.field "clientY" Json.int)
      -- (Json.field "layerX" Json.int) 
      -- (Json.field "layerY" Json.int)
      (Json.field "clientX" Json.int) 
      (Json.field "clientY" Json.int)
    )

onMouseMoveWithCoordinates =
  on 
    "mousemove" 
    ( Json.map2 
      (\x y -> MouseMove {x=toFloat x,y=toFloat y}) 
      (Json.field "clientX" Json.int) 
      (Json.field "clientY" Json.int)
    )

--listToSelectionBalls: List Coordinate.XY ->  List (Html a)
listToSelectionBalls list = 
  List.map
    (\item -> circle 
      -- [fill "blue", r "10", cx (String.fromFloat item.xy.x), cy (String.fromFloat item.xy.y), 
      --onMouseDown (MouseDownSelectionBall item.w {x=1, y=1} item.xy)] 
      [ fill "blue"
      , r "10"
      , cx (String.fromFloat item.xy.x)
      , cy (String.fromFloat item.xy.y)
      , onMouseDownWithCoordinates item.w item.xy
      , onMouseUp MouseUp
      ] 
      []
    ) 
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
    MouseDownSelectionBall whichCorner xyDragStart xyBall ->
      ({model | 
        drag = Just {
          itemDragged = whichCorner
        , dragStart = xyDragStart
        , originalPositionBall = xyBall
        }
      },Cmd.none)
    MouseUp ->
      ( { model | drag = Nothing } ,Cmd.none )
    MouseMove xy ->
      case model.drag of
        Nothing ->
          (model,Cmd.none )
        Just dragModel ->
          let
            deltaX = dragModel.dragStart.x - xy.x
            deltaY = dragModel.dragStart.y - xy.y
            newCoordinat = { x = dragModel.originalPositionBall.x - deltaX
                          , y = dragModel.originalPositionBall.y - deltaY }
          in
            case dragModel.itemDragged of
              One ->
                ( { model | one = {xy=newCoordinat, w=One}} ,Cmd.none )
              Two ->
                ( { model | two = {xy=newCoordinat, w=Two}} ,Cmd.none )
              Three->
                ( { model | three = {xy=newCoordinat, w=Three}} ,Cmd.none )