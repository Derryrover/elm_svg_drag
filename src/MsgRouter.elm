module MsgRouter exposing (..)

import SvgPolygon exposing (Msg(..))
import UuidGenerator exposing(Msg(..))

import Html
import Maybe
import GraphModel
import MaybeTreeItemFromNodeModel
import RoseTreeDisplay

type alias Model = 
  { svgPolygonModel1 : SvgPolygon.Model
  , svgPolygonModel2 : SvgPolygon.Model 
  , uuidGeneratorModel : UuidGenerator.Model
  , graphModel: GraphModel.Model
  , treeItemTest: MaybeTreeItemFromNodeModel.Model
  }

type alias MaybeModel = 
  { uuidGeneratorModel : Maybe UuidGenerator.Model}

type Msg 
  = SvgPolygonMsg Int SvgPolygon.Msg
  | UuidGeneratorMsg UuidGenerator.Msg
  | GraphModelMsg GraphModel.Msg
  | TreeItemTestMsg MaybeTreeItemFromNodeModel.Msg
  | Tree RoseTreeDisplay.Msg

reconstructMainMsg: Msg -> Model -> (MaybeModel, Msg)
reconstructMainMsg msg model = 
  case msg of 
    SvgPolygonMsg id svgPolygonMsg ->
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
                ({uuidGeneratorModel = Just newUuidModel}, SvgPolygonMsg id (Uuid newUuid))
        _ ->
          ({uuidGeneratorModel = Nothing},msg)
    _ ->
       ({uuidGeneratorModel = Nothing},msg)


