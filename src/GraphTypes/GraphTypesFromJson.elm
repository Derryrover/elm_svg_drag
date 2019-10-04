module ParseJson exposing (jsonNodesAndConnectionsDecode)

import Json.Decode
import GraphTypes
import NativeTypes
import Uuid


jsonNodeDecoder: Json.Decode.Decoder GraphTypes.Node
jsonNodeDecoder = 
  Json.Decode.map3
    GraphTypes.Node
    (Json.Decode.field "uuid" (Uuid.decoder))
    (Json.Decode.field "content" nativeDecoder)--(JsonTypes.stringToNative Json.Decode.string))
    (Json.Decode.field "value" Json.Decode.string)

nativeDecoder :Json.Decode.Decoder NativeTypes.Native
nativeDecoder =
  Json.Decode.string |> Json.Decode.andThen (\str -> Json.Decode.succeed (NativeTypes.stringToNative str))

jsonConnectionDecoder: Json.Decode.Decoder GraphTypes.Connection
jsonConnectionDecoder = 
  Json.Decode.map3
    GraphTypes.Connection
    (Json.Decode.field "from" (Uuid.decoder))
    (Json.Decode.field "to" (Uuid.decoder))
    (Json.Decode.field "name" Json.Decode.string)

jsonNodesAndConnectionsDecode: Json.Decode.Decoder GraphTypes.NodesAndConnections
jsonNodesAndConnectionsDecode = 
  Json.Decode.map2
    GraphTypes.NodesAndConnections
    (Json.Decode.field "nodes" (Json.Decode.list jsonNodeDecoder))
    (Json.Decode.field "connections" (Json.Decode.list jsonConnectionDecoder))