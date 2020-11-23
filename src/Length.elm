module Length exposing (..)
import Bootstrap.CDN as CDN
import Bootstrap.Form as Form
import Bootstrap.Form.Input as Input

import Bootstrap.Grid as Grid
import Browser
import Dof exposing (..)
import Html exposing (Html, text)
import Html.Attributes exposing (for, step, style)
import LineChart
import LineChart.Area as Area
import LineChart.Axis as Axis
import LineChart.Axis.Intersection as Intersection
import LineChart.Axis.Title as Title
import LineChart.Colors as Colors
import LineChart.Container as Container
import LineChart.Dots as Dots
import LineChart.Events as Events
import LineChart.Grid as Grid
import LineChart.Interpolation as Interpolation
import LineChart.Junk as Junk
import LineChart.Legends as Legends
import LineChart.Line as Line

main = Browser.sandbox { init = init, update = update, view = view }

type Msg = SetFValue String | SetFocal String

type alias Model =
  { fValue : Float, focal : Float, before : Float, after : Float }

type alias Datum =
  { x : Float, y : Float }

init : Model
init =
  { fValue = 1.4, focal = 25.0, before = before 1.4 1000.0 25.0, after = after 1.4 1000.0 25.0 }

update : Msg -> Model -> Model
update msg model =
  case msg of
    SetFValue fValue ->
      { model | fValue = fValue |> String.toFloat |> Maybe.withDefault 1.4 }
    SetFocal focal ->
      { model | focal = focal |> String.toFloat |> Maybe.withDefault 25.0 }


chartConfig : LineChart.Config Datum Msg
chartConfig =
  { x = Axis.default 800 "被写体の距離(mm)" .x
  , y = Axis.default 640 "被写界深度(mm)" .y
  , container = Container.default "length-chart"
  , interpolation = Interpolation.linear
  , intersection = Intersection.default
  , legends = Legends.default
  , events = Events.default
  , junk = Junk.default
  , grid = Grid.default
  , area = Area.default
  , line = Line.default
  , dots = Dots.default
  }

calcBefore model length =
  { x = length, y = -(before model.fValue length model.focal) }

calcAfter model length =
  let
    v = after model.fValue length model.focal
  in
    if v > 0 then Just { x = length, y = v } else Nothing


view : Model -> Html Msg
view model =
  let
    lengths = [250, 350, 500, 700, 1000, 1400, 2000, 2800, 4000, 5600, 8000]
    befores = List.map (calcBefore model) lengths
    afters = lengths |> List.filterMap (calcAfter model)
  in
    Grid.container [style "margin-top" "40px"]
    [ CDN.stylesheet
    , Form.form []
      [ Form.group []
        [ Form.label [for "fvalue"] [text "F値"]
        , Input.number [Input.id "fvalue", Input.value (String.fromFloat model.fValue), Input.onInput SetFValue, Input.attrs [step "0.1"]]
        ]
      , Form.group []
        [ Form.label [for "focal"] [text "焦点距離(mm)"]
        , Input.number [Input.id "focal", Input.value (String.fromFloat model.focal), Input.onInput SetFocal, Input.attrs [step "0.5"]]
        ]
      ]
    , LineChart.viewCustom chartConfig
      [ LineChart.line Colors.blue Dots.circle "前方深度" befores
      , LineChart.line Colors.red Dots.cross "後方深度" afters]
    ]
