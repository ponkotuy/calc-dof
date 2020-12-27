module FromLens exposing (main)
import Bootstrap.Form as Form

import Browser
import Dof exposing (..)
import Graph exposing (AxesType(..), Data, Graph, GraphOption)
import Html exposing (Html, h3, text)
import Tools exposing (defaultAcceptable, defaultFValue, defaultFocal, lengths)
import ViewHelper exposing (acceptableForm, bootstrap, fValueForm, focalForm, overfocusView)

main = Browser.sandbox { init = init, update = update, view = view }

type Msg = SetFValue String | SetFocal String | SetAcceptable String

type alias Model =
  { fValue: Float, focal: Float, acceptable: Float, before: Graph, after: Graph }

init : Model
init =
  { fValue = defaultFValue
  , focal = defaultFocal
  , acceptable = defaultAcceptable
  , before = { label = "前方被写界深度", data = calcGraphBefore defaultFValue defaultFocal defaultAcceptable }
  , after = { label = "後方被写界深度", data = calcGraphAfter defaultFValue defaultFocal defaultAcceptable }
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

calcGraphBefore : Float -> Float -> Float -> List Data
calcGraphBefore fValue focal acceptable =
  List.map (\l -> { x = l, y = before fValue l focal acceptable }) lengths

calcGraphAfter : Float -> Float -> Float -> List Data
calcGraphAfter fValue focal acceptable =
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
    newBefore = calcGraphBefore model.fValue model.focal model.acceptable
    newAfter = calcGraphAfter model.fValue model.focal model.acceptable
    before = model.before
    after = model.after
  in
    { model
      | after = { after | data = newAfter }, before = { before | data = newBefore }
    }

graphOption : GraphOption
graphOption =
  { xAxes = { label = "被写体までの距離(mm)", typ = Logarithmic }
  , yAxes = { label = "後方被写界深度(mm)", typ = Logarithmic }
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
    , Graph.render [model.before, model.after] graphOption
    ]
