port module Main exposing (..)

import Engine exposing (..)
import Manifest
import Rules
import Html exposing (..)
import Html.Attributes exposing (..)
import Tuple
import Theme.Layout
import ClientTypes exposing (..)
import Narrative
import Components exposing (..)
import Dict exposing (Dict)
import List.Zipper as Zipper exposing (Zipper)


{- This is the kernel of the whole app.  It glues everything together and handles some logic such as choosing the correct narrative to display.
   You shouldn't need to change anything in this file, unless you want some kind of different behavior.
-}


type alias Model =
    { engineModel : Engine.Model
    , loaded : Bool
    , storyLine : List StorySnippet
    , narrativeContent : Dict String (Zipper String)
    , endingCountDown : Int
    }


init : ( Model, Cmd ClientTypes.Msg )
init =
    let
        engineModel =
            Engine.init
                { items = List.map Tuple.first Manifest.items
                , locations = List.map Tuple.first Manifest.locations
                , characters = List.map Tuple.first Manifest.characters
                }
                (Dict.map (curry getRuleData) Rules.rules)
                |> Engine.changeWorld Rules.startingState
    in
        ( { engineModel = engineModel
          , loaded = False
          , storyLine = [ Narrative.startingNarrative ]
          , narrativeContent = Dict.map (curry getNarrative) Rules.rules
          , endingCountDown = 0
          }
        , Cmd.none
        )


findEntity : String -> Entity
findEntity id =
    (Manifest.items ++ Manifest.locations ++ Manifest.characters)
        |> List.filter (Tuple.first >> (==) id)
        |> List.head
        |> Maybe.withDefault (entity id)


update :
    ClientTypes.Msg
    -> Model
    -> ( Model, Cmd ClientTypes.Msg )
update msg model =
    if Engine.getEnding model.engineModel /= Nothing then
        -- no-op if story has ended
        ( model, Cmd.none )
    else
        case msg of
            Interact interactableId ->
                let
                    ( newEngineModel, maybeMatchedRuleId ) =
                        Engine.update interactableId model.engineModel

                    {- If the engine found a matching rule, look up the narrative content component for that rule if possible.  The description from the display info component for the entity that was interacted with is used as a default. -}
                    narrativeForThisInteraction =
                        { interactableName = findEntity interactableId |> getDisplayInfo |> .name
                        , interactableCssSelector = findEntity interactableId |> getClassName
                        , narrative =
                            maybeMatchedRuleId
                                |> Maybe.andThen (\id -> Dict.get id model.narrativeContent)
                                |> Maybe.map Zipper.current
                                |> Maybe.withDefault (findEntity interactableId |> getDisplayInfo |> .description)
                        }

                    {- If a rule matched, attempt to move to the next associated narrative content for next time. -}
                    updateNarrativeContent : Maybe (Zipper String) -> Maybe (Zipper String)
                    updateNarrativeContent =
                        Maybe.map (\narrative -> Zipper.next narrative |> Maybe.withDefault narrative)

                    updatedContent =
                        maybeMatchedRuleId
                            |> Maybe.map (\id -> Dict.update id updateNarrativeContent model.narrativeContent)
                            |> Maybe.withDefault model.narrativeContent

                    {- This part about the `endingCountDown` and `checkEnd` is a hack to make the player interact with the wolf three times before ending the story, which currently is not possible in the rules matching system.  It also demonstrates how to mix state from the client's model to effect the story.
                       I have plans in the next release of the engine to include a "quality-based system" that would allow you to do logic like this as part of the normal rules.
                    -}
                    updatedEndingCountDown =
                        case maybeMatchedRuleId of
                            Just "Little Red Riding Hood's demise" ->
                                model.endingCountDown + 1

                            _ ->
                                model.endingCountDown

                    checkEnd =
                        if updatedEndingCountDown == 3 then
                            Engine.changeWorld [ endStory "The End" ]
                        else
                            identity
                in
                    ( { model
                        | engineModel = newEngineModel |> checkEnd
                        , storyLine = narrativeForThisInteraction :: model.storyLine
                        , narrativeContent = updatedContent
                        , endingCountDown = updatedEndingCountDown
                      }
                    , Cmd.none
                    )

            Loaded ->
                ( { model | loaded = True }
                , Cmd.none
                )


view :
    Model
    -> Html ClientTypes.Msg
view model =
    let
        currentLocation =
            Engine.getCurrentLocation model.engineModel |> findEntity

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
        if not model.loaded then
            div [ class "Loading" ] [ text "Loading..." ]
        else
            Theme.Layout.view displayState


port loaded : (Bool -> msg) -> Sub msg


subscriptions : Model -> Sub ClientTypes.Msg
subscriptions model =
    loaded <| always Loaded


main : Program Never Model ClientTypes.Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
