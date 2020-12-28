module Main exposing (..)

import Bootstrap.CDN as CDN
import Bootstrap.Grid as Grid
import Bootstrap.Tab as Tab exposing (Item, customInitialState, State)
import Browser exposing (Document)
import Browser.Navigation as Nav exposing (Key)
import Html exposing (Html, iframe, text)
import Html.Attributes exposing (attribute, src, style)
import Url exposing (Url)
import Url.Builder exposing (string, toQuery)
import Url.Parser as Parser exposing ((<?>), s)
import Url.Parser.Query as Query
import Maybe.Extra

main = Browser.application
  { init = init
  , update = update
  , view = view
  , subscriptions = (\_ -> Sub.none)
  , onUrlChange = UrlCahnge
  , onUrlRequest = UrlRequest
  }

type Msg = SetTab Tab.State | UrlCahnge Url | UrlRequest Browser.UrlRequest

type alias Model = { tab: Tab.State, url: Url, key: Key }

type alias DofTab = { id: String, text: String, html: String }

tabs : List DofTab
tabs =
  [ {id = "from-lens", text = "距離と被写界深度", html = "from-lens.html"}
  , {id = "f-overfocus", text = "F値と過焦点距離", html = "f-overfocus.html"}
  , {id = "bokeh", text = "ボケ量", html = "bokeh.html"}
  , {id = "bokeh-fvalue", text = "ボケとレンズスペック", html = "bokeh-need-fvalue.html"}
  ]

init : () -> Url -> Key -> (Model, Cmd msg)
init _ url key =
  ({ tab = parseUrl url, url = url, key = key }, Cmd.none)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    SetTab tab ->
      let
        url = model.url
        nextUrl = { url | query = Just (toQuery [string "tab" (Maybe.withDefault "from-lens" (stateId tab))]) }
      in
        ({ model | tab = tab }, Nav.pushUrl model.key (Url.toString nextUrl) )
    UrlCahnge url ->
      ({ model | tab = parseUrl url }, Cmd.none)
    UrlRequest req ->
      case req of
        Browser.Internal url ->
          (model, Nav.pushUrl model.key (Url.toString url))
        Browser.External url ->
          (model, Nav.load url)

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
    [ Grid.container [style "margin-top" "40px"]
      [CDN.stylesheet
      , Tab.config SetTab
        |> Tab.items (List.map viewItem tabs)
        |> Tab.view model.tab
      ]
    ]
  }

parseUrl : Url -> Tab.State
parseUrl url =
  let
    parser = s "" <?> Query.string "tab"
    id = Parser.parse parser url |> Maybe.Extra.join |> Maybe.withDefault "from-lens"
  in
    customInitialState id

stateId : Tab.State -> Maybe String
stateId (State {activeTab}) =
  Tab.getActiveItem
