module Theme.Storyline exposing (..)

import Html exposing (..)
import Html.Keyed
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Markdown
import Manifest exposing (..)
import Engine


view : List ( String, String ) -> Html (Engine.Msg MyItem MyLocation MyCharacter)
view storyLine =
    let
        storyLi i ( interactableName, storyText ) =
            let
                numLines =
                    List.length storyLine

                key =
                    interactableName ++ (toString <| numLines - i)

                classes =
                    [ ( "Storyline__Item", True )
                    , ( "u-fade-in", i == 0 )
                    ]
            in
                ( key
                , li [ classList classes ]
                    <| [ h4 [ class "Storyline__Item__Action" ] <| [ text interactableName ]
                       , Markdown.toHtml [ class "Storyline__Item__Narration markdown-body" ] storyText
                       ]
                    ++ if i == 0 then
                        []
                       else
                        [ span
                            [ class "Storyline__Item__Rollback"
                            , title "Reset story to this point"
                            , onClick <| Engine.rollbackMsg (numLines - i - 1)
                            ]
                            []
                        ]
                )
    in
        Html.Keyed.ol [ class "Storyline" ]
            (List.indexedMap storyLi storyLine)
