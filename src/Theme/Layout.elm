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

        ending =
            Engine.getTheEnd engineModel

        story =
            Engine.getStoryLine engineModel
                ++ ( ""
                   , Nothing
                   , Just
                        { name = "Begining"
                        , description = "Ahh, a brand new day.  I wonder what I will get up to.  There's no telling who I will meet, what I will find, where I will go..."
                        }
                   , Nothing
                   )
                :: []
    in
        div [ class <| "GamePage" ]
            [ div [ class <| "GamePage__background GamePage__background--" ++ (Tuple.first currentLocation) ] []
            , div [ class "Layout" ]
                [ div [ class "Layout__Main" ]
                    [ Theme.CurrentSummary.view currentLocation props characters
                    , Theme.Storyline.view story ending
                    ]
                , div [ class "Layout__Sidebar" ]
                    [ Theme.Locations.view locations
                        currentLocation
                    , Theme.Inventory.view inventory
                    ]
                ]
            ]
