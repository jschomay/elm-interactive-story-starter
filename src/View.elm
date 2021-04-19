module View exposing (view)

import Helpers exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Markdown
import NarrativeEngine.Core.WorldModel as WorldModel
import NarrativeEngine.Debug
import Types exposing (..)



-- you can set up what ever queries you need
-- and display them however you want


view : Model -> Html Msg
view model =
    let
        currentLocation =
            WorldModel.getLink "PLAYER" "current_location" model.worldModel

        inventory =
            query "*.item.!hidden.current_location=PLAYER" model.worldModel

        locations =
            query "*.location.!hidden" model.worldModel
                |> List.filter (\( locationID, _ ) -> Just locationID /= currentLocation)

        items =
            query "*.item.!hidden.current_location=(link PLAYER.current_location)" model.worldModel

        characters =
            query "*.character.!hidden.current_location=(link PLAYER.current_location)" model.worldModel

        section heading class entities =
            span [ Html.Attributes.class <| "section section--" ++ class ]
                [ b [] [ text heading ]
                , ul [] entities
                ]

        ifNotEmpty l v =
            if List.isEmpty l then
                text ""

            else
                v l
    in
    div [ Html.Attributes.class "container" ] <|
        [ if model.showDebug then
            NarrativeEngine.Debug.debugBar UpdateDebugSearchText model.worldModel model.debug

          else
            text ""
        , div [ Html.Attributes.class "game" ]
            [ div [ Html.Attributes.class "world" ]
                [ currentLocation
                    |> Maybe.map
                        (\l ->
                            section "Current location" "current_location" <| [ entityView ( l, { name = getName l model.worldModel } ) ]
                        )
                    |> Maybe.withDefault (text "")
                , ifNotEmpty locations (section "Other locations" "other_locations" << List.map entityView)
                , ifNotEmpty items (section "Nearby items" "nearby_items" << List.map entityView)
                , ifNotEmpty characters (section "Nearby characters" "nearby_characters" << List.map entityView)
                , ifNotEmpty inventory (section "Inventory" "inventory" << List.map entityView)
                ]
            , div [ Html.Attributes.class "narrative" ]
                [ Markdown.toHtml [] model.story ]
            ]
        ]


entityView : ( WorldModel.ID, { a | name : String } ) -> Html Msg
entityView ( id, { name } ) =
    li [ class "entity", onClick <| InteractWith id ] [ text name ]
