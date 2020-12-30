module BokehPower exposing (main)

import Bootstrap.Form as Form
import Browser
import Dof exposing (neededFValueFromLength)
import Format exposing (Format, formatName, formatSize)
import Graph exposing (AxesType(..), Data, Graph, GraphOption, axesOption)
import Html exposing (Html, h3, text)
import Tools exposing (lengths)
import ViewHelper exposing (acceptableForm, bootstrap)

main = Browser.sandbox { init = init, update = update, view = view }

-- default acceptable
defaultAc = 0.1

type Msg = SetAcceptable String

type alias Model = { acceptable: Float, graphes: List Graph }

init : Model
init = { acceptable = defaultAc, graphes = calcGraphes defaultAc }

update : Msg -> Model -> Model
update msg model =
  case msg of
    SetAcceptable acceptable ->
       calc { model | acceptable = acceptable |> String.toFloat |> Maybe.withDefault defaultAc }

graphData : Float -> Format -> List Data
graphData acceptable format =
  List.map (\l -> { x = l, y = calcBokehPower acceptable format l }) lengths

calcGraphes : Float -> List Graph
calcGraphes acceptable =
  List.map (\f -> { label = formatName f, data = graphData acceptable f }) Format.all

calcBokehPower : Float -> Format -> Float -> Float
calcBokehPower acceptable format objLength =
  let
    focal = 50
    formatWide = (formatSize format).x
    f = neededFValueFromLength focal acceptable formatWide
  in
    focal / (f objLength)

calc : Model -> Model
calc model =
  let
    newGraphes = calcGraphes model.acceptable
  in
    { model | graphes = newGraphes }

graphOption : GraphOption
graphOption =
  let
    xAxes = axesOption "物体の大きさ"
    yAxes = axesOption "必要なボケパワー"
  in
    { xAxes = { xAxes | typ = Logarithmic }
    , yAxes = { yAxes | typ = Logarithmic }
    }

view : Model -> Html Msg
view model =
  bootstrap
    [ h3 [] [text "物体の背景をボカすのに必要なボケパワー"]
    , Form.form [] [acceptableForm SetAcceptable model.acceptable]
    , Graph.render model.graphes graphOption
    ]
