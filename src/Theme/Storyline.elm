module Theme.Storyline exposing (..)

import Html exposing (..)
import Html.Keyed
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Markdown
import Engine exposing (..)


view : List ( String, Maybe String, Maybe { name : String, description : String }, Maybe String ) -> Html Engine.Msg
view storyLine =
    let
        x =
            Debug.log "s" storyLine

        storyLi i ( scene, rule, attrs, storyText ) =
            let
                numLines =
                    List.length storyLine

                key =
                    name ++ (toString <| numLines - i)

                name =
                    (Maybe.withDefault { name = "error", description = "error" } attrs |> .name)

                description =
                    (Maybe.withDefault { name = "error", description = "error" } attrs |> .description)

                classes =
                    [ ( "Storyline__Item", True )
                    , ( "u-fade-in", i == 0 )
                    ]
            in
                ( key
                , li [ classList classes ] <|
                    [ h4 [ class "Storyline__Item__Action" ] <| [ text name ]
                    , Markdown.toHtml [ class "Storyline__Item__Narration markdown-body" ] (Maybe.withDefault description storyText)
                    ]
                  -- ++ if i == 0 then
                  --     []
                  --    else
                  --     [ span
                  --         [ class "Storyline__Item__Rollback"
                  --         , title "Reset story to this point"
                  --         , onClick <| Engine.rollbackMsg (numLines - i - 1)
                  --         ]
                  --         []
                  --     ]
                )
    in
        Html.Keyed.ol [ class "Storyline" ]
            (List.indexedMap storyLi storyLine)
