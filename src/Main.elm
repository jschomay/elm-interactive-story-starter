port module Preview exposing (main)

import Browser
import Dict exposing (Dict)
import Html exposing (..)
import Model exposing (initialModel, update)
import NarrativeEngine.Syntax.EntityParser as EntityParser
import NarrativeEngine.Syntax.Helpers as SyntaxHelpers
import NarrativeEngine.Syntax.NarrativeParser as NarrativeParser
import NarrativeEngine.Syntax.RuleParser as RuleParser
import Result
import Types exposing (..)
import View



{- this file bootstraps the model and view and deals with
   importing the story data from the editor
-}


type alias TopModel =
    Result ( SyntaxHelpers.ParseErrors, Model ) Model


type TopMsg
    = ChildMsg Msg
    | ParsedEntities (EntityParser.ParsedWorldModel ExtraEntityFields)
    | ParsedRules (RuleParser.ParsedRules ExtraRuleFields)



-- this is the shape of the data imported from the editor


type alias EntityData =
    { description : String, entity : String, name : String }


type alias RuleData =
    { rule : String, rule_id : String, narrative : String }


port addEntities : (List EntityData -> msg) -> Sub msg


port addRules : (List RuleData -> msg) -> Sub msg


subscriptions : TopModel -> Sub TopMsg
subscriptions _ =
    Sub.batch
        [ addEntities <| ParsedEntities << parseEntities
        , addRules <| ParsedRules << parseRules
        ]


update : TopMsg -> TopModel -> ( TopModel, Cmd TopMsg )
update msg model =
    let
        childUpdate childMsg =
            case model of
                Ok childModel ->
                    Model.update childMsg childModel
                        |> Tuple.mapBoth Ok (Cmd.map ChildMsg)

                Err ( e, childModel ) ->
                    Model.update childMsg childModel
                        |> Tuple.mapBoth (\updatedModel -> Err ( e, updatedModel )) (Cmd.map ChildMsg)

        setError e =
            case model of
                Ok childModel ->
                    ( Err ( e, childModel ), Cmd.none )

                Err ( _, childModel ) ->
                    ( Err ( e, childModel ), Cmd.none )
    in
    case msg of
        ChildMsg childMsg ->
            childUpdate childMsg

        ParsedEntities (Err e) ->
            setError e

        ParsedEntities (Ok entities) ->
            childUpdate (AddEntities entities)

        ParsedRules (Err e) ->
            setError e

        ParsedRules (Ok rules) ->
            childUpdate (AddRules rules)


parseEntities : List EntityData -> EntityParser.ParsedWorldModel ExtraEntityFields
parseEntities entities =
    let
        addExtraEntityFields { description, name } { tags, stats, links } =
            { tags = tags
            , stats = stats
            , links = links
            , name = name
            , description = description
            }

        parsedEntities =
            entities
                |> List.map (\{ entity, description, name } -> ( entity, { description = description, name = name } ))
                |> EntityParser.parseMany addExtraEntityFields

        parsedDescriptions =
            entities
                |> List.map (\{ entity, description } -> ( entity, description ))
                |> Dict.fromList
                |> NarrativeParser.parseMany
    in
    parsedDescriptions |> Result.andThen (always parsedEntities)


parseRules : List RuleData -> RuleParser.ParsedRules ExtraRuleFields
parseRules rules =
    let
        addExtraEntityFields { narrative } { changes, conditions, trigger } =
            { trigger = trigger
            , conditions = conditions
            , changes = changes
            , narrative = narrative
            }

        parsedRules =
            rules
                |> List.map (\{ rule_id, rule, narrative } -> ( rule_id, ( rule, { narrative = narrative } ) ))
                |> Dict.fromList
                |> RuleParser.parseRules addExtraEntityFields

        parsedNarratives =
            rules
                |> List.map (\{ rule_id, narrative } -> ( rule_id, narrative ))
                |> Dict.fromList
                |> NarrativeParser.parseMany
    in
    parsedNarratives |> Result.andThen (always parsedRules)


main : Program Flags TopModel TopMsg
main =
    Browser.element
        { init = Model.initialModel >> Tuple.mapBoth Ok (Cmd.map ChildMsg)
        , view =
            \topModel ->
                case topModel of
                    Err ( errors, _ ) ->
                        SyntaxHelpers.parseErrorsView errors

                    Ok m ->
                        Html.map ChildMsg (View.view m)
        , update = update
        , subscriptions = subscriptions
        }
