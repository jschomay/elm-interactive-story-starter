module Theme.Layout exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Theme.CurrentSummary exposing (..)
import Theme.Storyline exposing (..)
import Theme.Locations exposing (..)
import Theme.Inventory exposing (..)
import Types exposing (..)
import Engine


view :
    { currentLocation : Maybe ( String, Attributes )
    , itemsInCurrentLocation : List ( String, Attributes )
    , charactersInCurrentLocation : List ( String, Attributes )
    , locations : List ( String, Attributes )
    , itemsInInventory : List ( String, Attributes )
    , ending : Maybe String
    , storyLine : List ( String, Maybe String, Maybe Attributes, Maybe String )
    }
    -> Html Engine.Msg
view displayState =
    div [ class <| "GamePage" ]
        [ div
            [ class <|
                "GamePage__background GamePage__background--"
                    ++ (Tuple.first <| Maybe.withDefault ( "none", { name = "", description = "" } ) displayState.currentLocation)
            ]
            []
        , div [ class "Layout" ]
            [ div [ class "Layout__Main" ] <|
                (case displayState.currentLocation of
                    Nothing ->
                        []

                    Just currentLocation ->
                        [ Theme.CurrentSummary.view
                            currentLocation
                            displayState.itemsInCurrentLocation
                            displayState.charactersInCurrentLocation
                        ]
                )
                    ++ [ Theme.Storyline.view
                            displayState.storyLine
                            displayState.ending
                       ]
            , div [ class "Layout__Sidebar" ]
                [ Theme.Locations.view
                    displayState.locations
                    (Maybe.withDefault "none" <| Maybe.map Tuple.first displayState.currentLocation)
                , Theme.Inventory.view
                    displayState.itemsInInventory
                ]
            ]
        ]
