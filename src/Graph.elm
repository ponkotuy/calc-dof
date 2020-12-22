module Graph exposing (Data, Graph, GraphOption, renderGraph, AxesType(..))

import Html exposing (Html, node)
import Html.Attributes exposing (attribute)
import Json.Encode as Encode
type alias Data =
  { x: Float, y: Float }

type alias Graph =
  { label: String, data: List Data }

type alias GraphOption =
  { xAxes: String, yAxes: String, xAxesType: AxesType, yAxesType: AxesType }

type AxesType = Category | Linear | Logarithmic | Time

toJson : List Graph -> String
toJson graphes =
  let
    encodeData : Data -> List (String, Encode.Value)
    encodeData data =
      [ ("x", Encode.float data.x)
        , ("y", Encode.float data.y)
      ]
    encodeGraph graph =
      [ ("label", Encode.string graph.label)
      , ("data", Encode.list Encode.object (List.map encodeData graph.data))
      ]
    encoder = Encode.list Encode.object (List.map encodeGraph graphes)
  in
    Encode.encode 0 encoder

toJsonOption : GraphOption -> String
toJsonOption option =
  let
    encoder = Encode.object
      [ ("xAxes", Encode.string option.xAxes)
      , ("yAxes", Encode.string option.yAxes)
      , ("xAxesType", Encode.string (axesType option.xAxesType))
      , ("yAxesType", Encode.string (axesType option.yAxesType))
      ]
  in
    Encode.encode 0 encoder

renderGraph : List Graph -> GraphOption -> Html msg
renderGraph graphes option =
  let
    json = toJson graphes
    optionJson = toJsonOption option
  in
    node "render-graph"
      [ attribute "json" json
      , attribute "option" optionJson
      ] []

axesType : AxesType -> String
axesType typ =
  case typ of
    Category -> "category"
    Linear -> "linear"
    Logarithmic -> "logarithmic"
    Time -> "time"
