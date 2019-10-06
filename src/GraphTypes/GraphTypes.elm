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
  , content: GraphContent
  , value: String --not clear what this is actually. Do we need it later ?
  }

-- expose Native type via this module so no explicit import is needed in other modules like GraphToRosetree.elm
-- unfortuanedly this doesnot work when exposing the different values like Svg is needed, bummer
type alias GraphContent = Native

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

