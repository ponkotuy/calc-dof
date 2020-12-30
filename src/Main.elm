module Main exposing (..)

import Bootstrap.CDN as CDN
import Bootstrap.Tab as Tab
import Browser
import Html exposing (Html, div, iframe, text)
import Html.Attributes exposing (attribute, src, style)

main = Browser.sandbox { init = init, update = update, view = view }

type Msg = SetTab Tab.State

type alias Model = { tab : Tab.State }

init : Model
init = { tab = Tab.initialState }

update : Msg -> Model -> Model
update msg model =
  case msg of
    SetTab tab ->
      { model | tab = tab }

genIframe : String -> Html msg
genIframe url =
  iframe [src url, attribute "width" "100%", attribute "height" "1080px", style "border" "0px"] []

view : Model -> Html Msg
view model =
  div []
  [ CDN.stylesheet
  , Tab.config SetTab
    |> Tab.items
      [ Tab.item
        { id = "from-lens"
        , link = Tab.link [] [text "距離と被写界深度"]
        , pane = Tab.pane [] [genIframe "from-lens.html"]
        }
      , Tab.item
        { id = "f-overfocus"
        , link = Tab.link [] [text "F値と過焦点距離"]
        , pane = Tab.pane [] [genIframe "f-overfocus.html"]
        }
      , Tab.item
        { id = "bokeh"
        , link = Tab.link [] [text "ボケ量"]
        , pane = Tab.pane [] [genIframe "bokeh.html"]
        }
      , Tab.item
        { id = "bokeh-fvalue"
        , link = Tab.link [] [text "ボケとレンズスペック"]
        , pane = Tab.pane [] [genIframe "bokeh-need-fvalue.html"]
        }
      , Tab.item
        { id = "bokeh-power"
        , link = Tab.link [] [text "必要ボケパワー"]
        , pane = Tab.pane [] [genIframe "bokeh-power.html"]
        }
      ]
    |> Tab.view model.tab
  ]
