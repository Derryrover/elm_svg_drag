module UuidTag exposing(..)

import Uuid

type alias UuidTagged a = 
  { tag: Uuid.Uuid
  , content: a
  }

getUuid: UuidTagged a -> Uuid.Uuid
getUuid uuidTagged = 
  uuidTagged.tag

getContent: UuidTagged a -> a
getContent uuidTagged = 
  uuidTagged.content