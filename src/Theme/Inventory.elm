module Theme.Inventory exposing (..)

import Html exposing (..)
import Html.Keyed
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import ClientTypes exposing (..)


view :
    List ( String, Attributes )
    -> Html Msg
view items =
    let
        numItems =
            List.length items

        inventoryItem i ( itemId, attrs ) =
            let
                key =
                    (toString itemId) ++ (toString <| numItems - i)
            in
                ( key
                , li
                    [ class "Inventory__Item u-selectable"
                    , onClick <| Interact itemId
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
