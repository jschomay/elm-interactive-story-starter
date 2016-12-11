port module Main exposing (..)

import Engine exposing (..)
import Manifest exposing (..)
import Scenes exposing (..)
import Html exposing (..)
import Html.App as Html
import Theme.TitlePage
import Theme.Layout


type alias Model =
    { engineModel : Engine.Model MyItem MyLocation MyCharacter MyKnowledge
    , route : Route
    , loaded : Bool
    }


type Route
    = TitlePage
    | GamePage


type Msg
    = EngineUpdate (Engine.Msg MyItem MyLocation MyCharacter)
    | StartGame
    | Loaded


main : Program Never
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init : ( Model, Cmd Msg )
init =
    ( { engineModel = Engine.init setup
      , route = TitlePage
      , loaded = False
      }
    , Cmd.none
    )


world : World MyItem MyLocation MyCharacter
world =
    Engine.world items locations characters


setup : StartingState MyItem MyLocation MyCharacter MyKnowledge
setup =
    { startingScene = learnOfMystery
    , startingLocation = Home
    , startingNarration = "Ahh, a brand new day.  I wonder what I will get up to.  There's no telling who I will meet, what I will find, where I will go..."
    , setupCommands =
        [ addInventory Umbrella
        , placeItem VegatableGarden Garden
        , addLocation Home
        , addLocation Garden
        , moveCharacter Harry Garden
        , placeItem Pint Pub
        ]
    }


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
            Html.map EngineUpdate <| Theme.Layout.view world model.engineModel
