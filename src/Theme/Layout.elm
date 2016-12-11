module Theme.Layout exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Theme.CurrentSummary exposing (..)
import Theme.Storyline exposing (..)
import Theme.Locations exposing (..)
import Theme.Inventory exposing (..)
import Engine
import Manifest exposing (..)


view :
    Engine.World MyItem MyLocation MyCharacter
    -> Engine.Model MyItem MyLocation MyCharacter MyKnowledge
    -> Html (Engine.Msg MyItem MyLocation MyCharacter)
view world engineModel =
    let
        currentLocation =
            Engine.getCurrentLocation world engineModel

        props =
            Engine.getNearByProps world engineModel

        characters =
            Engine.getNearByCharacters world engineModel

        locations =
            Engine.getLocations world engineModel

        inventory =
            Engine.getInventory world engineModel

        story =
            Engine.getStoryLine world engineModel
    in
        div [ class <| "GamePage" ]
            [ div [ class <| "GamePage__background GamePage__background--" ++ (.name <| world.locations currentLocation) ] []
            , div [ class "Layout" ]
                [ div [ class "Layout__Main" ]
                    [ Theme.CurrentSummary.view world
                        currentLocation
                        props
                        characters
                    , Theme.Storyline.view story
                    ]
                , div [ class "Layout__Sidebar" ]
                    [ Theme.Locations.view world
                        locations
                        currentLocation
                    , Theme.Inventory.view world
                        inventory
                    ]
                ]
            ]
