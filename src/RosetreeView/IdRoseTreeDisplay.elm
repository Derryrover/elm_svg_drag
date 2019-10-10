module IdRoseTreeDisplay exposing (view, Msg(..))

-- self made modules
--import IdRoseTreeDisplayCssBox exposing
import IdRoseTreeDisplayCss exposing 
  ( oddEvenClass
  , hrLineStyleList
  , listItemStyleList
  , listItemDivStyleList
  , listItemRoot
  , listItemNotRoot
  , listItemStyleListEvenOdd
  , listStyleList 
  )
import IdWrapper
import IdRoseTree
import ElmStyle
-- packages
import Tree
-- core
import Basics exposing (..)
import List exposing(map)
import Maybe exposing(..)
import Html exposing (Html, ol, li, div, span, hr, text, node, button, select, option)
import Html.Attributes exposing (..)
import Html.Events exposing(onInput)

type Msg aMsg aModel 
  = Direction IdWrapper.Id aMsg 
  | New IdWrapper.Id --id parent
  | CreatedRandom IdWrapper.Id IdWrapper.Id -- id-parent new-id

-- The view function of my rosetree is simple but awefully concoluted
-- this is mostly and html crap branching
-- The former could be made simplet with scss and factoring out more stylelogic
-- The latter probably by removing the html branching and adding css.
-- 2019-01-01 adding scss

getOrderedListClassNames depth = 
  "depth_rosetree_" ++ (String.fromInt depth) 
  ++ " ol_rosetree " ++ ElmStyle.elmClass

getListItemClassNames depth =
  "depth_rosetree_" ++ (String.fromInt depth)
   ++ " li_rosetree "  ++ ElmStyle.elmClass

itemContainerClassNames = "itemcontainer_rosetree " ++ ElmStyle.elmClass

view : ( aModel -> Html aMsg) -> Int -> IdRoseTree.Model aModel -> Html (Msg aMsg aModel)
view itemViewFunction depth treeModel = 
  let
    treeLabel = Tree.label treeModel
    rootId = IdWrapper.getId treeLabel
    rootItem = IdWrapper.getItem treeLabel
    children = Tree.children treeModel
  in
    li 
      [ class (getListItemClassNames depth)]
        [ div 
            [class itemContainerClassNames]
              [ Html.map 
                (Direction rootId) 
                (itemViewFunction rootItem)
              ] 
        , ol 
          [class (getOrderedListClassNames depth)] 
            (List.map (view itemViewFunction (depth+1)) children) 
        ]
      


-- view : ( aModel -> Html aMsg) -> Int -> IdRoseTree.Model aModel -> Html (Msg aMsg aModel)
-- view itemViewFunction depthCounter treeModel = 
--   let
--     rootWithId = Tree.label treeModel
--     rootId = IdWrapper.getId rootWithId
--     rootItem = IdWrapper.getItem rootWithId
--     children = Tree.children treeModel
--     listItemAttributesGeneral = List.concat 
--       [ listItemStyleList
--       , listItemStyleListEvenOdd depthCounter 
--       , [class (oddEvenClass depthCounter)]
--       ]
--     listItemAttributes = 
--       if depthCounter == 1 then
--         List.concat 
--           [ listItemAttributesGeneral
--           --, listItemStyleList
--           , listItemRoot
--           --, listItemStyleListEvenOdd depthCounter
--           --,  [class (oddEvenClass depthCounter)]
--           ]
--       else
--         List.concat 
--           [ listItemAttributesGeneral
--           --, listItemStyleList
--           , listItemNotRoot
--           --, listItemStyleListEvenOdd depthCounter
--           --,  [class (oddEvenClass depthCounter)]
--           ]
--     listView = 
--       if children == [] then
--         span [] []
--       else 
--         ul listStyleList (List.map (view itemViewFunction (depthCounter+1)) children)
--   in
--     li 
--       listItemAttributes
--       --(List.concat [listItemStyleList, listItemStyleListEvenOdd depthCounter,  [class (oddEvenClass depthCounter)]])
--       [ hr (hrLineStyleList depthCounter) [] 
--       , div 
--           ( List.concat
--             [ listItemDivStyleList 
--             , [ class "svg_circle_input_whole_item" ] 
--             ]
--           )
--           [ Html.map (Direction rootId) (itemViewFunction rootItem) 
--           , listView ]
--       --, selectBuilder rootId 
--       --, ul listStyleList (List.map (view itemViewFunction (depthCounter+1)) children)
--       --, listView
--       ]

-- selectItems = [ "circle", "rect", "ellipse", "line", "polyline", "polygon", "path"]

-- selectBuilder rootId = 
--   select 
--     [ class "svg_input_general div_new_tree_child_select"
--     , onInput (\n->(New rootId))
--     , id (String.fromInt rootId)
--     ] 
--     (List.concat 
--       [
--         [ option [(value "select new item"), selected True, disabled True, hidden True] [text "select new item"]]
--         , List.map (\item-> option [(value item)] [text item]) selectItems 
--       ])
