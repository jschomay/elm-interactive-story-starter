module Components exposing (..)

import ClientTypes exposing (..)
import Dict


getDisplay : Entity -> { name : String, description : String }
getDisplay entity =
    let
        errorMsg =
            "Error: no Display component information found for enity id: " ++ entity.id
    in
        Dict.get "display" entity.components
            |> Maybe.andThen
                (\c ->
                    case c of
                        Display d ->
                            Just d

                        _ ->
                            Nothing
                )
            |> Maybe.withDefault { name = errorMsg, description = errorMsg }


getStyle : Entity -> String
getStyle entity =
    let
        errorMsg =
            "Error: no Style component information found for enity id: " ++ entity.id
    in
        Dict.get "style" entity.components
            |> Maybe.andThen
                (\c ->
                    case c of
                        Style s ->
                            Just s

                        _ ->
                            Nothing
                )
            |> Maybe.withDefault errorMsg
