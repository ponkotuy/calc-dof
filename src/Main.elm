module Main exposing (..)

import Bootstrap.CDN as CDN
import Bootstrap.Tab as Tab exposing (Item, customInitialState)
import Browser exposing (Document)
import Browser.Navigation exposing (Key)
import Html exposing (Html, iframe, text)
import Html.Attributes exposing (attribute, src, style)
import Url exposing (Url)
import Url.Parser as Parser
import Url.Parser.Query as Query

main = Browser.application
  { init = init
  , update = update
  , view = view
  , subscriptions = (\_ -> Sub.none)
  , onUrlChange = UrlCahnge
  , onUrlRequest = UrlRequest
  }

type Msg = SetTab Tab.State | UrlCahnge Url | UrlRequest Browser.UrlRequest

type alias Model = { tab: Tab.State }

type alias DofTab = { id: String, text: String, html: String }

tabs : List DofTab
tabs =
  [ {id = "from-lens", text = "距離と被写界深度", html = "from-lens.html"}
  , {id = "f-overfocus", text = "F値と過焦点距離", html = "f-overfocus.html"}
  , {id = "bokeh", text = "ボケ量", html = "bokeh.html"}
  , {id = "bokeh-fvalue", text = "ボケとレンズスペック", html = "bokeh-need-fvalue.html"}
  ]

init : () -> Url -> Key -> (Model, Cmd msg)
init _ url _ =
  ({ tab = parseUrl url }, Cmd.none)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  let
    newmodel =
      case msg of
        SetTab tab ->
          { model | tab = tab }
        UrlCahnge url ->
          { model | tab = parseUrl url }
        UrlRequest _ ->
          model
  in
    (newmodel, Cmd.none)

genIframe : String -> Html msg
genIframe url =
  iframe [src url, attribute "width" "100%", attribute "height" "1080px", style "border" "0px"] []

viewItem : DofTab -> Item Msg
viewItem tab =
  Tab.item
    { id = tab.id
    , link = Tab.link [] [text tab.text]
    , pane = Tab.pane [] [genIframe tab.html]
    }

view : Model -> Document Msg
view model =
  { title = "被写界深度計算機"
  , body =
    [ CDN.stylesheet
    , Tab.config SetTab
      |> Tab.items (List.map viewItem tabs)
      |> Tab.view model.tab
    ]
  }

parseUrl : Url -> Tab.State
parseUrl url =
  let
    parser = Query.string "tab"
    id = Parser.parse parser url |> Maybe.withDefault "from-lens"
  in
    customInitialState id
