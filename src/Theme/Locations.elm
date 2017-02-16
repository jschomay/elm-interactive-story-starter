module Theme.Locations exposing (..)

import Html exposing (..)
import Html.Keyed
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import ClientTypes exposing (..)
import Components exposing (..)


view :
    List Entity
    -> Entity
    -> Html Msg
view locations currentLocation =
    let
        classes locationId =
            classList
                [ ( "Locations__Location", True )
                , ( "Locations__Location--current", locationId == currentLocation.id )
                , ( "u-selectable", True )
                ]

        numLocations =
            List.length locations

        locationItem i entity =
            let
                key =
                    (toString entity.id) ++ (toString <| numLocations - i)
            in
                ( key
                , li
                    ([ classes entity.id
                     , onClick <| Interact entity.id
                     ]
                    )
                    [ text <| .name <| getDisplay entity ]
                )
    in
        div [ class "Locations" ]
            [ h3 [] [ text "Known locations" ]
            , div [ class "Locations__list" ]
                [ Html.Keyed.ol []
                    (List.indexedMap locationItem locations)
                ]
            ]
