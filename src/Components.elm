module Components exposing (..)

import Dict exposing (..)


type alias Entity =
    ( String, Components )


type alias Components =
    Dict String Component


type Component
    = DisplayInformation { name : String, description : String }
    | CSSStyle String
    | ConnectingLocations Exits


type alias Exits =
    List ( Direction, String )


type Direction
    = North
    | South
    | East
    | West


entity : String -> Entity
entity id =
    ( id, Dict.empty )


addComponent : String -> Component -> Entity -> Entity
addComponent componentId component ( id, components ) =
    ( id, Dict.insert componentId component components )



----


addDisplayInfo : String -> String -> Entity -> Entity
addDisplayInfo name description =
    addComponent "displayInfo" <| DisplayInformation { name = name, description = description }


addCSSStyle : String -> Entity -> Entity
addCSSStyle selector =
    addComponent "style" <| CSSStyle selector


addConnectingLocations : List ( Direction, String ) -> Entity -> Entity
addConnectingLocations exits =
    addComponent "connectedLocations" <| ConnectingLocations exits



----


getDisplayInfo : Entity -> { name : String, description : String }
getDisplayInfo ( id, components ) =
    let
        errorMsg =
            "Error: no Display component information found for enity id: " ++ id
    in
        Dict.get "displayInfo" components
            |> Maybe.andThen
                (\c ->
                    case c of
                        DisplayInformation d ->
                            Just d

                        _ ->
                            Nothing
                )
            |> Maybe.withDefault { name = errorMsg, description = errorMsg }


getCSSStyle : Entity -> String
getCSSStyle ( id, components ) =
    let
        errorMsg =
            "Error: no Style component information found for enity id: " ++ id
    in
        Dict.get "style" components
            |> Maybe.andThen
                (\c ->
                    case c of
                        CSSStyle s ->
                            Just s

                        _ ->
                            Nothing
                )
            |> Maybe.withDefault errorMsg


getExits : Entity -> Exits
getExits ( id, components ) =
    case Dict.get "connectedLocations" components of
        Just (ConnectingLocations exits) ->
            exits

        _ ->
            []
