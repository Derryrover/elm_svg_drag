module MsgRouter exposing (..)

import SvgPolygon exposing (Msg(..))
import UuidGenerator exposing(Msg(..))

import Html
import Maybe

type alias Model = 
  { svgPolygonModel : SvgPolygon.Model 
  , uuidGeneratorModel : UuidGenerator.Model
  }

type alias MaybeModel = 
  { uuidGeneratorModel : Maybe UuidGenerator.Model}

type Msg 
  = SvgPolygonMsg SvgPolygon.Msg
  | UuidGeneratorMsg UuidGenerator.Msg

reconstructMainMsg: Msg -> Model -> (MaybeModel, Msg)
reconstructMainMsg msg model = 
  case msg of 
    SvgPolygonMsg svgPolygonMsg ->
      case svgPolygonMsg of
        None ->
          ({uuidGeneratorModel = Nothing},msg)
        Uuid maybeUuid ->
          case maybeUuid of
            Just _ ->
               ({uuidGeneratorModel = Nothing},msg)
            Nothing ->
              let 
                (newUuidModel, newUuidCmd) = UuidGenerator.update NewUuid model.uuidGeneratorModel
                newUuid = newUuidModel.currentUuid
              in 
                --Html.map SvgPolygonMsg (Uuid newUuid)
                ({uuidGeneratorModel = Just newUuidModel}, SvgPolygonMsg (Uuid newUuid))
    UuidGeneratorMsg uuidGeneratorMsg ->
       ({uuidGeneratorModel = Nothing},msg)



