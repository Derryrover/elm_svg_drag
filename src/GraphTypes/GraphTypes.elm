module GraphTypes exposing(..)

import Uuid
import List
import Json.Encode
import NativeTypes exposing( Native(..), nativeToString )

type alias Node = 
  {
    uuid: Uuid.Uuid
    -- for now content is a native
    -- lateron it might be possible that content is a function composed from natives (thus itself not a true native)
    -- for this svg editor this might not be applicable
  , content: Native
  , value: String
  }

type alias NodesList = List Node

type alias Connection = 
  {
    from: Uuid.Uuid
  , to: Uuid.Uuid
  , name: String
  }



type alias ConnectionsList = List Connection


type alias NodesAndConnections = 
  {
    nodes : NodesList
  , connections : ConnectionsList
  }

