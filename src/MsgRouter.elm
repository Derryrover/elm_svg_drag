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
        Uuid maybeUuid ->
          case maybeUuid of
            Just _ ->
               ({uuidGeneratorModel = Nothing},msg)
            Nothing ->
              let 
                (newUuidModel, newUuidCmd) = UuidGenerator.update NewUuid model.uuidGeneratorModel
                newUuid = newUuidModel.currentUuid
              in 
                ({uuidGeneratorModel = Just newUuidModel}, SvgPolygonMsg (Uuid newUuid))
        _ ->
          ({uuidGeneratorModel = Nothing},msg)
    _ ->
       ({uuidGeneratorModel = Nothing},msg)



