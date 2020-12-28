module Bokeh exposing (main)

import Bootstrap.Form as Form
import Browser
import Dof exposing (confusionLength)
import Graph exposing (AxesType(..), Data, Graph, axesOption)
import Html exposing (Html, h3, text)
import Tools exposing (defaultFValue, defaultFocal, defaultLength, lengths)
import ViewHelper exposing (bootstrap, fValueForm, focalForm, lengthForm)

main = Browser.sandbox { init = init, update = update, view = view }

type Msg = SetFValue String | SetLength String | SetFocal String

type alias Model =
  { fValue: Float, length: Float, focal: Float, graph: Graph }

init : Model
init =
  { fValue = defaultFValue
  , length = defaultLength
  , focal = defaultFocal
  , graph = { label = "ボケ量(錯乱円径)", data = calcGraph defaultFValue defaultLength defaultFocal }
  }

update : Msg -> Model -> Model
update msg model =
  case msg of
    SetFValue fValue ->
      calc { model | fValue = fValue |> String.toFloat |> Maybe.withDefault defaultFValue }
    SetLength length ->
      calc { model | length = length |> String.toFloat |> Maybe.withDefault defaultLength }
    SetFocal focal ->
      calc { model | focal = focal |> String.toFloat |> Maybe.withDefault defaultFocal }

calcGraph : Float -> Float -> Float -> List Data
calcGraph fValue length focal =
  List.map (\l -> { x = l, y = confusionLength fValue length focal l }) lengths

calc : Model -> Model
calc model =
  let
    newdata = calcGraph model.fValue model.length model.focal
    graph = model.graph
  in
    { model
      | graph = { graph | data = newdata }
    }

graphOption =
  let
    xAxes = axesOption "被写体までの距離(mm)"
    yAxes = axesOption "錯乱円径(mm)"
  in
    { xAxes = { xAxes | typ = Logarithmic }
    , yAxes = { yAxes | typ = Logarithmic }
    }

defaultGraphs =
  let
    xFirst = List.head lengths |> Maybe.withDefault defaultLength
    xLast = List.reverse lengths |> List.head |> Maybe.withDefault defaultLength
  in
    [ { label = "錯乱円径0.1", data = [{ x = xFirst, y = 0.1 }, { x = xLast, y = 0.1 }] }
    , { label = "錯乱円径0.015", data = [{ x = xFirst, y = 0.015 }, { x = xLast, y = 0.015 }] }
    ]

view : Model -> Html Msg
view model =
  bootstrap
    [ h3 [] [text "距離とボケ量"]
    , Form.form []
      [ fValueForm SetFValue model.fValue
      , lengthForm "ピント面までの距離" SetLength model.length
      , focalForm SetFocal model.focal
      ]
    , Graph.render ([model.graph] ++ defaultGraphs) graphOption
    ]
