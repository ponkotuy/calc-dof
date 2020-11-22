module Main exposing (..)
import Browser
import Debug exposing (toString)
import Html exposing (Html, div, input, text)
import Html.Attributes exposing (value)
import Html.Events exposing (onInput)

main = Browser.sandbox { init = init, update = update, view = view }

type Msg = SetFValue String | SetLength String | SetFocal String

type alias Model =
  { fValue: Float, length: Float, focal: Float, before: Float, after: Float }


init : Model
init =
  { fValue = 1.4, length = 100.0, focal = 14.0, before = before 1.4 100.0 14.0, after = after 1.4 100.0 14.0 }

update : Msg -> Model -> Model
update msg model =
  case msg of
    SetFValue fValue ->
      calc { model | fValue = fValue |> String.toFloat |> Maybe.withDefault 1.4 }
    SetLength length ->
      calc { model | length = length |> String.toFloat |> Maybe.withDefault 100.0 }
    SetFocal focal ->
      calc { model | focal = focal |> String.toFloat |> Maybe.withDefault 14.0 }

calc : Model -> Model
calc model =
  { model
    | before = before model.fValue model.length model.focal
      , after = after model.fValue model.length model.focal }


before fValue length focal =
  acceptable_circle * fValue * length * length / (focal * focal + acceptable_circle * fValue * length)

after fValue length focal =
  acceptable_circle * fValue * length * length / (focal * focal - acceptable_circle * fValue * length)

acceptable_circle = 0.03

view : Model -> Html Msg
view model =
  let
    x = (toString (model.length - model.before)) ++ "mm"
    y = if model.after > 0 then (toString (model.length + model.after)) ++ "mm" else "∞"
  in
    div []
      [ input [ value (toString model.fValue), onInput SetFValue ] []
      , input [ value (toString model.length), onInput SetLength ] []
      , input [ value (toString model.focal), onInput SetFocal ] []
      , div [] [ text (x ++ " - " ++ y) ]
    ]
