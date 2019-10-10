module IdRoseTreeDisplayCssBox exposing (..)

-- self made
import SelfMadeMath exposing(isEven)
import ElmStyle

-- core
import Html exposing (..)
import Html.Attributes exposing (..)

oddEvenClass : Int -> String
oddEvenClass int = 
  if isEven int then
    "class_even"
  else 
    "class_odd"

hrLineStyleList int = ElmStyle.createStyleList [("display", "none")]

listItemDivStyleList = ElmStyle.createStyleList
  [ ("padding", "3px")
  ]

listItemStyleList = ElmStyle.createStyleList 
  [ ("list-style-type", "none") -- no bullets
  --, ("padding", "3px")
  ]

listItemRoot = ElmStyle.createStyleList 
  [ ("margin", "0px")
  , ("height", "100vh")
  , ("box-sizing", "border-box")
  ]

listItemNotRoot = ElmStyle.createStyleList 
  [ ("border-style", "solid")
  , ("border-width", "3px")
  , ("border-color", "white")
  , ("margin", "3px")
  , ("margin-bottom", "0px")
  , ("margin-right", "0px")
  ]

listItemStyleListEvenOdd int = 
  let 
    color = 
      if (isEven int) then 
        --"blue"
        "#bad4da"
      else
        --"green"
        "#bad4ba"
  in 
    ElmStyle.createStyleList
      [ ("background-color", color)
      ]

listStyleList = ElmStyle.createStyleList 
  [ ("margin-top", "0px") -- space above first bullet
  , ("margin-bottom", "0px") -- space below lst bullet
  , ("padding-left", "41px") -- indentation of each layer of new list
  ]