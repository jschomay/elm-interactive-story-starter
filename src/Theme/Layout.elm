module Theme.Layout exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Theme.CurrentSummary exposing (..)
import Theme.Storyline exposing (..)
import Theme.Locations exposing (..)
import Theme.Inventory exposing (..)
import ClientTypes exposing (..)
import Components exposing (..)


view :
    { currentLocation : Entity
    , itemsInCurrentLocation : List Entity
    , charactersInCurrentLocation : List Entity
    , exits : List ( Direction, Entity )
    , itemsInInventory : List Entity
    , ending : Maybe String
    , storyLine : List StorySnippet
    }
    -> Html Msg
view displayState =
    div [ class <| "GamePage GamePage--" ++ Components.getClassName displayState.currentLocation ]
        [ div
            -- this is useful if you want to add a full-screen background image via the ClassName component
            [ class <| "GamePage__background GamePage__background--" ++ Components.getClassName displayState.currentLocation ]
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
                    displayState.exits
                    displayState.currentLocation
                , Theme.Inventory.view
                    displayState.itemsInInventory
                ]
            ]
        ]
