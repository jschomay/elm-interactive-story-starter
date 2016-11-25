module Main exposing (..)

import Story exposing (..)
import World exposing (..)
import Scenes exposing (..)
import Html exposing (..)
import Html.App as Html
import Theme.TitlePage
import Theme.Layout


type alias Model =
    { engineModel : Story.Model MyItem MyLocation MyCharacter MyKnowledge
    , route : Route
    }


type Route
    = TitlePage
    | GamePage


type Msg
    = EngineUpdate (Story.Msg MyItem MyLocation MyCharacter)
    | StartGame


main : Program Never
main =
    Html.beginnerProgram
        { model = init
        , view = view
        , update = update
        }


init : Model
init =
    { engineModel = Story.init setup
    , route = TitlePage
    }


world : World MyItem MyLocation MyCharacter
world =
    Story.world items locations characters


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
    -> Model
update msg model =
    case msg of
        EngineUpdate engineMsg ->
            { model | engineModel = Story.update engineMsg model.engineModel }

        StartGame ->
            { model | route = GamePage }


view :
    Model
    -> Html Msg
view model =
    case model.route of
        TitlePage ->
            Theme.TitlePage.view StartGame

        GamePage ->
            Html.map EngineUpdate <| Theme.Layout.view world model.engineModel
