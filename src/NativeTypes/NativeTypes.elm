module NativeTypes exposing(..)

import Svg 
import Svg.Attributes 
import Svg.Events 
import Html

-- natives  should have all a procedure for the compiler to stringify them
-- for these svg elements this will be by using functions in the standard elm Svg library
-- this means also for now the amount of Natives is hardcoded
-- In the future the user should be able add natives and create the stringify method for them, but for a svg editor this is probably not needed
type Native = 
  Circle | Line | Svg | G | Polygon | Text_ | Text | Animate |
  ViewBox | Width | Height | Fill | Points | R | Cx | Cy | X | Y | FillOpacity |
  Begin |
  AttributeName | Dur | To | RepeatCount | Values

natives = [Circle , Line , Svg , G , Polygon , Text_ , Text , Animate ,
  ViewBox , Width , Height , Fill , Points , R , Cx , Cy , X , Y , FillOpacity ,
  Begin ,
  AttributeName , Dur , To , RepeatCount , Values]

nativeToString: Native -> String
nativeToString native = 
  case native of
    Circle -> "circle"
    Line -> "line"
    Svg -> "svg"
    G -> "g"
    Polygon -> "polygon"
    Text_ -> "text_"
    Text -> "text"
    Animate -> "animate"
    ViewBox -> "viewBox"
    Width -> "width"
    Height -> "height"
    Fill -> "fill"
    Points -> "points"
    R -> "r"
    Cx -> "cx"
    Cy -> "cy"
    X -> "x"
    Y -> "y"
    FillOpacity -> "fillOpacity"
    Begin -> "begin"
    AttributeName -> "attributeName"
    Dur -> "dur"
    To -> "to"
    RepeatCount -> "repeatCount"
    Values -> "values"

stringToNative: String -> Native
stringToNative str =
  case str of
    "circle" -> Circle 
    "line" ->  Line 
    "svg" ->  Svg
    "g" ->  G 
    "polygon" ->  Polygon 
    "text_" ->  Text_ 
    "text"  -> Text 
    "animate"  -> Animate  
    "viewBox"  -> ViewBox 
    "width"  -> Width 
    "height"  -> Height 
    "fill"  -> Fill
    "points" ->  Points  
    "r" ->  R 
    "cx"  -> Cx 
    "cy" ->  Cy 
    "x"  -> X 
    "y" ->  Y 
    "fillOpacity" ->  FillOpacity
    "begin"  -> Begin
    "attributeName" ->  AttributeName 
    "dur"  -> Dur 
    "to" -> To 
    "repeatCount" ->  RepeatCount 
    "values"  -> Values  
    _  -> Circle 


type SvgElm msg = 
    SvgElement ( List (Svg.Attribute msg) -> List (Svg.Svg msg) -> Html.Html msg )  
  | SvgAttribute (String -> Svg.Attribute msg)
  | SvgEndNode (String -> Svg.Svg msg)

nativeToSvg: Native -> SvgElm msg--( List (Svg.Attribute msg) -> List (Svg.Svg msg) -> Html.Html msg )
nativeToSvg native = 
  case native of
    Circle -> SvgElement Svg.circle
    Line -> SvgElement Svg.line
    Svg -> SvgElement Svg.svg
    G -> SvgElement Svg.g
    Polygon -> SvgElement Svg.polygon
    Text_ -> SvgElement Svg.text_
    Text -> SvgEndNode Svg.text
    Animate -> SvgElement Svg.animate
    ViewBox -> SvgAttribute Svg.Attributes.viewBox
    Width -> SvgAttribute Svg.Attributes.width
    Height -> SvgAttribute Svg.Attributes.height
    Fill -> SvgAttribute Svg.Attributes.fill
    Points -> SvgAttribute Svg.Attributes.points
    R -> SvgAttribute Svg.Attributes.r
    Cx -> SvgAttribute Svg.Attributes.cx
    Cy -> SvgAttribute Svg.Attributes.cy
    X -> SvgAttribute Svg.Attributes.x
    Y -> SvgAttribute Svg.Attributes.y
    FillOpacity -> SvgAttribute Svg.Attributes.fillOpacity
    Begin -> SvgAttribute Svg.Attributes.begin
    AttributeName -> SvgAttribute Svg.Attributes.attributeName
    Dur -> SvgAttribute Svg.Attributes.dur
    To -> SvgAttribute Svg.Attributes.to
    RepeatCount -> SvgAttribute Svg.Attributes.repeatCount
    Values -> SvgAttribute Svg.Attributes.values