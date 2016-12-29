module Theme.Layout exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Theme.CurrentSummary exposing (..)
import Theme.Storyline exposing (..)
import Theme.Locations exposing (..)
import Theme.Inventory exposing (..)
import Engine


view :
    Engine.Model
    -> Html Engine.Msg
view engineModel =
    let
        currentLocation =
            Engine.getCurrentLocation engineModel
                |> Maybe.withDefault ( "error", { description = "error", name = "error" } )

        props =
            Engine.getItemsInLocation engineModel

        characters =
            Engine.getCharactersInLocation engineModel

        locations =
            Engine.getLocations engineModel

        inventory =
            Engine.getItemsInInventory engineModel

        story =
            Engine.getStoryLine engineModel
    in
        div [ class <| "GamePage" ]
            [ div [ class <| "GamePage__background GamePage__background--" ++ (Tuple.first currentLocation) ] []
            , div [ class "Layout" ]
                [ div [ class "Layout__Main" ]
                    [ Theme.CurrentSummary.view currentLocation props characters
                    , Theme.Storyline.view story
                    ]
                , div [ class "Layout__Sidebar" ]
                    [ Theme.Locations.view locations
                        currentLocation
                    , Theme.Inventory.view inventory
                    ]
                ]
            ]
