module GraphModel exposing(..)

import GraphTypes exposing (NodesAndConnections)
import GraphTypesToJson
import GraphInitialValues
import GraphTypesFromJson exposing(jsonNodesAndConnectionsDecode)
import Json.Encode
import Json.Decode

import Html exposing (Html, div, button, text, input, textarea)
import Html.Attributes exposing (style, class,value)
import Html.Events exposing (onInput, onClick)

type alias Model = 
  { 
    data: NodesAndConnections
  , jsonString: String
  }


type Msg = ToJson | FromJson | UpdateJson String | UpdateData NodesAndConnections

init: Model
init = 
  { 
    data = GraphInitialValues.nodesAndConnections
  , jsonString = Json.Encode.encode 2 (GraphTypesToJson.nodesAndConnectionsToJson GraphInitialValues.nodesAndConnections)
  }

view: Model -> Html Msg
view model = 
  div 
    [] 
    [
      button [ onClick ToJson ] [ text "data to json"]
    , button [ onClick FromJson ] [ text "json to data"]
    , textarea [value model.jsonString, onInput UpdateJson] [] 
    ]

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    ToJson ->
      (
        { model | 
             jsonString = Json.Encode.encode 2 (GraphTypesToJson.nodesAndConnectionsToJson model.data) 
        }
      , Cmd.none 
      )
    FromJson ->
      let 
        maybeNodesAndConnections = Json.Decode.decodeString jsonNodesAndConnectionsDecode model.jsonString
        newNodeAndConnections =
          case maybeNodesAndConnections of
            Ok nodesAndConnections ->
              nodesAndConnections
            Err _ ->
              model.data
      in 
      (
        {
          model
            | data = newNodeAndConnections
        }
      , Cmd.none
      )
    UpdateJson newJsonString ->
      (
        { model | 
             jsonString = newJsonString
        }
      , Cmd.none 
      )
    UpdateData nodesAndConnections ->
      (
        { model | 
             data = nodesAndConnections
        }
      , Cmd.none 
      )
