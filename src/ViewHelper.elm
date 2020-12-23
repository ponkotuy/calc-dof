module ViewHelper exposing (..)

import Bootstrap.Button as Button exposing (Option, onClick)
import Bootstrap.CDN as CDN
import Bootstrap.Form as Form
import Bootstrap.Form.Fieldset as Fieldset
import Bootstrap.Form.Input as Input
import Bootstrap.Form.Radio as Radio
import Dof exposing (milliMeter, overfocus)
import Format exposing (Format(..))
import Html exposing (Html, div, text)
import Html.Attributes exposing (for, id, step)
import Tools exposing (WithDetail, acceptableStr, acceptables, fValueStrs, focalsStr, lengthStrs)

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

lengthForm : String -> (String -> msg) -> Float -> Html msg
lengthForm obj msg length =
  let
    buttons = List.map (\l -> Button.button [Button.light, onClick (msg l)] [text l]) lengthStrs
  in
    Form.group []
      [ Form.label [for "length"] [text (obj ++ "(mm)")]
      , Input.number [Input.id "length", Input.value (String.fromFloat length), Input.onInput msg, Input.attrs [step "10"]]
      , div [] buttons
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

acceptableForm : (String -> msg) -> Float -> Html msg
acceptableForm msg acceptable =
  let
    btnText : WithDetail -> String
    btnText a = (String.fromFloat a.value) ++ "(" ++ a.detail ++ ")"
    buttons = List.map (\a -> Button.button [Button.light, onClick (acceptableStr a |> msg)] [text (btnText a)]) acceptables
  in
    Form.group []
      [ Form.label [for "acceptable"] [text "許容錯乱円径"]
      , Input.number [Input.id "acceptable", Input.value (String.fromFloat acceptable), Input.onInput msg, Input.attrs [step "0.0001"]]
      , div [] buttons
      ]

formatForm : (String -> msg) -> Format -> Html msg
formatForm msg format =
    Fieldset.config
      |> Fieldset.asGroup
      |> Fieldset.legend [] [text "センサーフォーマット"]
      |> Fieldset.children
        ( Radio.radioList "format"
          [ Radio.create [Radio.id "mft", Radio.onClick (msg "MFT"), Radio.checked (format == MicroFourThirds)] "マイクロフォーサーズ"
          , Radio.create [Radio.id "apsc", Radio.onClick (msg "APSC"), Radio.checked (format == APS_C)] "APS-C"
          , Radio.create [Radio.id "fullsize", Radio.onClick (msg "FullSize"), Radio.checked(format == FullSize)] "フルサイズ"
          ]
        )
      |> Fieldset.view

overfocusView : Float -> Float -> Float -> Html msg
overfocusView fValue focal acceptable =
  let
    oFocus = overfocus fValue focal acceptable
  in
    Form.group []
      [ Form.label [for "overfocus"] [text "過焦点距離(mm)"]
      , div [id "overfocus"] [text (milliMeter oFocus)]
      ]
