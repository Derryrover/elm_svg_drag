module GraphModel exposing(..)

import GraphTypes exposing (NodesAndConnections)
import GraphTypesToJson
import GraphInitialValues
import Json.Encode

type alias Model = 
  { 
    data: NodesAndConnections
  , jsonString: String
  }


type Msg = ToJson | FromJson | UpdateData NodesAndConnections

init: Model
init = 
  { 
    data = GraphInitialValues.nodesAndConnections
  , jsonString = Json.Encode.encode 2 (GraphTypesToJson.nodesAndConnectionsToJson GraphInitialValues.nodesAndConnections)
  }