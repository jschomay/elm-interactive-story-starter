port module Main exposing (..)

import Engine exposing (..)
import Manifest exposing (..)
import Scenes exposing (..)
import Html exposing (..)
import Theme.TitlePage
import Theme.Layout


type alias Model =
    { engineModel : Engine.Model
    , route : Route
    , loaded : Bool
    }


type Route
    = TitlePage
    | GamePage


type Msg
    = EngineUpdate Engine.Msg
    | StartGame
    | Loaded


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init : ( Model, Cmd Msg )
init =
    ( { engineModel =
            Engine.init
                { items = items
                , locations = locations
                , characters = characters
                }
                scenes
                [ moveItemToInventory "Umbrella"
                , moveItem "VegatableGarden" "Garden"
                , addLocation "Home"
                , addLocation "Garden"
                , moveCharacter "Harry" "Garden"
                , moveItem "Pint" "Pub"
                , moveTo "Home"
                ]
      , route = TitlePage
      , loaded = False
      }
    , Cmd.none
    )


update :
    Msg
    -> Model
    -> ( Model, Cmd Msg )
update msg model =
    case msg of
        EngineUpdate engineMsg ->
            ( { model | engineModel = Engine.update engineMsg model.engineModel }
            , Cmd.none
            )

        StartGame ->
            ( { model | route = GamePage }
            , Cmd.none
            )

        Loaded ->
            ( { model | loaded = True }
            , Cmd.none
            )


port loaded : (Bool -> msg) -> Sub msg


subscriptions : Model -> Sub Msg
subscriptions model =
    loaded <| always Loaded


view :
    Model
    -> Html Msg
view model =
    case model.route of
        TitlePage ->
            Theme.TitlePage.view StartGame model.loaded

        GamePage ->
            Html.map EngineUpdate <| Theme.Layout.view model.engineModel
