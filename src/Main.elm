module Main exposing (..)
import Bootstrap.CDN as CDN
import Bootstrap.Form as Form
import Bootstrap.Form.Input as Input

import Bootstrap.Grid as Grid
import Browser
import Dof exposing (..)
import Html exposing (Html, div, input, text)
import Html.Attributes exposing (for, id, step, style)

main = Browser.sandbox { init = init, update = update, view = view }

type Msg = SetFValue String | SetLength String | SetFocal String

type alias Model =
  { fValue: Float, length: Float, focal: Float, before: Float, after: Float }

init : Model
init =
  { fValue = 1.4, length = 1000.0, focal = 25.0, before = before 1.4 1000.0 25.0, after = after 1.4 1000.0 25.0 }

update : Msg -> Model -> Model
update msg model =
  case msg of
    SetFValue fValue ->
      calc { model | fValue = fValue |> String.toFloat |> Maybe.withDefault 1.4 }
    SetLength length ->
      calc { model | length = length |> String.toFloat |> Maybe.withDefault 1000.0 }
    SetFocal focal ->
      calc { model | focal = focal |> String.toFloat |> Maybe.withDefault 25.0 }

calc : Model -> Model
calc model =
  { model
    | before = before model.fValue model.length model.focal
      , after = after model.fValue model.length model.focal }

view : Model -> Html Msg
view model =
  let
    x = (milliMeter (model.length - model.before))
    y = if model.after > 0 then (milliMeter (model.length + model.after)) else "∞"
  in
    Grid.container [style "margin-top" "40px"]
    [ CDN.stylesheet
    , Form.form []
      [ Form.group []
        [ Form.label [for "fvalue"] [text "F値"]
        , Input.number [Input.id "fvalue", Input.value (String.fromFloat model.fValue), Input.onInput SetFValue, Input.attrs [step "0.1"]]
        ]
      , Form.group []
        [ Form.label [for "length"] [text "被写体までの距離(mm)"]
        , Input.number [Input.id "length", Input.value (String.fromFloat model.length), Input.onInput SetLength, Input.attrs [step "100"]]
        ]
      , Form.group []
        [ Form.label [for "focal"] [text "焦点距離(mm)"]
        , Input.number [Input.id "focal", Input.value (String.fromFloat model.focal), Input.onInput SetFocal, Input.attrs [step "0.5"]]
        ]
      , Form.group []
        [ Form.label [for "result"] [text "被写界深度"]
        , div [id "result"] [ text (x ++ " - " ++ y) ]
        ]
      ]
    ]
