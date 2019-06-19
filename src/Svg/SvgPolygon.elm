module SvgPolygon exposing (..)

import Html exposing (Html, div, text, input)
import Html.Attributes exposing (style, class,value)
import Svg exposing (circle, line, svg, g, polygon, text_, text)
import Svg.Attributes exposing (viewBox, width, height, fill, points, r, cx, cy, x, y, fillOpacity)
import Svg.Events exposing(onClick, onMouseDown, onMouseUp, on)

import Coordinate exposing(XY, toSvgString, listToString)
import UuidTag
import SvgDragModel exposing(WhichCorner(..))

import MsgToCmd
import Maybe
import Uuid
import Json.Decode as Json

import SvgTypes exposing (Viewbox, SquareSize)

import Browser.Dom
import Task


import List
import SvgTypes exposing (Viewbox, viewBoxToString)


viewboxConfig: Viewbox
viewboxConfig =
  { xLeft = -100
  , yTop = -100
  , width = 200
  , height = 200
  }



-- type Msg = NoOp

-- unfocusSearchBox : Cmd Msg
-- unfocusSearchBox =
--   Task.attempt (\_ -> NoOp) (Dom.blur "search-box")

type alias UuidCoordinat = UuidTag.UuidTagged Coordinate.XY

type alias TaggedTriangle = { xy: XY, w: WhichCorner }

type alias Model = 
  { one: TaggedTriangle
  , two: TaggedTriangle
  , three: TaggedTriangle
  , uuid: Maybe Uuid.Uuid
  , drag: SvgDragModel.Model
  , svgDom: Maybe Browser.Dom.Element
  }

type Msg = 
    None
  | Uuid (Maybe Uuid.Uuid)
  | MouseDownSelectionBall WhichCorner Coordinate.XY Coordinate.XY
  | MouseMove Viewbox SquareSize Coordinate.XY
  | MouseUp
  | GetSvg (Result Browser.Dom.Error Browser.Dom.Element)

type NoOp = NoOp

init: (Model, Cmd Msg)
init =
    (
      {
        one = { xy = { x = -50, y = -50.0 }, w = One }
      , two = { xy = { x = 50.0, y = -50.0 }, w = Two }
      , three = { xy = { x = 0.0, y = 50.0 }, w = Three }
      , uuid = Nothing
      , drag = Nothing
      , svgDom = Nothing
      }
      , Cmd.batch [MsgToCmd.send (Uuid Nothing)]
    )

getSvgAttributes: Model -> List (Svg.Attribute Msg)
getSvgAttributes model = 
  let
    staticAttributes = 
      [ viewBox (viewBoxToString viewboxConfig)
      , width "300px" 
      , onMouseUp MouseUp
      , onMouseMoveWithCoordinates viewboxConfig
      ]
    id = 
      case model.uuid of
        Nothing -> []
        Just uuid -> [Svg.Attributes.id (Uuid.toString uuid)]
  in
    List.concat [staticAttributes, id]
  

view: Model -> Html Msg
view model = 
  svg 
    (getSvgAttributes model)
    -- [ 
    --   -- viewBox "-100 -100 200 200"
    -- -- , 
    --   viewBox (viewBoxToString viewboxConfig)
    -- , width "300px" 
    -- ]
    [
      g 
        [ 
        ] 
        -- [
        ( List.concat
          [ 
            [ Svg.rect 
              [ fillOpacity "0"
              , x "-100"
              , y "-100"
              , width "200"
              , height "200" 
              ] []
            ]
          , [ polygon [
              fill "purple", onMouseUp MouseUp, onClick (Uuid Nothing), points (listToString [model.one.xy, model.two.xy, model.three.xy])] [] 
            ]
          -- , [ circle [fill "blue", r "10", cx (String.fromFloat model.one.x), cy (String.fromFloat model.one.y)] [] ]
          , listToSelectionBalls [model.one, model.two, model.three]
          , [ 
              circle 
                [ r "1"
                , cx "-100"
                , cy "-100"
                ] []
            , circle 
                [ r "1"
                , cx "100"
                , cy "100"
                ] []
            ]
          
          , case model.uuid of
            Nothing -> [text_  [x "0", y "15", fill "red"] [text "Uuid placeholder!"]]
            Just uuid -> [text_  [x "0", y "15", fill "red"] [text (Uuid.toString uuid)]]
          -- , case model.drag of
          --   Nothing -> [text_  [x "0", y "15", fill "red"] [text "drag placeholder!"]]
          --   Just drag -> [text_  [x "0", y "15", fill "red"] [text (String.fromFloat drag.dragStart.x)]]
          ]
        )
     ]


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
      -- (Json.at ["target","ownerSVGElement","width","animVal","value"] Json.int) 
      -- (Json.at ["target","ownerSVGElement","height","animVal","value"] Json.int)
    )
onMouseMoveWithCoordinates: Viewbox -> Html.Attribute Msg
onMouseMoveWithCoordinates viewbox =
  on 
    "mousemove" 
    ( Json.map4 
      (\x y width height -> 
        MouseMove 
          viewbox 
          {width= toFloat width, height= toFloat height} 
          {x=toFloat x,y=toFloat y}
      ) 
      (Json.field "clientX" Json.int) 
      (Json.field "clientY" Json.int)
      (Json.at ["target","ownerSVGElement","width","animVal","value"] Json.int) 
      (Json.at ["target","ownerSVGElement","height","animVal","value"] Json.int)
      -- (Json.at ["target","ownerSVGElement","width","baseVal","value"] Json.int) 
      -- (Json.at ["target","ownerSVGElement","height","baseVal","value"] Json.int)
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
      }, --Cmd.none)
        case model.uuid of 
          Nothing -> Cmd.none
          Just uuid -> 
            Task.attempt 
              GetSvg 
              (Browser.Dom.getElement (Uuid.toString uuid))
      )
    GetSvg element ->
      case element of
        Err _ -> (model, Cmd.none)
        Ok value -> ({model | svgDom = Just value}, Cmd.none)
    MouseUp ->
      ( { model | drag = Nothing } ,Cmd.none )
    MouseMove viewbox squareSize xy ->
      case model.drag of
        Nothing ->
          (model,Cmd.none )
        Just dragModel ->
          case model.svgDom of
            Nothing -> 
              (model,Cmd.none )
            Just element ->
              let
                deltaX = (dragModel.dragStart.x - xy.x) * (viewbox.width / element.element.width)
                deltaY = (dragModel.dragStart.y - xy.y) * (viewbox.height / (Debug.log "squareSize.height" element.element.height))
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