module Theme.Locations exposing (..)

import Html exposing (..)
import Html.Keyed
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Story
import World exposing (..)


view :
    Story.World MyItem MyLocation MyCharacter
    -> List MyLocation
    -> MyLocation
    -> Html (Story.Msg MyItem MyLocation MyCharacter)
view world locations currentLocation =
    let
        classes location =
            classList
                [ ( "Locations__Location", True )
                , ( "Locations__Location--current", location == currentLocation )
                , ( "u-selectable", True )
                ]

        numLocations =
            List.length locations

        locationItem i location =
            let
                key =
                    (toString location) ++ (toString <| numLocations - i)
            in
                ( key
                , li
                    ([ classes location
                     , onClick <| Story.locationMsg location
                     ]
                    )
                    [ text <| .name <| world.locations location ]
                )
    in
        div [ class "Locations" ]
            [ h3 [] [ text "Known locations" ]
            , div [ class "Locations__list" ]
                [ Html.Keyed.ol []
                    (List.indexedMap locationItem locations)
                ]
            ]
