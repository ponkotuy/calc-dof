module BokehNeedFvalue exposing (main)

import Bootstrap.Form as Form
import Browser
import Dof exposing (neededFValueFromLength)
import Format exposing (Format(..), formatName, formatSize)
import Graph exposing (AxesType(..), Data, Graph, GraphOption, axesOption)
import Html exposing (Html, h3, text)
import Tools exposing (focals)
import ViewHelper exposing (acceptableForm, bootstrap, lengthForm)

main = Browser.sandbox { init = init, update = update, view = view }

-- default acceptable
defaultAc = 0.1

type Msg = SetAcceptable String | SetObjLength String

type alias Model =
  { accelable: Float, objLength: Float, graphes: List Graph }

defaultObjLength = 1000

init : Model
init =
  { accelable = defaultAc, objLength = defaultObjLength, graphes = calcGraphes defaultAc defaultObjLength }

update : Msg -> Model -> Model
update msg model =
  case msg of
    SetObjLength length ->
      calc { model | objLength = length |> String.toFloat |> Maybe.withDefault defaultObjLength }
    SetAcceptable acceptable ->
      calc { model | accelable = acceptable |> String.toFloat |> Maybe.withDefault defaultAc }

graphData : Format -> Float -> Float -> List Data
graphData format acceptable objLength =
  let
    formatWide = (formatSize format).x
  in
    List.map (\f -> { x = f, y = neededFValueFromLength f acceptable formatWide objLength }) focals

calcGraphes : Float -> Float -> List Graph
calcGraphes acceptable objLength = List.map (\f -> { label = formatName f, data = graphData f acceptable objLength }) Format.all

calc : Model -> Model
calc model =
  let
    newGraphes = calcGraphes model.accelable model.objLength
  in
    { model | graphes = newGraphes }

graphOption : GraphOption
graphOption =
  let
    xAxes = axesOption "焦点距離(mm)"
    yAxes = axesOption "必要なF値"
  in
    { xAxes = { xAxes | typ = Logarithmic, min = List.minimum focals }
    , yAxes = { yAxes | typ = Logarithmic, reverse = True, max = Just 10 }
    }

view : Model -> Html Msg
view model =
  bootstrap
    [ h3 [] [text "物体の背景をボカすのに必要なレンズスペック"]
    , Form.form []
      [ lengthForm "物体の大きさ" SetObjLength model.objLength
      , acceptableForm SetAcceptable model.accelable
      ]
    , Graph.render model.graphes graphOption
    ]
