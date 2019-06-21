module SvgAnimationView exposing (..)

import Html exposing (Html)
import Svg exposing (circle, line, svg, g, polygon, animate)
import Svg.Attributes exposing (
  viewBox, 
  width, 
  height, fill, 
  points, r, cx, cy, x, y, 
  fillOpacity, begin, fill, 
  attributeName, dur, to, repeatCount, values )

import Coordinate exposing(XY, toSvgString, listToString)
import SvgPolygon

import SvgTypes exposing (Viewbox, SquareSize)

import List
import SvgTypes exposing (Viewbox, viewBoxToString)




viewboxConfig: Viewbox
viewboxConfig =
  { xLeft = -100
  , yTop = -100
  , width = 200
  , height = 200
  }

getSvgAttributes: List (Svg.Attribute a)
getSvgAttributes = 
  [ viewBox (viewBoxToString viewboxConfig)
  , width "300px" 
  ]
    
  

view: SvgPolygon.Model -> SvgPolygon.Model -> Html a
view svg1 svg2 = 
  svg 
    (getSvgAttributes)
    [
     polygon 
      [ fill "purple"
      , points (listToString [svg1.one.xy, svg1.two.xy, svg1.three.xy])
      ] 
      [
        --<animate begin="indefinite" fill="freeze" attributeName="points" dur="500ms"  to="0,0 300,0 200,200 00,200" />
        animate [ 
                  --begin "indefinite"
                -- , fill "freeze"
                  repeatCount "indefinite" 
                , attributeName "points"
                , dur "5500ms"
                --, to (listToString [svg2.one.xy, svg2.two.xy, svg2.three.xy])
                , values 
                  ( (listToString [svg1.one.xy, svg1.two.xy, svg1.three.xy]) ++ 
                    ";" ++ 
                    (listToString [svg2.one.xy, svg2.two.xy, svg2.three.xy]) ++
                    ";" ++
                    (listToString [svg1.one.xy, svg1.two.xy, svg1.three.xy])
                  )
                ] [] 
      ] 
    ]