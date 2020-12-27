module BokehNeedFvalue exposing (main)

import Bootstrap.Form as Form
import Browser
import Dof exposing (neededFValueFromLength)
import Format exposing (Format(..), defaultFormat, formatName, formatSize)
import Graph exposing (AxesType(..), Data, Graph, GraphOption, renderGraph)
import Html exposing (Html, h3, text)
import Tools exposing (focals)
import ViewHelper exposing (bootstrap, formatForm, lengthForm)

main = Browser.sandbox { init = init, update = update, view = view }

type Msg = SetObjLength String

type alias Model =
  { objLength: Float, graphes: List Graph }

defaultObjLength = 1000

init : Model
init =
  { objLength = defaultObjLength, graphes = calcGraphes defaultObjLength }

update : Msg -> Model -> Model
update msg model =
  case msg of
    SetObjLength length ->
      calc { model | objLength = length |> String.toFloat |> Maybe.withDefault defaultObjLength }

graphData : Format -> Float -> List Data
graphData format objLength =
  let
    acceptable = 0.3
    formatWide = (formatSize format).x
  in
    List.map (\f -> { x = f, y = neededFValueFromLength f acceptable formatWide objLength }) focals

calcGraphes : Float -> List Graph
calcGraphes objLength = List.map (\f -> { label = formatName f, data = graphData f objLength }) Format.all

calc : Model -> Model
calc model =
  let
    newGraphes = calcGraphes model.objLength
  in
    { model | graphes = newGraphes }

graphOption : GraphOption
graphOption =
  { xAxes = "焦点距離(mm)"
  , yAxes = "必要なF値"
  , xAxesType = Linear
  , yAxesType = Linear
  }

view : Model -> Html Msg
view model =
  bootstrap
    [ h3 [] [text "物体の背景をボカすのに必要なレンズスペック"]
    , Form.form []
      [ lengthForm "物体の大きさ" SetObjLength model.objLength ]
    , renderGraph model.graphes graphOption
    ]
