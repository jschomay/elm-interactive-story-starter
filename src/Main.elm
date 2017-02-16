port module Main exposing (..)

import Engine exposing (..)
import Manifest exposing (..)
import Rules exposing (rulesData)
import Html exposing (..)
import Theme.TitlePage
import Theme.Layout
import ClientTypes exposing (..)
import Components exposing (..)
import Dict exposing (Dict)
import List.Zipper as Zipper exposing (Zipper)


type alias Model =
    { engineModel : Engine.Model
    , route : Route
    , loaded : Bool
    , storyLine : List StorySnippet
    , content : Dict String (Maybe (Zipper String))
    }


main : Program Never Model ClientTypes.Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


getIds : List Entity -> List Id
getIds =
    List.map .id


findEntity : Id -> Entity
findEntity id =
    let
        interactables =
            items ++ locations ++ characters

        entity =
            List.head <| List.filter (.id >> (==) id) interactables
    in
        case entity of
            Just entity ->
                entity

            Nothing ->
                Debug.crash <| "Couldn't find entity from id: " ++ id


pluckRules : Engine.Rules
pluckRules =
    let
        foldFn :
            RuleData Engine.Rule
            -> ( Int, Dict String Engine.Rule )
            -> ( Int, Dict String Engine.Rule )
        foldFn { interaction, conditions, changes } ( id, rules ) =
            ( id + 1
            , Dict.insert ((++) "rule" <| toString <| id + 1)
                { interaction = interaction
                , conditions = conditions
                , changes = changes
                }
                rules
            )
    in
        Tuple.second <| List.foldl foldFn ( 1, Dict.empty ) rulesData


pluckContent : Dict String (Maybe (Zipper String))
pluckContent =
    let
        foldFn :
            RuleData Engine.Rule
            -> ( Int, Dict String (Maybe (Zipper String)) )
            -> ( Int, Dict String (Maybe (Zipper String)) )
        foldFn { narrative } ( id, narratives ) =
            ( id + 1
            , Dict.insert ((++) "rule" <| toString <| id + 1)
                (Zipper.fromList narrative)
                narratives
            )
    in
        Tuple.second <| List.foldl foldFn ( 1, Dict.empty ) rulesData


init : ( Model, Cmd ClientTypes.Msg )
init =
    ( { engineModel =
            Engine.init
                { manifest =
                    { items = getIds items
                    , locations = getIds locations
                    , characters = getIds characters
                    }
                , rules = (pluckRules)
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
              , narrative = "Ahh, a brand new day.  I wonder what I will get up to.  There's no telling who I will meet, what I will find, where I will go..."
              }
            ]
      , content = pluckContent
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

                narrative =
                    { interactableName = findEntity interactableId |> getDisplay |> .name
                    , interactableCssSelector = findEntity interactableId |> getStyle
                    , narrative =
                        getNarrative model.content maybeMatchedRuleId
                            |> Maybe.withDefault (findEntity interactableId |> getDisplay |> .description)
                    }

                updatedContent =
                    maybeMatchedRuleId
                        |> Maybe.map (\id -> Dict.update id updateContent model.content)
                        |> Maybe.withDefault model.content
            in
                ( { model
                    | engineModel = newEngineModel
                    , storyLine = narrative :: model.storyLine
                    , content = updatedContent
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


getNarrative : Dict String (Maybe (Zipper String)) -> Maybe String -> Maybe String
getNarrative content ruleId =
    ruleId
        |> Maybe.andThen (\id -> Dict.get id content)
        |> Maybe.andThen identity
        |> Maybe.map Zipper.current


updateContent : Maybe (Maybe (Zipper String)) -> Maybe (Maybe (Zipper String))
updateContent =
    let
        nextOrStay narration =
            Zipper.next narration
                |> Maybe.withDefault narration
    in
        (Maybe.map >> Maybe.map) nextOrStay


view :
    Model
    -> Html ClientTypes.Msg
view model =
    case model.route of
        TitlePage ->
            Theme.TitlePage.view StartGame model.loaded

        GamePage ->
            let
                displayState =
                    { currentLocation =
                        Engine.getCurrentLocation model.engineModel
                            |> findEntity
                    , itemsInCurrentLocation =
                        Engine.getItemsInCurrentLocation model.engineModel
                            |> List.map findEntity
                    , charactersInCurrentLocation =
                        Engine.getCharactersInCurrentLocation model.engineModel
                            |> List.map findEntity
                    , locations =
                        Engine.getLocations model.engineModel
                            |> List.map findEntity
                    , itemsInInventory =
                        Engine.getItemsInInventory model.engineModel
                            |> List.map findEntity
                    , ending =
                        Engine.getEnding model.engineModel
                    , storyLine =
                        model.storyLine
                    }
            in
                Theme.Layout.view displayState
