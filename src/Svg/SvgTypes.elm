module SvgTypes exposing(..)

type alias Viewbox =
  { xLeft: Float
  , yTop: Float
  , width: Float
  , height: Float
  }

type alias SquareSize = 
  { width: Float
  , height: Float 
  }

viewBoxToString: Viewbox -> String
viewBoxToString v = 
  String.fromFloat v.xLeft ++ " " ++ 
  String.fromFloat v.yTop ++ " " ++
  String.fromFloat v.width ++ " " ++
  String.fromFloat v.height