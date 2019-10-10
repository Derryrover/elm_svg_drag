module TreeItemFromNodeModel exposing (..)

import GraphToRosetree
import GraphInitialValues
import List
-- import Maybe
import Uuid
import NativeTypes exposing (Native(..)) 

import Html exposing (Html, div, button, label, text, input, textarea, span)
import Html.Attributes exposing (style, class,value)
import Html.Events exposing (onInput, onClick)

type alias Model = Maybe GraphToRosetree.TreeItemFromNode

type Msg = UpdateName | UpdateContent

init: Model
init = 
  let 
    maybeUuid = Uuid.fromString "74b662d2-a0dc-4e64-9c3e-df54c4c052e8"
  in
    case maybeUuid of 
      Nothing ->
        Nothing
      Just uuid ->
        Just {
          uuid = uuid
        , name = "test tree item"
        , content = Svg -- imported from NativeTypes
        }

view: Model -> Html Msg
view model = 
  case model of
    Nothing ->
      div [] [text "No item found"]
    Just item ->
      div 
        [] 
        [
          div 
            [] 
            [
              label [] [text "uuid"]
            , span [] [ text ""]
            ]
        , div 
            [] 
            [
              label [] [text "name"]
            , input [] [text item.name]
            ]
        , div 
            [] 
            [
              label [] [text "content"]
            , input [] [text (NativeTypes.nativeToString item.content)]
            ]
        ]

update: Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  (model, Cmd.none)