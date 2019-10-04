module GraphInitialValues exposing (..)

import GraphTypes exposing(NodesList, ConnectionsList, NodesAndConnections)
import Uuid
import List
import Json.Encode
import NativeTypes exposing( Native(..), nativeToString )

nodesAndConnections: NodesAndConnections
nodesAndConnections = 
  {
    nodes = initialNodes
  , connections = initialConnectionsList 
  }

initialNodes: NodesList
initialNodes = 
  let
    uuidFromString = Uuid.fromString "74b662d2-a0dc-4e64-9c3e-df54c4c052e6"
    uuidFromString2 = Uuid.fromString "74b662d2-a0dc-4e64-9c3e-df54c4c052e7"  
  in
    case uuidFromString of 
      Nothing -> 
        []
      Just uuid ->
        case uuidFromString2 of
          Nothing -> 
            []
          Just uuid2 ->
            [
              {
                uuid = uuid
              , content = Svg
              , value = ""
              },
              {
                uuid = uuid2
              , content = Polygon
              , value = ""
              }
            ]

initialConnectionsList: ConnectionsList
initialConnectionsList = 
  let
    uuidFromString = Uuid.fromString "74b662d2-a0dc-4e64-9c3e-df54c4c052e6"
    uuidFromString2 = Uuid.fromString "74b662d2-a0dc-4e64-9c3e-df54c4c052e7"  
  in
    case uuidFromString of 
      Nothing -> 
        []
      Just uuid ->
        case uuidFromString2 of
          Nothing -> 
            []
          Just uuid2 ->
            [
              {
                from = uuid
              , to = uuid2
              , name = ""
              }
            ]