module Main exposing (..)
import Bootstrap.CDN as CDN
import Bootstrap.Form as Form
import Bootstrap.Form.Input as Input

import Browser
import Dof exposing (..)
import Graph exposing (Data, Graph, renderGraph)
import Html exposing (Html, div, text)
import Html.Attributes exposing (for, id, step)

main = Browser.sandbox { init = init, update = update, view = view }

type Msg = SetFValue String | SetFocal String

type alias Model =
  { fValue: Float, focal: Float, graph: Graph }

init : Model
init =
  { fValue = 1.4, focal = 25.0, graph = { label = "後方被写界深度", data = calcGraph 1.4 25.0 } }

lengths = [100, 150, 200, 300, 500, 700, 1000, 1500, 2000, 3000, 5000, 7000, 10000, 15000, 20000, 30000, 50000, 70000, 100000]

update : Msg -> Model -> Model
update msg model =
  case msg of
    SetFValue fValue ->
      calc { model | fValue = fValue |> String.toFloat |> Maybe.withDefault 1.4 }
    SetFocal focal ->
      calc { model | focal = focal |> String.toFloat |> Maybe.withDefault 25.0 }

calcGraph : Float -> Float -> List Data
calcGraph fValue focal =
  let
    diff len =
      let
        x = after fValue len focal
      in
        if x > 0 then x else 0
    f len = { x = len, y = diff len }
    result = List.map f lengths
    max = List.map (\p -> p.y) result |> List.maximum |> Maybe.withDefault 0
  in
     List.map (\p -> if p.y == 0 then { p | y = max } else p) result

calc : Model -> Model
calc model =
  let
    newdata = calcGraph model.fValue model.focal
    graph = model.graph
  in
    { model
      | graph = { graph | data = newdata }
    }

view : Model -> Html Msg
view model =
  let
    oFocus = overfocus model.fValue model.focal
  in
    div []
    [ CDN.stylesheet
    , Form.form []
      [ Form.group []
        [ Form.label [for "fvalue"] [text "F値"]
        , Input.number [Input.id "fvalue", Input.value (String.fromFloat model.fValue), Input.onInput SetFValue, Input.attrs [step "0.1"]]
        ]
      , Form.group []
        [ Form.label [for "focal"] [text "焦点距離(mm)"]
        , Input.number [Input.id "focal", Input.value (String.fromFloat model.focal), Input.onInput SetFocal, Input.attrs [step "0.5"]]
        ]
      , Form.group []
        [ Form.label [for "overfocus"] [text "過焦点距離(mm)"]
        , div [id "overfocus"] [text (milliMeter oFocus)]
        ]
      ]
    , renderGraph model.graph { xAxes = "被写体までの距離(mm)", yAxes = "後方被写界深度(mm)" }
    ]
