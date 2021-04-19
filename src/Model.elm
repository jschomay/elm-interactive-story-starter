module Model exposing (initialModel, update)

import Dict exposing (Dict)
import Helpers exposing (..)
import NarrativeEngine.Core.Rules as Rules
import NarrativeEngine.Core.WorldModel as WorldModel
import NarrativeEngine.Debug
import NarrativeEngine.Syntax.NarrativeParser as NarrativeParser
import Types exposing (..)


initialModel : Flags -> ( Model, Cmd Msg )
initialModel flags =
    ( { worldModel = Dict.empty
      , rules = Dict.empty
      , started = False
      , story = ""
      , ruleCounts = Dict.empty
      , debug = NarrativeEngine.Debug.init
      , showDebug = flags.showDebug
      }
    , Cmd.none
    )



-- you can add messages to respond to (in Types) and handle them here
-- and you can handle InteractWith differently if you need


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        InteractWith trigger ->
            -- we need to check if any rule matched
            case Rules.findMatchingRule trigger model.rules model.worldModel of
                Just ( matchedRuleID, { changes, narrative } ) ->
                    ( { model
                        | worldModel = WorldModel.applyChanges changes trigger model.worldModel
                        , story =
                            narrative
                                |> NarrativeParser.parse (makeConfig trigger matchedRuleID model.ruleCounts model.worldModel)
                                |> String.join "\n\n"
                        , ruleCounts = Dict.update matchedRuleID (Maybe.map ((+) 1) >> Maybe.withDefault 1 >> Just) model.ruleCounts
                        , debug =
                            model.debug
                                |> NarrativeEngine.Debug.setLastMatchedRuleId matchedRuleID
                                |> NarrativeEngine.Debug.setLastInteractionId trigger
                      }
                    , Cmd.none
                    )

                Nothing ->
                    ( { model
                        | story = getDescription (makeConfig trigger trigger model.ruleCounts model.worldModel) trigger model.worldModel
                        , ruleCounts = Dict.update trigger (Maybe.map ((+) 1) >> Maybe.withDefault 1 >> Just) model.ruleCounts
                        , debug =
                            model.debug
                                |> NarrativeEngine.Debug.setLastMatchedRuleId trigger
                                |> NarrativeEngine.Debug.setLastInteractionId trigger
                      }
                    , Cmd.none
                    )

        UpdateDebugSearchText searchText ->
            ( { model | debug = NarrativeEngine.Debug.updateSearch searchText model.debug }, Cmd.none )

        AddEntities parsedEntities ->
            ( { model | worldModel = Dict.union parsedEntities model.worldModel }, Cmd.none )

        AddRules parsedRules ->
            { model | rules = Dict.union parsedRules model.rules }
                |> (\m ->
                        if m.started then
                            ( m, Cmd.none )

                        else
                            update (InteractWith "start") { m | started = True }
                   )
