module Theme.Locations exposing (..)

import Html exposing (..)
import Html.Keyed
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Engine


view :
    List ( String, { name : String, description : String } )
    -> String
    -> Html Engine.Msg
view locations currentLocation =
    let
        classes location =
            classList
                [ ( "Locations__Location", True )
                , ( "Locations__Location--current", location == currentLocation )
                , ( "u-selectable", True )
                ]

        numLocations =
            List.length locations

        locationItem i ( location, { name, description } ) =
            let
                key =
                    (toString location) ++ (toString <| numLocations - i)
            in
                ( key
                , li
                    ([ classes location
                     , onClick <| Engine.interactMsg location
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
