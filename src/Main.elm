port module Main exposing (..)

import Engine exposing (..)
import Manifest exposing (..)
import Scenes exposing (..)
import Html exposing (..)
import Theme.TitlePage
import Theme.Layout
import ClientTypes exposing (..)
import Dict exposing (Dict)


type alias Model =
    { engineModel : Engine.Model
    , route : Route
    , loaded : Bool
    , storyLine : List StorySnippet
    }


main : Program Never Model ClientTypes.Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


stripAttributes : List ( Id, Attributes ) -> List Id
stripAttributes =
    List.map Tuple.first


stripNarration : List ( Id, List ( Id, Rule, Narration ) ) -> List ( Id, List ( Id, Rule ) )
stripNarration =
    List.map <|
        Tuple.mapSecond <|
            List.map <|
                \( id, rule, _ ) -> ( id, rule )


init : ( Model, Cmd ClientTypes.Msg )
init =
    ( { engineModel =
            Engine.init
                { manifest =
                    { items = stripAttributes items
                    , locations = stripAttributes locations
                    , characters = stripAttributes characters
                    }
                , scenes = (stripNarration scenes)
                , startingScene = "learnOfMystery"
                , startingLocation = "Home"
                , setup =
                    [ moveItemToLocation "Umbrella" "Home"
                    , moveItemToLocationFixed "VegatableGarden" "Garden"
                    , addLocation "Home"
                    , addLocation "Garden"
                    , moveCharacterToLocation "Harry" "Garden"
                    , moveItemToLocation "Pint" "Pub"
                    ]
                }
      , route = TitlePage
      , loaded = False
      , storyLine =
            [ { interactableName = "Begin"
              , interactableCssSelector = ""
              , narration = "Ahh, a brand new day.  I wonder what I will get up to.  There's no telling who I will meet, what I will find, where I will go..."
              }
            ]
      }
    , Cmd.none
    )


update :
    ClientTypes.Msg
    -> Model
    -> ( Model, Cmd ClientTypes.Msg )
update msg model =
    case msg of
        Interact interactableId ->
            let
                ( newEngineModel, maybeMatchedRuleId ) =
                    Engine.update interactableId model.engineModel

                narration =
                    { interactableName = getAttributes interactableId |> .name
                    , interactableCssSelector = getAttributes interactableId |> .cssSelector
                    , narration =
                        getNarration maybeMatchedRuleId
                            |> Maybe.withDefault (getAttributes interactableId |> .description)
                    }
            in
                ( { model
                    | engineModel = newEngineModel
                    , storyLine = narration :: model.storyLine
                  }
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


subscriptions : Model -> Sub ClientTypes.Msg
subscriptions model =
    loaded <| always Loaded


content : Dict String Narration
content =
    Dict.fromList <|
        List.concatMap
            (Tuple.second
                >> (List.map (\( key, _, narration ) -> ( key, narration )))
            )
            scenes


getNarration : Maybe String -> Maybe String
getNarration ruleId =
    ruleId
        |> Maybe.andThen (flip Dict.get content)
        |> Maybe.andThen List.head


getAttributes : Id -> Attributes
getAttributes id =
    let
        interactables =
            Dict.fromList (items ++ locations ++ characters)
    in
        case Dict.get id interactables of
            Nothing ->
                Debug.crash <| "Cannot find an interactable for id " ++ id

            Just attrs ->
                attrs


view :
    Model
    -> Html ClientTypes.Msg
view model =
    case model.route of
        TitlePage ->
            Theme.TitlePage.view StartGame model.loaded

        GamePage ->
            let
                idAndAttrs : Id -> ( Id, Attributes )
                idAndAttrs id =
                    ( id, getAttributes id )

                displayState =
                    { currentLocation =
                        Engine.getCurrentLocation model.engineModel
                            |> idAndAttrs
                    , itemsInCurrentLocation =
                        Engine.getItemsInCurrentLocation model.engineModel
                            |> List.map idAndAttrs
                    , charactersInCurrentLocation =
                        Engine.getCharactersInCurrentLocation model.engineModel
                            |> List.map idAndAttrs
                    , locations =
                        Engine.getLocations model.engineModel
                            |> List.map idAndAttrs
                    , itemsInInventory =
                        Engine.getItemsInInventory model.engineModel
                            |> List.map idAndAttrs
                    , ending =
                        Engine.getEnding model.engineModel
                    , storyLine =
                        model.storyLine
                    }
            in
                Theme.Layout.view displayState
