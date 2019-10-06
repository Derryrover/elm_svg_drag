module Main exposing (..)

-- core
import Html exposing (Html, div, text, input)
import Html.Attributes exposing (style, class,value)
import Html.Events exposing (onInput)
import Browser exposing(element)

-- self made modules
-- import ElmStyleimport Html.Attributes exposing (style, class,value)

-- import SelfMadeMath
-- import Time
-- import Clock
import UuidGenerator

import SvgTag
import SvgPolygon
import SvgAnimationView
import SvgTypes exposing (Viewbox)

import MsgRouter exposing(Msg(..), Model)

import ViewJson
-- import JsonTypes
-- import ParseJson
import GraphInitialValues
import GraphTypesToJson
import Json.Encode
import GraphModel
import GraphToRosetree


main = Browser.element
  { init = init
  , view = view
  , update = update
  , subscriptions = subscriptions
  }

init : Int -> (Model, Cmd Msg)
init seedUuid =
  let 
    (svgPolygonModel1, svgPolygonCommand1) = SvgPolygon.init
    (svgPolygonModel2, svgPolygonCommand2) = SvgPolygon.init
    (uuidGeneratorModel, uuidGeneratorCommand) = UuidGenerator.init seedUuid
  in
    (
        { svgPolygonModel1 = svgPolygonModel1
        , svgPolygonModel2 = svgPolygonModel2  
        , uuidGeneratorModel = uuidGeneratorModel
        , graphModel = GraphModel.init
        }
      , Cmd.batch 
        [ Cmd.map (SvgPolygonMsg 1) svgPolygonCommand1
        , Cmd.map (SvgPolygonMsg 2) svgPolygonCommand2
        , Cmd.map UuidGeneratorMsg uuidGeneratorCommand
        ]
    )

view : Model -> Html Msg
view model = 
  div 
    []
    [ 
      -- SvgTag.tag (\viewBox->[ Html.map SvgPolygonMsg (SvgPolygon.view model.svgPolygonModel viewBox) ])
      Html.map (SvgPolygonMsg 1) (SvgPolygon.view model.svgPolygonModel1)
    , SvgAnimationView.view model.svgPolygonModel1 model.svgPolygonModel2
    , Html.map (SvgPolygonMsg 2) (SvgPolygon.view model.svgPolygonModel2)
    -- , ViewJson.view ( Json.Encode.encode 2  (GraphTypesToJson.nodesAndConnectionsToJson GraphInitialValues.nodesAndConnections))--("1234")
    , Html.map GraphModelMsg (GraphModel.view model.graphModel )    
    ]

update : Msg -> Model -> ( Model, Cmd Msg )
update preMsg model =
  let 
    (maybeModel ,msg) = MsgRouter.reconstructMainMsg preMsg model
    newUuidModel = 
      case maybeModel.uuidGeneratorModel of 
        Nothing ->
          model.uuidGeneratorModel
        Just uuidGeneratorModel ->
          uuidGeneratorModel
  in
    case msg of
      SvgPolygonMsg int svgPolygonMsg ->
        if int == 1 then
          let (svgPolygonModel, svgPolygonCommand) = SvgPolygon.update svgPolygonMsg model.svgPolygonModel1
          in 
            ( { model | svgPolygonModel1 = svgPolygonModel 
                      , uuidGeneratorModel= newUuidModel}, Cmd.map (SvgPolygonMsg 1) svgPolygonCommand)
        else --int == 2
          let (svgPolygonModel, svgPolygonCommand) = SvgPolygon.update svgPolygonMsg model.svgPolygonModel2
          in 
            ( { model | svgPolygonModel2 = svgPolygonModel 
                      , uuidGeneratorModel= newUuidModel}, Cmd.map (SvgPolygonMsg 2) svgPolygonCommand)
      UuidGeneratorMsg uuidGeneratorMsg ->
        let (uuidGeneratorModel, uuidGeneratorCommand) = UuidGenerator.update uuidGeneratorMsg model.uuidGeneratorModel
        in ( { model | uuidGeneratorModel = uuidGeneratorModel }, Cmd.map UuidGeneratorMsg uuidGeneratorCommand)
      GraphModelMsg graphModelMsg -> 
        let (graphModel, graphModelCommand) = GraphModel.update graphModelMsg model.graphModel
        in ( { model | graphModel = graphModel }, Cmd.map GraphModelMsg graphModelCommand)


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none