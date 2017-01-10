module Theme.Layout exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Theme.CurrentSummary exposing (..)
import Theme.Storyline exposing (..)
import Theme.Locations exposing (..)
import Theme.Inventory exposing (..)
import ClientTypes exposing (..)


view :
    { currentLocation : ( Id, Attributes )
    , itemsInCurrentLocation : List ( Id, Attributes )
    , charactersInCurrentLocation : List ( Id, Attributes )
    , locations : List ( Id, Attributes )
    , itemsInInventory : List ( Id, Attributes )
    , ending : Maybe String
    , storyLine : List StorySnippet
    }
    -> Html Msg
view displayState =
    div [ class <| "GamePage" ]
        [ div
            [ class <|
                "GamePage__background GamePage__background--"
                    ++ (Tuple.second displayState.currentLocation |> .cssSelector)
            ]
            []
        , div [ class "Layout" ]
            [ div [ class "Layout__Main" ] <|
                [ Theme.CurrentSummary.view
                    displayState.currentLocation
                    displayState.itemsInCurrentLocation
                    displayState.charactersInCurrentLocation
                , Theme.Storyline.view
                    displayState.storyLine
                    displayState.ending
                ]
            , div [ class "Layout__Sidebar" ]
                [ Theme.Locations.view
                    displayState.locations
                    (Tuple.first displayState.currentLocation)
                , Theme.Inventory.view
                    displayState.itemsInInventory
                ]
            ]
        ]
