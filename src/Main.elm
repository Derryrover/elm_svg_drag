module Main exposing (..)

-- core
import Html exposing (Html, div, text, input)
import Html.Attributes exposing (style, class,value)
import Html.Events exposing (onInput)
import Browser exposing(element)

-- self made modules
-- import ElmStyle
-- import SelfMadeMath
-- import Time
-- import Clock
import UuidGenerator

import SvgTag
import SvgPolygon



type alias Model = 
  { svgPolygonModel : SvgPolygon.Model 
  , uuidGeneratorModel : UuidGenerator.Model
  }

type Msg 
  = SvgPolygonMsg SvgPolygon.Msg
  | UuidGeneratorMsg UuidGenerator.Msg

main = Browser.element
  { init = init
  , view = view
  , update = update
  , subscriptions = subscriptions
  }

init : Int -> (Model, Cmd Msg)
init seedUuid =
  let 
    (svgPolygonModel, svgPolygonCommand) = SvgPolygon.init
    (uuidGeneratorModel, uuidGeneratorCommand) = UuidGenerator.init seedUuid
  in
    (
        { svgPolygonModel = svgPolygonModel 
        , uuidGeneratorModel = uuidGeneratorModel
        }
      , Cmd.batch [Cmd.map SvgPolygonMsg svgPolygonCommand, Cmd.map UuidGeneratorMsg uuidGeneratorCommand]
    )

view : Model -> Html Msg
view model = 
  div 
    []
    [ 
      SvgTag.tag [ SvgPolygon.view model.svgPolygonModel ]
    ]

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model = 
  case msg of
    SvgPolygonMsg svgPolygonMsg ->
      let (svgPolygonModel, svgPolygonCommand) = SvgPolygon.update svgPolygonMsg model.svgPolygonModel
      in 
        ( { model | svgPolygonModel = svgPolygonModel }, Cmd.map SvgPolygonMsg svgPolygonCommand)
    UuidGeneratorMsg uuidGeneratorMsg ->
      let (uuidGeneratorModel, uuidGeneratorCommand) = UuidGenerator.update uuidGeneratorMsg model.uuidGeneratorModel
      in ( { model | uuidGeneratorModel = uuidGeneratorModel }, Cmd.map UuidGeneratorMsg uuidGeneratorCommand)


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none