module Coordinate exposing (..)

import List

type alias XY = 
  { x: Float
  , y: Float 
  }

toSvgString: XY -> String
toSvgString xy = 
  (String.fromFloat xy.x) 
  ++ 
  "," 
  ++ 
  (String.fromFloat xy.y)

listToString: List XY -> String
listToString list = 
  case list of
    (x :: xs) -> 
      (toSvgString x) ++ " " ++ (listToString xs)
    [] ->
      ""