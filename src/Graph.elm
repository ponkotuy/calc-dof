module Graph exposing (Data, Graph, GraphOption, renderGraph)

import Html exposing (Html, node)
import Html.Attributes exposing (attribute)
import Json.Encode as Encode
type alias Data =
  { x: Float, y: Float }

type alias Graph =
  { label: String, data: List Data }

type alias GraphOption =
  { xAxes: String, yAxes: String }

toJson : Graph -> String
toJson graph =
  let
    encodeData : Data -> List (String, Encode.Value)
    encodeData data =
      [ ("x", Encode.float data.x)
        , ("y", Encode.float data.y)
      ]
    encoder = Encode.list Encode.object
      [ [ ("label", Encode.string graph.label)
        , ("data", Encode.list Encode.object (List.map encodeData graph.data))
        ]
      ]
  in
    Encode.encode 0 encoder

toJsonOption : GraphOption -> String
toJsonOption option =
  let
    encoder = Encode.object
      [ ("xAxes", Encode.string option.xAxes)
      , ("yAxes", Encode.string option.yAxes)
      ]
  in
    Encode.encode 0 encoder

renderGraph : Graph -> GraphOption -> Html msg
renderGraph graph option =
  let
    json = toJson graph
    optionJson = toJsonOption option
  in
    node "render-graph"
      [ attribute "json" json
      , attribute "option" optionJson
      ] []
