module Theme.Layout exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Theme.CurrentSummary exposing (..)
import Theme.Storyline exposing (..)
import Theme.Locations exposing (..)
import Theme.Inventory exposing (..)
import Story
import World exposing (..)


view :
    Story.World MyItem MyLocation MyCharacter
    -> Story.Model MyItem MyLocation MyCharacter MyKnowledge
    -> Html (Story.Msg MyItem MyLocation MyCharacter)
view world engineModel =
    let
        currentLocation =
            Story.getCurrentLocation world engineModel

        props =
            Story.getNearByProps world engineModel

        characters =
            Story.getNearByCharacters world engineModel

        locations =
            Story.getLocations world engineModel

        inventory =
            Story.getInventory world engineModel

        story =
            Story.getStoryLine world engineModel
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
