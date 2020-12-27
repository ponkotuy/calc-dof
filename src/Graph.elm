module Graph exposing (Data, Graph, GraphOption, AxesOption, render, AxesType(..))

import Html exposing (Html, node)
import Html.Attributes exposing (attribute)
import Json.Encode as Encode
type alias Data =
  { x: Float, y: Float }

type alias Graph =
  { label: String, data: List Data }

type alias GraphOption =
  { xAxes: AxesOption, yAxes: AxesOption }

type alias AxesOption =
  { label: String, typ: AxesType }

type AxesType = Category | Linear | Logarithmic | Time

gen : List Graph -> GraphOption -> Encode.Value
gen graphes option =
  Encode.object
    [ ("type", Encode.string "line")
    , ("data", genData graphes)
    , ("options", genOptions option)
    ]

genData : List Graph -> Encode.Value
genData graphes =
  let
    encodeData : Data -> List (String, Encode.Value)
    encodeData data =
      [ ("x", Encode.float data.x)
        , ("y", Encode.float data.y)
      ]
    encodeGraph graph =
      [ ("label", Encode.string graph.label)
      , ("data", Encode.list Encode.object (List.map encodeData graph.data))
      , ("fill", Encode.bool ((List.length graphes) == 1))
      ]
    encodeDataset = Encode.list Encode.object (List.map encodeGraph graphes)
  in
    Encode.object [("datasets", encodeDataset)]

genOptions : GraphOption -> Encode.Value
genOptions option =
  Encode.object
    [ ("title", Encode.object [("display", Encode.bool False)])
    , ("scales", Encode.object [("xAxes", genAxes option.xAxes), ("yAxes", genAxes option.yAxes)])
    ]

genAxes : AxesOption -> Encode.Value
genAxes option =
  Encode.list Encode.object
    [ [ ("type", Encode.string (axesType option.typ))
      , ("scaleLebel", genScaleLevel option)
      ]
    ]

genScaleLevel : AxesOption -> Encode.Value
genScaleLevel option =
  Encode.object
    [ ("display", Encode.bool True)
    , ("labelString", Encode.string option.label)
    ]

render : List Graph -> GraphOption -> Html msg
render graphes option =
  let
    json = gen graphes option
  in
    node "render-graph"
      [ attribute "json" (Encode.encode 0 json)] []

axesType : AxesType -> String
axesType typ =
  case typ of
    Category -> "category"
    Linear -> "linear"
    Logarithmic -> "logarithmic"
    Time -> "time"
