module ParseJson exposing (jsonNodesAndConnectionsDecode)

import Json.Decode
import JsonTypes
import Uuid


jsonNodeDecoder: Json.Decode.Decoder JsonTypes.Node
jsonNodeDecoder = 
  Json.Decode.map3
    JsonTypes.Node
    (Json.Decode.field "uuid" (Uuid.decoder))
    (Json.Decode.field "content" nativeDecoder)--(JsonTypes.stringToNative Json.Decode.string))
    (Json.Decode.field "value" Json.Decode.string)

nativeDecoder :Json.Decode.Decoder JsonTypes.Native
nativeDecoder =
  Json.Decode.string |> Json.Decode.andThen (\str -> Json.Decode.succeed (JsonTypes.stringToNative str))

jsonConnectionDecoder: Json.Decode.Decoder JsonTypes.Connection
jsonConnectionDecoder = 
  Json.Decode.map3
    JsonTypes.Connection
    (Json.Decode.field "from" (Uuid.decoder))
    (Json.Decode.field "to" (Uuid.decoder))
    (Json.Decode.field "name" Json.Decode.string)

jsonNodesAndConnectionsDecode: Json.Decode.Decoder JsonTypes.NodesAndConnections
jsonNodesAndConnectionsDecode = 
  Json.Decode.map2
    JsonTypes.NodesAndConnections
    (Json.Decode.field "nodes" (Json.Decode.list jsonNodeDecoder))
    (Json.Decode.field "connections" (Json.Decode.list jsonConnectionDecoder))