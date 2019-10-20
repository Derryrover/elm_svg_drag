module TreeItemFromNodeModel exposing (..)

import GraphToRosetree
import GraphInitialValues
import List
-- import Maybe
import Uuid
import NativeTypes exposing (Native(..)) 

import Html exposing (Html, div, button, label, text, input, textarea, span, select, option)
import Html.Attributes exposing (style, class, value, selected)
import Html.Events exposing (onInput, onClick)

type alias Model = GraphToRosetree.TreeItemFromNode

type Msg = 
    UpdateName String 
  | UpdateContent String

view: Model -> Html Msg
view item = 
      div 
        [] 
        [
          div 
            [] 
            [
              label [] [text "uuid"]
            , span [] [ text (Uuid.toString item.uuid)]
            ]
        , div 
            [] 
            [
              label [] [text "name"]
            , input 
              [ 
                value item.name
              , onInput UpdateName
              ] 
              []
              , text item.name
            ]
        , div 
            [] 
            [
              label [] [text "content"]
            -- , input 
            --   [
            --     value (NativeTypes.nativeToString item.content)
            --   , onInput UpdateContent
            --   ] 
            --   []
            , select 
              [
                onInput UpdateContent
              ]
              (List.map 
                -- (\native -> (option [] [text (NativeTypes.nativeToString native)])) 
                (optionFromNative item.content)
                NativeTypes.natives  
              )
            , text (NativeTypes.nativeToString item.content)     
            ]
        ]

optionFromNative: NativeTypes.Native -> NativeTypes.Native -> Html Msg
optionFromNative selected native = 
  let
    str = NativeTypes.nativeToString native
  in
    option 
      [
        value str
      , Html.Attributes.selected (selected == native)  
      ] 
      [
        text str
      ]

update: Msg -> Model -> ( Model, Cmd Msg )
update msg treeItem =
  case msg of 
    UpdateContent contentStr ->
      ( {treeItem | content = NativeTypes.stringToNative contentStr} , Cmd.none)
      -- (Just treeItem , Cmd.none)
    UpdateName name ->
      ( { treeItem | name = name } , Cmd.none)

