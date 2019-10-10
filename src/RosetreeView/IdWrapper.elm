module IdWrapper exposing (IdWrapper(..), Id, map, getId, getItem)

type IdWrapper a = Wrapper Id a

type alias Id = Int

map: (a -> b) -> IdWrapper a -> IdWrapper b
map f (Wrapper id item) = Wrapper id (f item)

getId : IdWrapper a -> Id
getId (Wrapper id a) = id

getItem : IdWrapper a -> a
getItem (Wrapper id a) = a

