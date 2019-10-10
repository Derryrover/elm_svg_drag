module IdRoseTree exposing (Model)

import Tree exposing (Tree)
import IdWrapper exposing (..)

type alias Model a = Tree (IdWrapper a)
