module BokehNeedFvalue exposing (main)

import Bootstrap.Form as Form
import Browser
import Dof exposing (neededFValueFromLength)
import Format exposing (Format(..), defaultFormat, formatSize)
import Graph exposing (Data, Graph)
import Html exposing (Html, h3, text)
import Tools exposing (focals)
import ViewHelper exposing (bootstrap, formatForm, lengthForm)

main = Browser.sandbox { init = init, update = update, view = view }

type Msg = SetFormat String | SetObjLength String

type alias Model =
  { format: Format, objLength: Float, graph: Graph }

defaultObjLength = 1000

init : Model
init =
  { format = defaultFormat
  , objLength = defaultObjLength
  , graph = { label = "必要なF値", data = calcGraph defaultFormat defaultObjLength }
  }

update : Msg -> Model -> Model
update msg model =
  case msg of
    SetFormat format ->
      calc { model | format = format |> Format.fromString }
    SetObjLength length ->
      calc { model | objLength = length |> String.toFloat |> Maybe.withDefault defaultObjLength }

calcGraph : Format -> Float -> List Data
calcGraph format objLength =
  let
    acceptable = 0.3
    formatWide = (formatSize format).x
  in
    List.map (\f -> { x = f, y = neededFValueFromLength f acceptable formatWide objLength }) focals

calc : Model -> Model
calc model =
  let
    newdata = calcGraph model.format model.objLength
    graph = model.graph
  in
    { model
      | graph = { graph | data = newdata }
    }

view : Model -> Html Msg
view model =
  bootstrap
    [ h3 [] [text "物体の背景をボカすのに必要なレンズスペック"]
    , Form.form []
      [ formatForm SetFormat model.format
      , lengthForm "物体の大きさ" SetObjLength model.objLength
      ]
    ]
