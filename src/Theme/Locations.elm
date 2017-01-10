module Theme.Locations exposing (..)

import Html exposing (..)
import Html.Keyed
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import ClientTypes exposing (..)


view :
    List ( String, Attributes )
    -> String
    -> Html Msg
view locations currentLocation =
    let
        classes locationId =
            classList
                [ ( "Locations__Location", True )
                , ( "Locations__Location--current", locationId == currentLocation )
                , ( "u-selectable", True )
                ]

        numLocations =
            List.length locations

        locationItem i ( locationId, { name, description } ) =
            let
                key =
                    (toString locationId) ++ (toString <| numLocations - i)
            in
                ( key
                , li
                    ([ classes locationId
                     , onClick <| Interact locationId
                     ]
                    )
                    [ text <| name ]
                )
    in
        div [ class "Locations" ]
            [ h3 [] [ text "Known locations" ]
            , div [ class "Locations__list" ]
                [ Html.Keyed.ol []
                    (List.indexedMap locationItem locations)
                ]
            ]
