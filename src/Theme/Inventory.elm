module Theme.Inventory exposing (..)

import Html exposing (..)
import Html.Keyed
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Engine


view :
    List ( String, { a | name : String } )
    -> Html (Engine.Msg)
view items =
    let
        numItems =
            List.length items

        inventoryItem i ( item, attrs ) =
            let
                key =
                    (toString item) ++ (toString <| numItems - i)
            in
                ( key
                , li
                    [ class "Inventory__Item u-selectable"
                    , onClick <| Engine.interactMsg item
                    ]
                    [ text <| .name <| attrs ]
                )
    in
        div [ class "Inventory" ]
            [ h3 [] [ text "Inventory" ]
            , div [ class "Inventory__list" ]
                [ Html.Keyed.ol []
                    (List.indexedMap inventoryItem items)
                ]
            ]
