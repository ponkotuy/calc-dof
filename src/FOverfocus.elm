module FOverfocus exposing (..)

import Bootstrap.Form as Form
import Browser
import Dof exposing (overfocus)
import Graph exposing (Data, Graph, renderGraph)
import Html exposing (Html)
import Tools exposing (fValues)
import ViewHelper exposing (bootstrap, focalForm)

main = Browser.sandbox { init = init, update = update, view = view }

type Msg = SetFocal String

type alias Model =
  { focal: Float, graph: Graph }

init : Model
init = { focal = 25.0, graph = { label = "過焦点距離", data = calcGraph 25.0 } }

update : Msg -> Model -> Model
update msg model =
  case msg of
    SetFocal focal ->
      calc { model | focal = focal |> String.toFloat |> Maybe.withDefault 25.0 }

calc : Model -> Model
calc model =
  let
    newdata = calcGraph model.focal
    graph = model.graph
  in
    { model
      | graph = { graph | data = newdata }
    }

calcGraph : Float -> List Data
calcGraph focal =
  List.map (\f -> { x = f, y = overfocus f focal }) fValues

view : Model -> Html Msg
view model =
  bootstrap
  [ Form.form []
    [ focalForm SetFocal model.focal
    ]
  , renderGraph model.graph { xAxes = "F値", yAxes = "過焦点距離(mm)" }
  ]
