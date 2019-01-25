module Components exposing (..)

import Engine
import Dict exposing (..)
import List.Zipper as Zipper exposing (Zipper)


{-| An entity is simply an id associated with some potential components and their data.
Each object in your story is an entity - this includes items, locations, and characters, but also rules too.
-}
type alias Entity =
    ( String, Components )


type alias Components =
    Dict String Component


{-| These are all of the available components.
You can add your own components and the data that goes with them as needed.  Be sure to implement adders and getters below as well.
See the functions below for more info on specific components.
-}
type Component
    = DisplayInformation { name : String, description : String }
    | ClassName String
    | ConnectingLocations Exits
    | Narrative (Zipper String)
    | RuleData Engine.Rule


type alias Exits =
    List ( Direction, String )


type Direction
    = North
    | South
    | East
    | West


{-| A helper to quickly make an entity which can be easily piped into the component adders below.
The id that you set is the id that you must use to reference this entity in your rules.
-}
entity : String -> Entity
entity id =
    ( id, Dict.empty )


addComponent : String -> Component -> Entity -> Entity
addComponent componentId component ( id, components ) =
    ( id, Dict.insert componentId component components )



-- Helpers to add the above components to an entity, which can be easily piped together


addDisplayInfo : String -> String -> Entity -> Entity
addDisplayInfo name description =
    addComponent "displayInfo" <| DisplayInformation { name = name, description = description }


{-| Add classes to your entities to do some custom styling, such as to change a background color or image based on the location, or to show an avatar in the story line when a character is talking.  You can write the styles in the `Theme/styles/story.css` file.
Note that the string that you specify will appear in different places in the theme, often in a BEM format, so you may need to inspect the DOM to find what you wish to style.
-}
addClassName : String -> Entity -> Entity
addClassName className =
    addComponent "className" <| ClassName className


{-| This allows you to specify which locations are adjacent to the current location, and in what direction.  If you use this component, the view will show adjacent locations regardless of what locations have been added via the `addLocation` change world command from the Engine.
You can change the Directions as needed.
-}
addConnectingLocations : List ( Direction, String ) -> Entity -> Entity
addConnectingLocations exits =
    addComponent "connectedLocations" <| ConnectingLocations exits


{-| The Narrative component is intended only for rule entities.
The narrative that you add to a rule will be shown when that rule matches.  If you give a list of strings, each time the rule matches, it will show the next narrative in the list, which is nice for adding variety and texture to your story.
-}
addNarrative : List String -> Entity -> Entity
addNarrative narrative =
    addComponent "narrative" <| Narrative <| Zipper.withDefault "" <| Zipper.fromList narrative


{-| The RuleData component is intended only for rule entities, and is the only component that is used directly by the Engine, while all other components are used by the client code.
-}
addRuleData : Engine.Rule -> Entity -> Entity
addRuleData ruleData =
    addComponent "ruleData" <| RuleData ruleData



-- Helpers to get the component data out of an entity
-- Will return a sensible default if the entity does not have the requested component


getDisplayInfo : Entity -> { name : String, description : String }
getDisplayInfo ( id, components ) =
    case Dict.get "displayInfo" components of
        Just (DisplayInformation display) ->
            display

        _ ->
            { name = id, description = id }


getClassName : Entity -> String
getClassName ( id, components ) =
    case Dict.get "className" components of
        Just (ClassName className) ->
            className

        _ ->
            ""


getExits : Entity -> Exits
getExits ( id, components ) =
    case Dict.get "connectedLocations" components of
        Just (ConnectingLocations exits) ->
            exits

        _ ->
            []


getNarrative : Entity -> Zipper String
getNarrative ( id, components ) =
    case Dict.get "narrative" components of
        Just (Narrative narrative) ->
            narrative

        _ ->
            Zipper.singleton id


getRuleData : Entity -> Engine.Rule
getRuleData ( id, components ) =
    case Dict.get "ruleData" components of
        Just (RuleData rule) ->
            rule

        _ ->
            { interaction = Engine.with ""
            , conditions = []
            , changes = []
            }
            
getDirectionName : Direction -> String
getDirectionName direction =
    case direction of
        North -> "North"
        South -> "South"
        East  -> "East"
        West  -> "West"