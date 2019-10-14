module RoseTreeDisplay exposing(..)

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
import GraphToRosetree
import TreeItemFromNodeModel
import Uuid

type alias Model = GraphToRosetree.TreeFromNodes


type Msg 
  = ItemMsg Uuid.Uuid TreeItemFromNodeModel.Msg 
  | Direction Uuid.Uuid Msg

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

maybeViewHelper: Maybe Model -> Html Msg
maybeViewHelper maybeModel =
  case maybeModel of 
    Nothing ->
      div [] [text "no model"]
    Just tree ->
      view tree

view: Model -> Html Msg
view model = recursiveView 0 model

recursiveView : Int -> Model -> Html Msg
recursiveView  depth treeModel = 
  let
    treeLabel = Tree.label treeModel
    children = Tree.children treeModel
    uuid = treeLabel.uuid   
  in
    li 
      [ class (getListItemClassNames depth)]
        [ div 
            [class itemContainerClassNames]
              [ Html.map 
                (ItemMsg uuid)
                (TreeItemFromNodeModel.view (treeLabel))
              ] 
        , ol 
          [class (getOrderedListClassNames depth)] 
            (List.map (\child -> Html.map (Direction uuid) (recursiveView (depth+1) child )) children) 
        ]

update: Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  let 
    treeLabel = Tree.label model
    children = Tree.children model
    uuid = treeLabel.uuid
  in
    case msg of 
      ItemMsg uuidMsg treeItemMsg ->
        if uuidMsg == uuid then
          let 
            (newTreeItem, cmd) = TreeItemFromNodeModel.update treeItemMsg treeLabel
          in
            (Tree.tree newTreeItem children, Cmd.map (ItemMsg uuid)  cmd)
        else 
          (model, Cmd.none)
      Direction uuidMsg newMsg ->
        if uuidMsg == uuid then
          let 
            listChildrenAndCmd = List.map (update newMsg) children 
            newChildren = List.map (\(child, cmd) -> child) listChildrenAndCmd
            newCmd = List.map (\(child, cmd) -> cmd) listChildrenAndCmd
          in
            (Tree.tree treeLabel newChildren, Cmd.batch newCmd)
        else 
          (model, Cmd.none)


  --(model, Cmd.none)


  
