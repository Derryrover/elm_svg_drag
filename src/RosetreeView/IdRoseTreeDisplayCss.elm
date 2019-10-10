module IdRoseTreeDisplayCss exposing (..)

-- self made
import SelfMadeMath exposing(isEven)
import ElmStyle 
import IdRoseTreeDisplayCssConstants exposing (listIndent)

-- core
import Html exposing (..)
import Html.Attributes exposing (..)

oddEvenClass : Int -> String
oddEvenClass int = 
  if isEven int then
    "class_even"
  else 
    "class_odd"

hrLineStyleList int = 
  if int == 1 then
    ElmStyle.createStyleList  
      [("display", "none")]
  else
    ElmStyle.createStyleList 
    [ ("display", "block")
    , ("height", "0px")
    , ("border", "0")
    --, ("border-top", "1px solid #ccc")
    --, ("border-top", "1px solid #000")
    , ("border-top", "1px solid grey")
    --, ("margin", "1em 0")
    ,  ("margin", "0px")
    , ("padding", "0")
    ]


listItemDivStyleList = ElmStyle.createStyleList
  [ 
    --("padding", "3px")
    ("padding-top", "3px")
  , ("padding-bottom", "3px")  
  ]

listItemStyleList = ElmStyle.createStyleList 
  [ ("list-style-type", "none") -- no bullets
  --, ("padding", "3px")
  --, ("margin", "0px")
  -- , ("margin", "3px")
  -- , ("margin-bottom", "0px")
  -- , ("border-style", "solid")
  -- , ("border-width", "3px")
  -- , ("border-color", "white")
  --, ("-webkit-margin-before", "0px") -- space above first bullet ? not working ?
  --, ("-webkit-margin-after", "0px") -- space below lst bullet ? not working ?
  ]

listItemRoot = ElmStyle.createStyleList 
  [ ("margin", "0px")
  , ("height", "100vh")
  , ("box-sizing", "border-box")
  , ("padding-right", "3px")
  ]

listItemNotRoot = ElmStyle.createStyleList 
  [ ("border-width", "0px")
  --, ("border-width", "1px 0px 0px 0px")
  --, ("border-width", "3px")
  --, ("border-top-width", "3px")
  --, ("border-color", "black")
  --, ("border-color", "grey")
  --, ("border-color", "white")
  , ("margin", "0px")
  , ("margin-bottom", "0px")
  , ("margin-right", "0px")
  ]

listItemStyleListEvenOdd int = 
  let 
    color = 
      if (isEven int) then 
        --"blue"
        --"#bad4da"
        --"green"
        "#bad4ba"
      else
        --"green"
        "#bad4ba"
  in 
    ElmStyle.createStyleList
      [ ("background-color", color)
      ]

listStyleList = ElmStyle.createStyleList 
  [ 
    --("margin-top", "0px") -- space above first bullet
    ("margin-top", "3px") -- space above first bullet
  , ("margin-bottom", "0px") -- space below lst bullet
  , ("padding-left", ElmStyle.intToPxString listIndent) -- indentation of each layer of new list
  ]