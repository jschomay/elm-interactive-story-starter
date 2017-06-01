port module Main exposing (..)

import Engine exposing (..)
import Manifest
import Rules exposing (rulesData)
import Html exposing (..)
import Tuple
import Theme.Layout
import ClientTypes exposing (..)
import Components exposing (..)
import Dict exposing (Dict)
import List.Zipper as Zipper exposing (Zipper)


type alias Model =
    { engineModel : Engine.Model
    , loaded : Bool
    , storyLine :
        List StorySnippet
        -- TODO store rules as entities with stateful narrative instead of content
    , content : Dict String (Maybe (Zipper String))
    }


init : ( Model, Cmd ClientTypes.Msg )
init =
    let
        startingState =
            [ moveTo "cottage"
            , addLocation "cottage"
            , addLocation "river"
            , addLocation "woods"
            , addLocation "grandmasHouse"
            , moveItemToLocation "cape" "cottage"
            , moveItemToLocation "basket" "cottage"
            , moveCharacterToLocation "lrrh" "cottage"
            , moveCharacterToLocation "mother" "cottage"
            , moveCharacterToLocation "wolf" "woods"
            , moveCharacterToLocation "grandma" "grandmasHouse"
            ]
    in
        ( { engineModel =
                Engine.init
                    { items = getIds Manifest.items
                    , locations = getIds Manifest.locations
                    , characters = getIds Manifest.characters
                    }
                    pluckRules
                    |> Engine.changeWorld startingState
          , loaded = False
          , storyLine =
                [ { interactableName = "Mother"
                  , interactableCssSelector = ""
                  , narrative = """
Once upon a time there was a young girl named Little Red Riding Hood, because she was so fond of her red cape that her grandma gave to her.

One day, her mother said to her, "Little Red Riding Hood, take this basket of food to your Grandma, who lives in the woods, because she is not feeling well.  And remember, don't talk to strangers on the way!"
"""
                  }
                ]
          , content = pluckContent
          }
        , Cmd.none
        )


main : Program Never Model ClientTypes.Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


getIds : List Entity -> List String
getIds =
    List.map Tuple.first



-- TODO turn into dict


entities : List Entity
entities =
    Manifest.items ++ Manifest.locations ++ Manifest.characters


findEntity : String -> Entity
findEntity id =
    let
        entity =
            List.head <| List.filter (Tuple.first >> (==) id) entities
    in
        case entity of
            Just entity ->
                entity

            Nothing ->
                Debug.crash <| "Couldn't find entity from id: " ++ id



--TODO make rules follow ECS pattern and use `getRule`


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



--TODO make rules follow ECS pattern and use `getNarrative`


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


update :
    ClientTypes.Msg
    -> Model
    -> ( Model, Cmd ClientTypes.Msg )
update msg model =
    if Engine.getEnding model.engineModel /= Nothing then
        ( model, Cmd.none )
    else
        case msg of
            Interact interactableId ->
                let
                    ( newEngineModel, maybeMatchedRuleId ) =
                        Engine.update interactableId model.engineModel

                    narrative =
                        { interactableName = findEntity interactableId |> getDisplayInfo |> .name
                        , interactableCssSelector = findEntity interactableId |> getCSSStyle
                        , narrative =
                            getNarrative model.content maybeMatchedRuleId
                                |> Maybe.withDefault (findEntity interactableId |> getDisplayInfo |> .description)
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
    let
        currentLocation =
            Engine.getCurrentLocation model.engineModel
                |> findEntity

        displayState =
            { currentLocation = currentLocation
            , itemsInCurrentLocation =
                Engine.getItemsInCurrentLocation model.engineModel
                    |> List.map findEntity
            , charactersInCurrentLocation =
                Engine.getCharactersInCurrentLocation model.engineModel
                    |> List.map findEntity
            , exits =
                getExits currentLocation
                    |> List.map
                        (\( direction, id ) ->
                            ( direction, findEntity id )
                        )
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
