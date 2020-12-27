module FOverfocus exposing (main)

import Bootstrap.Form as Form
import Browser
import Dof exposing (overfocus)
import Graph exposing (AxesType(..), Data, Graph)
import Html exposing (Html, h3, text)
import Tools exposing (defaultAcceptable, defaultFocal, fValues)
import ViewHelper exposing (acceptableForm, bootstrap, focalForm)

main = Browser.sandbox { init = init, update = update, view = view }

type Msg = SetFocal String | SetAcceptable String

type alias Model =
  { focal: Float, acceptable: Float, graph: Graph }

init : Model
init =
  { focal = defaultFocal
  , acceptable = defaultAcceptable
  , graph = { label = "過焦点距離", data = calcGraph defaultFocal defaultAcceptable } }

update : Msg -> Model -> Model
update msg model =
  case msg of
    SetFocal focal ->
      calc { model | focal = focal |> String.toFloat |> Maybe.withDefault defaultFocal }
    SetAcceptable acceptable ->
      calc { model | acceptable = acceptable |> String.toFloat |> Maybe.withDefault defaultAcceptable }

calc : Model -> Model
calc model =
  let
    newdata = calcGraph model.focal model.acceptable
    graph = model.graph
  in
    { model
      | graph = { graph | data = newdata }
    }

calcGraph : Float -> Float -> List Data
calcGraph focal acceptable =
  List.map (\f -> { x = f, y = overfocus f focal acceptable }) fValues

graphOption =
  { xAxes = { label = "F値", typ = Linear }
  , yAxes = { label = "過焦点距離(mm)", typ = Linear }
  }

view : Model -> Html Msg
view model =
  bootstrap
  [ h3 [] [text "F値に対する過焦点距離"]
  ,Form.form []
    [ focalForm SetFocal model.focal
    , acceptableForm SetAcceptable model.acceptable
    ]
  , Graph.render [model.graph] graphOption
  ]
