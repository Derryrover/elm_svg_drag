module ViewJson exposing (view)

import Html exposing (Html, div, text, input, textarea)
import Html.Attributes exposing (style, class,value)
import JsonTypes

type alias Model = String


view: Model -> Html a
view string = 
  div 
    [] 
    [
      textarea [value string] [] 
    ]