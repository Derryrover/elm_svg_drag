module GraphTypesToJson exposing(..)

import GraphTypes exposing(Node, Connection, NodesList, ConnectionsList, NodesAndConnections)
import Uuid
import List
import Json.Encode
import NativeTypes exposing( Native(..), nativeToString )

nodeToJson: Node -> Json.Encode.Value
nodeToJson node =
  Json.Encode.object
    [
      ("uuid" , ( Json.Encode.string (Uuid.toString node.uuid) ))
    , ("content" , ( Json.Encode.string (nativeToString node.content) ))
    , ("value" , ( Json.Encode.string node.value ))
    ]

nodeListToJson: List Node -> Json.Encode.Value
nodeListToJson list = 
  Json.Encode.list nodeToJson list

connectionToJson: Connection -> Json.Encode.Value
connectionToJson connection =
  Json.Encode.object
    [
      ("from" , ( Json.Encode.string (Uuid.toString connection.from) ))
    , ("to" , ( Json.Encode.string (Uuid.toString connection.to) ))
    , ("name" , ( Json.Encode.string connection.name ))
    ]

connectionListToJson: List Connection -> Json.Encode.Value
connectionListToJson list = 
  Json.Encode.list connectionToJson list

nodesAndConnectionsToJson nodesPlusConn = 
   Json.Encode.object
    [
      ("connections" , ( connectionListToJson (nodesPlusConn.connections) ))
    , ("nodes" , ( nodeListToJson (nodesPlusConn.nodes) ))
    ]