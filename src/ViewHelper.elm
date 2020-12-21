module ViewHelper exposing (..)

import Bootstrap.Button as Button exposing (Option, onClick)
import Bootstrap.CDN as CDN
import Bootstrap.Form as Form
import Bootstrap.Form.Input as Input
import Dof exposing (milliMeter, overfocus)
import Html exposing (Html, div, text)
import Html.Attributes exposing (for, id, step)
import Tools exposing (fValueStrs, focalsStr)

bootstrap : List (Html msg) -> Html msg
bootstrap xs = div [] ([CDN.stylesheet] ++ xs)

focalForm : (String -> msg) -> Float -> Html msg
focalForm msg focal =
  let
    focusButtons = List.map (\f -> Button.button [Button.light, onClick (msg f)] [text f]) focalsStr
  in
    Form.group []
      [ Form.label [for "focal"] [text "焦点距離(mm)"]
      , Input.number [Input.id "focal", Input.value (String.fromFloat focal), Input.onInput msg, Input.attrs [step "0.5"]]
      , div [] focusButtons
      ]

fValueForm : (String -> msg) -> Float -> Html msg
fValueForm msg fValue =
  let
    fValueButtons = List.map (\f -> Button.button [Button.light, onClick (msg f)] [text f]) fValueStrs
  in
    Form.group []
      [ Form.label [for "fvalue"] [text "F値"]
      , Input.number [Input.id "fvalue", Input.value (String.fromFloat fValue), Input.onInput msg, Input.attrs [step "0.05"]]
      , div [] fValueButtons
      ]

overfocusView : Float -> Float -> Html msg
overfocusView fValue focal =
  let
    oFocus = overfocus fValue focal
  in
    Form.group []
      [ Form.label [for "overfocus"] [text "過焦点距離(mm)"]
      , div [id "overfocus"] [text (milliMeter oFocus)]
      ]
