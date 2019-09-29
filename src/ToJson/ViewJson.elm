module ViewJson exposing (a)

import Html exposing (Html, div, text, input)
import Html.Attributes exposing (style, class,value)

type alias Model = String


a = 1



view: Model -> Html a
view string = 
  div 
    [] 
    [
      input [value string] [] 
    ]