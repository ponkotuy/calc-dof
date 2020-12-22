module FOverfocus exposing (..)

import Bootstrap.Form as Form
import Browser
import Dof exposing (overfocus)
import Graph exposing (AxesType(..), Data, Graph, renderGraph)
import Html exposing (Html, h3, text)
import Tools exposing (defaultFocal, fValues)
import ViewHelper exposing (bootstrap, focalForm)

main = Browser.sandbox { init = init, update = update, view = view }

type Msg = SetFocal String

type alias Model =
  { focal: Float, graph: Graph }

init : Model
init = { focal = defaultFocal, graph = { label = "過焦点距離", data = calcGraph defaultFocal } }

update : Msg -> Model -> Model
update msg model =
  case msg of
    SetFocal focal ->
      calc { model | focal = focal |> String.toFloat |> Maybe.withDefault defaultFocal }

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

graphOption =
  { xAxes = "F値"
  , yAxes = "過焦点距離(mm)"
  , xAxesType = Linear
  , yAxesType = Linear
  }

view : Model -> Html Msg
view model =
  bootstrap
  [ h3 [] [text "F値に対する過焦点距離"]
  ,Form.form []
    [ focalForm SetFocal model.focal
    ]
  , renderGraph model.graph graphOption
  ]
