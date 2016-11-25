module Theme.CurrentSummary exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Story
import World exposing (..)


view :
    Story.World MyItem MyLocation MyCharacter
    -> MyLocation
    -> List MyItem
    -> List MyCharacter
    -> Html (Story.Msg MyItem MyLocation MyCharacter)
view world currentLocation props characters =
    let
        isEmpty =
            List.isEmpty characters && List.isEmpty props

        interactableView toName msg interactable =
            span
                [ class "CurrentSummary__StoryElement u-selectable"
                , onClick <| msg interactable
                ]
                [ text <| toName interactable ]

        format list =
            let
                interactables =
                    if List.length list > 2 then
                        (List.take (List.length list - 1) list
                            |> List.intersperse (text ", ")
                        )
                            ++ (text " and ")
                            :: (List.drop (List.length list - 1) list)
                    else
                        List.intersperse (text " and ") list
            in
                interactables ++ [ text "." ]

        charactersList =
            if not <| List.isEmpty characters then
                characters
                    |> List.map (interactableView (world.characters >> .name) Story.characterMsg)
                    |> format
                    |> (::) (text "Characters here: ")
                    |> p []
            else
                span [] []

        propsList =
            if not <| List.isEmpty props then
                props
                    |> List.map (interactableView (world.items >> .name) Story.itemMsg)
                    |> format
                    |> (::) (text "Items here: ")
                    |> p []
            else
                span [] []
    in
        div [ class "CurrentSummary", style [] ]
            <| [ h1 [ class "Current-location" ]
                    [ text <| .name <| world.locations currentLocation ]
               ]
            ++ if isEmpty then
                [ text "Nothing here." ]
               else
                [ charactersList, propsList ]
