module FromLens exposing (..)
import Bootstrap.Form as Form

import Browser
import Dof exposing (..)
import Graph exposing (Data, Graph, renderGraph)
import Html exposing (Html)
import Tools exposing (lengths)
import ViewHelper exposing (bootstrap, fValueForm, focalForm, overfocusView)

main = Browser.sandbox { init = init, update = update, view = view }

type Msg = SetFValue String | SetFocal String

type alias Model =
  { fValue: Float, focal: Float, graph: Graph }

init : Model
init =
  { fValue = 1.4, focal = 25.0, graph = { label = "後方被写界深度", data = calcGraph 1.4 25.0 } }

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
  bootstrap
  [ Form.form []
    [ fValueForm SetFValue model.fValue
    , focalForm SetFocal model.focal
    , overfocusView model.fValue model.focal
    ]
  , renderGraph model.graph { xAxes = "被写体までの距離(mm)", yAxes = "後方被写界深度(mm)" }
  ]
