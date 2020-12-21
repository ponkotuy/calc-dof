module Main exposing (..)

import Bootstrap.CDN as CDN
import Bootstrap.Tab as Tab
import Browser
import Html exposing (Html, div, h2, iframe, text)
import Html.Attributes exposing (attribute, height, src, style, width)

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
  iframe [src url, attribute "width" "100%", attribute "height" "820px", style "border" "0px"] []

view : Model -> Html Msg
view model =
  div []
  [ CDN.stylesheet
  , Tab.config SetTab
    |> Tab.items
      [ Tab.item
        { id = "from-lens"
        , link = Tab.link [] [text "FromLens"]
        , pane = Tab.pane [] [genIframe "from-lens.html"]
        }
      ]
    |> Tab.view model.tab
  ]
