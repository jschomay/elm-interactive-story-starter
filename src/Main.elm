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
                [ moveItemToLocation "Umbrella" "Home"
                , moveItemToLocation "VegatableGarden" "Garden"
                , addLocation "Home"
                , addLocation "Garden"
                , moveCharacterToLocation "Harry" "Garden"
                , moveItemToLocation "Pint" "Pub"
                , moveTo "Home"
                , loadScene "learnOfMystery"
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
            let
                displayState =
                    { currentLocation =
                        Engine.getCurrentLocation model.engineModel
                    , itemsInCurrentLocation =
                        Engine.getItemsInCurrentLocation model.engineModel
                    , charactersInCurrentLocation =
                        Engine.getCharactersInCurrentLocation model.engineModel
                    , locations =
                        Engine.getLocations model.engineModel
                    , itemsInInventory =
                        Engine.getItemsInInventory model.engineModel
                    , ending =
                        Engine.getEnding model.engineModel
                    , storyLine =
                        Engine.getStoryLine model.engineModel
                            ++ ( ""
                               , Nothing
                               , Just
                                    { name = "Begining"
                                    , description = "Ahh, a brand new day.  I wonder what I will get up to.  There's no telling who I will meet, what I will find, where I will go..."
                                    }
                               , Nothing
                               )
                            :: []
                    }
            in
                Html.map EngineUpdate <| Theme.Layout.view displayState
