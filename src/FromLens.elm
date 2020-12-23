module FromLens exposing (main)
import Bootstrap.Form as Form

import Browser
import Dof exposing (..)
import Graph exposing (AxesType(..), Data, Graph, GraphOption, renderGraph)
import Html exposing (Html, h3, text)
import Tools exposing (defaultAcceptable, defaultFValue, defaultFocal, lengths)
import ViewHelper exposing (acceptableForm, bootstrap, fValueForm, focalForm, overfocusView)

main = Browser.sandbox { init = init, update = update, view = view }

type Msg = SetFValue String | SetFocal String | SetAcceptable String

type alias Model =
  { fValue: Float, focal: Float, acceptable: Float, graph: Graph }

init : Model
init =
  { fValue = defaultFValue
  , focal = defaultFocal
  , acceptable = defaultAcceptable
  , graph = { label = "後方被写界深度", data = calcGraph defaultFValue defaultFocal defaultAcceptable }
  }

update : Msg -> Model -> Model
update msg model =
  case msg of
    SetFValue fValue ->
      calc { model | fValue = fValue |> String.toFloat |> Maybe.withDefault defaultFValue }
    SetFocal focal ->
      calc { model | focal = focal |> String.toFloat |> Maybe.withDefault defaultFocal }
    SetAcceptable acceptable ->
      calc { model | acceptable = acceptable |> String.toFloat |> Maybe.withDefault defaultAcceptable }

calcGraph : Float -> Float -> Float -> List Data
calcGraph fValue focal acceptable =
  let
    diff len =
      let
        x = after fValue len focal acceptable
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
    newdata = calcGraph model.fValue model.focal model.acceptable
    graph = model.graph
  in
    { model
      | graph = { graph | data = newdata }
    }

graphOption : GraphOption
graphOption =
  { xAxes = "被写体までの距離(mm)"
  , yAxes = "後方被写界深度(mm)"
  , xAxesType = Logarithmic
  , yAxesType = Logarithmic
  }

view : Model -> Html Msg
view model =
  bootstrap
    [ h3 [] [text "レンズから被写界深度"]
    ,Form.form []
      [ fValueForm SetFValue model.fValue
      , focalForm SetFocal model.focal
      , acceptableForm SetAcceptable model.acceptable
      , overfocusView model.fValue model.focal model.acceptable
      ]
    , renderGraph [model.graph] graphOption
    ]
