module Example exposing (main)

{-| This file shows a simple implementation of a sample Elm Narrative Engine game.
This is for version 5.0.0, see
<https://package.elm-lang.org/packages/jschomay/elm-narrative-engine/5.0.0/> for full
API documentation.
-}

import Browser
import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import NarrativeEngine.Core.Rules as Rules
import NarrativeEngine.Core.WorldModel as WorldModel
import NarrativeEngine.Debug
import NarrativeEngine.Syntax.EntityParser as EntityParser
import NarrativeEngine.Syntax.Helpers as SyntaxHelpers
import NarrativeEngine.Syntax.NarrativeParser as NarrativeParser
import NarrativeEngine.Syntax.RuleParser as RuleParser



-- First we define our world model


{-| Our story world is filled with entities. An entity is an ID with "tags,"
"stats," and "links" (which the narrative engine uses), plus any additional fields
you want to add for your own code to use, like a name or file path to an image for
example. This pattern is known as the "Entity Component System" design pattern.

In this case, we "extend" the engine's "narrative component" with a "named component"
(via Elm's extensible records). You could continue extending it with as many
components as you want.

Note that the narrative engine won't be aware of any of these fields.

-}
type alias ExtraFields =
    NamedComponent {}


{-| The "named component" which in this case adds the "name" and "description"
fields, which we will use in our code below.

Defining this as an extensible record, allows us to combine more components together
in `ExtraFields` if we wanted to.

-}
type alias NamedComponent a =
    { a
        | name : String
        , description : String
    }


{-| Our concrete entity which extends the narrative engine's component with our own
set of components.
-}
type alias MyEntity =
    WorldModel.NarrativeComponent ExtraFields


{-| Our concrete world model using our extended entities.
-}
type alias MyWorldModel =
    Dict WorldModel.ID MyEntity


{-| A simple helper that makes it easy to define entities using the entity syntax in
a visually organized way. The first string is the entity definition syntax. The next
two strings are the entity's name and description respectively, which get put into
extra fields record.

If you had more components with more fields, you could modify this helper to include
them.

-}
entity : String -> String -> String -> ( String, ExtraFields )
entity entityString name description =
    ( entityString, { name = name, description = description } )


{-| The list of all of the entities and their initial state in initial world
model. These will be parsed into a `MyWorldModel` later.

The `entity` helper is a nice visual way to build this up, but you could also import
this from another source, such as a spreadsheet.

Capitalizing entity IDs is just a convention, but it visually helps make entities
stand out. Also note that we are using characters/items/locations because it is
convenient for this example, but there is nothing requiring us to use those specific
tags. You can design your world model however you want.

Note that the world model is stateful and needs to be stored in the model.

-}
initialWorldModelSpec : List ( String, ExtraFields )
initialWorldModelSpec =
    [ -- locations
      entity "CAVE.location.dark"
        "Dark cavern"
        "Caves are dark and scary, and habitats for two things: goblins and bags of gold."
    , entity "CAVE_ENTRANCE.location"
        "Entrance to a cave"
        "This seems like a relatively safe place to be."

    -- characters
    , entity "PLAYER.fear=1.bagsOfGoldCollected=0.current_location=CAVE_ENTRANCE"
        "Yourself"
        "You are a (mostly) fearless explorer in search of gold."
    , entity "GOBLIN.character.sleeping.current_location=CAVE"
        "Sleepy goblin"
        "Big, green, ugly, and can't seem to keep his eyes open."

    -- items
    , entity "LIGHTER.item.illumination=2.fuel=10.current_location=PLAYER"
        "Pocket lighter"
        -- notice that this description uses the cycling narrative syntax, in this
        -- case to only show the first part once.
        "{You don't smoke, but it's useful to have a lighter on hand, though it's|Useful, but} not much of a light source."
    , entity "TORCH.item.illumination=0.current_location=CAVE_ENTRANCE"
        "Torch"
        -- notice that this description uses the conditional narrative syntax
        "This is the go-to illumination solution for adventurers.  It is currently {TORCH.illumination>0?burning bright|unlit}."
    , entity "BAG_OF_GOLD.item.current_location=CAVE"
        "Bag of gold"
        -- notice that this description uses the random cycling narrative syntax (it
        -- will cycle through each option in a random order each time you click it)
        "{?Ooooh, sparkly!|Gold, gold!|This is what makes it all worthwhile.}"
    ]



-- Time to define our rules


{-| Just like entities, rules follow the ECS pattern, so we can add other fields to
them if we want. In this case we won't have any extra fields, but we will link each
rule's ID to a separate Dict that holds all of the narrative. This is a slightly
different way of doing ECS that separates the "narrative component" data from the
rules, which may make it easier to import narrative from another source, like a
spreadsheet for example. As long as the IDs of the rules and the associated content
are the same, we can link them up as needed. (You could take the same approach for
looking up the entity descriptions instead of including them as an extra field in if
you prefer.)

You could also add extra fields to each rule, like a sound effect file for example,
and access it directly from the rule record, but in this case we do not.

-}
type alias MyRule =
    Rules.Rule {}


{-| Our concrete "rule book" type.
-}
type alias Rules =
    Dict String MyRule


{-| This is the type that can be parsed into a `MyRule`. Each rule consists of a rule
syntax string and a record of extra fields (no extra fields in this case). This way
we can write our rules in a simple string syntax and parse it into the `MyRule` type.
-}
type alias RulesSpec =
    Dict Rules.RuleID ( String, {} )


{-| A simple rule builder helper to make `RulesSpec`s in a nice way. Note these rules
don't have any extra fields, but if they did you could modify this function to
include them.
-}
rule_______________________ : String -> String -> RulesSpec -> RulesSpec
rule_______________________ k v dict =
    Dict.insert k ( v, {} ) dict


{-| All the rules that govern our story (you might think of it as our "rulebook").
These have no state, so they do not need to be stored in our model. These are
written in the rule syntax, and will be parsed into `MyRule`s later.

The `rule_______________________` helper is a nice visual way to write all of the
rules, but you don't have to do it this way if you don't want to. You also could
import this data from another source, such as a spreadsheet.

Each rule's key is used in `narrative_content` below to look up the associated narrative.

-}
rulesSpec : RulesSpec
rulesSpec =
    Dict.empty
        -- First we define some generic rules.  We have more specific rules below
        -- that will take precedence over these if they also match.
        --
        -- This one applies to interacting with any entity that has a "location" tag,
        -- which will "move" the player to that location.  It uses special matcher
        -- "$", which will get replaced with the ID of the actual entity the player
        -- interacted with.
        |> rule_______________________ "moving around"
            """
            ON: *.location
            DO: PLAYER.current_location=$
            """
        -- Here's one that adds any "item" to the player's inventory (if it isn't
        -- already there).  Again, "$" will be replaced with the ID of the entity
        -- interacted with.
        |> rule_______________________ "picking up items"
            """
            ON: *.item.!current_location=PLAYER
            DO: $.current_location=PLAYER
            """
        -- This rule is also generic, but more more specific than the "moving around"
        -- rule, so it will override that rule.  In this case it is a no-op, and has
        -- a different narrative (see the narrative content below).
        |> rule_______________________ "entering dark places"
            """
            ON: *.location.dark
            """
        -- This rule is still more specific than the one above, and moves the player
        -- and has a different narrative.
        |> rule_______________________ "entering dark places with a light source"
            """
            ON: *.location.dark
            IF: *.item.illumination>5.current_location=PLAYER
            DO: PLAYER.current_location=$
            """
        -- The following rules are all more specific because they are triggered by
        -- specific entity IDs.
        --
        -- This one has some specific conditions about entering the cave for the
        -- first time (via the "explored" tag) and requiring a sufficient light
        -- source.  It updates both the player and the cave.
        |> rule_______________________ "entering the cave the first time"
            """
            ON: CAVE.!explored
            IF: *.item.illumination>5.current_location=PLAYER
            DO: PLAYER.fear+2.current_location=CAVE
                CAVE.explored
            """
        -- This one lights the torch if it is in inventory and the lighter fuel has
        -- not run out.
        |> rule_______________________ "light the torch"
            """
            ON: LIGHTER.fuel>0.current_location=PLAYER
            IF: TORCH.illumination=0.current_location=PLAYER
            DO: TORCH.illumination=7
                LIGHTER.fuel-1
                PLAYER.fear-1
            """
        -- This one puts you back outside if you mess with the goblin while he is
        -- sleeping
        |> rule_______________________ "waking the goblin"
            """
            ON: GOBLIN.sleeping
            DO: PLAYER.current_location=CAVE_ENTRANCE.fear+5
            """
        -- This one lets you take the bag of gold and win
        |> rule_______________________ "getting the gold"
            """
            ON: BAG_OF_GOLD.current_location=CAVE
            DO: PLAYER.bagsOfGoldCollected+1
                BAG_OF_GOLD.current_location=PLAYER
            """


{-| A simple helper to build up a dictionary of narrative content in a visually
organized way.
-}
content__________________________________ : String -> String -> Dict String String -> Dict String String
content__________________________________ =
    Dict.insert


{-| A dictionary of narrative content keyed by the rule IDs with the text that should
display when that rule matches. As with rules and entities, you could import this
data from an external source, such as a spreadsheet
-}
narrative_content : Dict String String
narrative_content =
    Dict.empty
        |> content__________________________________ "entering the cave the first time"
            "You can see a short way into the cave, and bravely enter.  You hear an awful snoring sound..."
        |> content__________________________________ "light the torch"
            "You light the torch. Brilliant, fear no more!"
        |> content__________________________________ "waking the goblin"
            "There's an old saying, \"Let sleeping dogs lie.\"  That applies double when it comes to goblins.  Too late... the goblin wakes up and chases you out of the cave."
        |> content__________________________________ "getting the gold"
            "You nimbly sneak around the sleeping goblin and snatch the bag of gold!"
        |> content__________________________________ "moving around"
            "You go explore over there."
        |> content__________________________________ "picking up items"
            -- notice we use the custom function narrative syntax here
            "You grab the {$.name} to take with you."
        |> content__________________________________ "entering dark places"
            "You can't see anything at all in there.  Better find some kind of light before going in."
        |> content__________________________________ "entering dark places with a light source"
            "You can see well enough to enter this dark space."


{-| Our model holds any state needed for the game. In our case it has our world
model, the current story text, the debug info, and keeps track of how many times we
have called each rule (used for cycling narrative text).
-}
type alias Model =
    { worldModel : MyWorldModel
    , story : String
    , ruleCounts : Dict String Int
    , debug : NarrativeEngine.Debug.State
    }


{-| This gets called from `main` with the fully parsed initial world model passed in.
-}
initialModel : MyWorldModel -> Model
initialModel initialWorldModel =
    { worldModel = initialWorldModel
    , story = "You are a (mostly) brave adventurer, searching the lands for bags of gold.  You have climbed this mountain and arrived at the mouth of a cave."
    , ruleCounts = Dict.empty
    , debug = NarrativeEngine.Debug.init
    }



-- A couple of helpers to lookup the name and description info from an entity ID
-- (this is the "System" in ECS for the `NamedComponent`).
-- Note the description gets passed through the narrative parser (this has to happen
-- at call time since it depends on the state at that time).


getDescription : NarrativeParser.Config MyEntity -> WorldModel.ID -> MyWorldModel -> String
getDescription config entityID worldModel_ =
    Dict.get entityID worldModel_
        |> Maybe.map .description
        |> Maybe.withDefault ("ERROR can't find entity " ++ entityID)
        |> NarrativeParser.parse config
        -- The parser can break up a narrative into chunks (for pagination for
        -- example), but in our case we use the whole thing, so we just take the
        -- head.
        |> List.head
        |> Maybe.withDefault ("ERROR parsing narrative content for " ++ entityID)


getName : WorldModel.ID -> MyWorldModel -> String
getName entityID worldModel_ =
    Dict.get entityID worldModel_
        |> Maybe.map .name
        |> Maybe.withDefault ("ERROR can't find entity " ++ entityID)


{-| A helper to make the config required for `NarrativeParser.parse`.

Notice how we define a function for "name". You could make any kind of function
here. In this case we always return an `Ok`, but it is better to return an `Err
"reason..."` if the function fails, to display better parsing errors.

-}
makeConfig : WorldModel.ID -> Rules.RuleID -> Model -> NarrativeParser.Config MyEntity
makeConfig trigger matchedRule model =
    { cycleIndex = Dict.get matchedRule model.ruleCounts |> Maybe.withDefault 0
    , propKeywords = Dict.singleton "name" (\id -> Ok <| getName id model.worldModel)
    , worldModel = model.worldModel
    , trigger = trigger
    }


{-| We only have 2 messages - interacting with an entity, and updating the debug bar
when the player searches the world model. But you could have other messages as well
if desired, and handle them in `update`.
-}
type Msg
    = InteractWith WorldModel.ID
    | UpdateDebugSearchText String


{-| We update our game whenever the player clicks on an entity. We need to check if
any of our rules matched, and if so, we need to apply the changes, and set the new
story text. We also track how many times each rule was triggered (used in cycling
narrative syntax).

The fully parsed `Rules` get passed in from `main`.

-}
update : Rules -> Msg -> Model -> Model
update rules msg model =
    case msg of
        InteractWith trigger ->
            -- we need to check if any rule matched
            case Rules.findMatchingRule trigger rules model.worldModel of
                Just ( matchedRuleID, { changes } ) ->
                    { model
                        | worldModel = WorldModel.applyChanges changes trigger model.worldModel
                        , story =
                            -- get the story from narrative content (we also need to
                            -- parse it)
                            Dict.get matchedRuleID narrative_content
                                |> Maybe.withDefault ("ERROR finding narrative content for " ++ matchedRuleID)
                                |> NarrativeParser.parse (makeConfig trigger matchedRuleID model)
                                -- The parser can break up a narrative into chunks
                                -- (for pagination for example), but in our case we
                                -- use the whole thing, so we just take the head.
                                |> List.head
                                |> Maybe.withDefault ("ERROR parsing narrative content for " ++ matchedRuleID)
                        , ruleCounts = Dict.update matchedRuleID (Maybe.map ((+) 1) >> Maybe.withDefault 1 >> Just) model.ruleCounts
                        , debug =
                            model.debug
                                |> NarrativeEngine.Debug.setLastMatchedRuleId matchedRuleID
                                |> NarrativeEngine.Debug.setLastInteractionId trigger
                    }

                Nothing ->
                    -- no rule matched, so lets just show the description of the
                    -- entity that the player interacted with
                    { model
                        | story = getDescription (makeConfig trigger trigger model) trigger model.worldModel
                        , ruleCounts = Dict.update trigger (Maybe.map ((+) 1) >> Maybe.withDefault 1 >> Just) model.ruleCounts
                        , debug =
                            model.debug
                                |> NarrativeEngine.Debug.setLastMatchedRuleId trigger
                                |> NarrativeEngine.Debug.setLastInteractionId trigger
                    }

        UpdateDebugSearchText searchText ->
            { model | debug = NarrativeEngine.Debug.updateSearch searchText model.debug }


{-| A helper to make queries from a query syntax string. Make sure the syntax is
correct or this defaults to an empty list.
-}
query : String -> MyWorldModel -> List ( WorldModel.ID, MyEntity )
query q worldModel =
    RuleParser.parseMatcher q
        |> Result.map (\parsedMatcher -> WorldModel.query parsedMatcher worldModel)
        |> Result.withDefault []


{-| A helper to make assertions from a query syntax string. Make sure the syntax is
correct or this defaults to false.
-}
assert : String -> MyWorldModel -> Bool
assert q worldModel =
    not <| List.isEmpty <| query q worldModel


{-| You can build your view how ever you want, querying the world model as needed.
Here we just build a very simple example.
-}
view : Model -> Html Msg
view model =
    let
        -- we can get links and stats directly
        currentLocation =
            WorldModel.getLink "PLAYER" "current_location" model.worldModel
                |> Maybe.withDefault "ERROR getting current location"

        fearLevel =
            WorldModel.getStat "PLAYER" "fear" model.worldModel
                |> Maybe.map String.fromInt
                |> Maybe.withDefault "ERROR can't find PLAYER's fear stat"

        -- we can query the world model as needed
        inventory =
            query "*.item.current_location=PLAYER" model.worldModel

        locations =
            query "*.location" model.worldModel
                |> List.filter (\( locationID, _ ) -> locationID /= currentLocation)

        -- The next two use an advanced syntax to look up the player's current
        -- location
        items =
            query "*.item.current_location=(link PLAYER.current_location)" model.worldModel

        characters =
            query "*.character.current_location=(link PLAYER.current_location)" model.worldModel

        -- we can also assert against the world model
        isQuestComplete =
            assert "PLAYER.bagsOfGoldCollected>0" model.worldModel
    in
    div [ style "width" "70%", style "margin" "auto" ]
        [ NarrativeEngine.Debug.debugBar UpdateDebugSearchText model.worldModel model.debug
        , h1 [] [ text <| "You are currently located in the " ++ getName currentLocation model.worldModel ]
        , h2 [] [ text <| getDescription (makeConfig currentLocation currentLocation model) currentLocation model.worldModel ]
        , h3 [] [ text <| "Fear level: " ++ fearLevel ]
        , div [ style "display" "flex" ]
            [ div [ style "flex" "0 0 auto" ]
                [ h3 [] [ text "You have:" ]
                , ul [] <| List.map entityView inventory
                , h3 [] [ text "You see the following items:" ]
                , ul [] <| List.map entityView items
                , h3 [] [ text "You see the following characters:" ]
                , ul [] <| List.map entityView characters
                , h3 [] [ text "Places near by:" ]
                , ul [] <| List.map entityView locations
                ]
            , div [ style "flex" "1 1 auto", style "font-size" "2em", style "padding" "0 2em" ]
                [ em [] [ text model.story ]
                , p []
                    [ text <|
                        if isQuestComplete then
                            "Congratulations, you win!"

                        else
                            "Goal: get the bag of gold!"
                    ]
                ]
            ]
        ]


entityView : ( WorldModel.ID, MyEntity ) -> Html Msg
entityView ( id, { name } ) =
    li [ onClick <| InteractWith id, style "cursor" "pointer" ] [ text name ]


{-| This is the entry point for our game. Because we have to parse the entities,
rules, and narrative content, we do that right from the start to make sure they
don't have any errors. If they do, we show the errors, and if not, we can use the
parsed data directly.
-}
main : Program () Model Msg
main =
    let
        -- This is how we "merge" our extra fields into the entity record.
        addExtraEntityFields { name, description } { tags, stats, links } =
            { tags = tags
            , stats = stats
            , links = links
            , name = name
            , description = description
            }

        addExtraRuleFields extraFields rule =
            -- no extra fields, so this is just a pass-through
            rule

        -- Here we parse the 3 things that need parsing.  The initial world model
        -- gets passed into `initialModel`, the rules get passed `update` (since they
        -- don't have to be stored in the model), and the narrative content is
        -- ignored, as long as it all parses correctly.  If there are any errors, the
        -- view will show those instead of the main view.
        parsedData =
            Result.map3 (\parsedInitialWorldModel narrative parsedRules -> ( parsedInitialWorldModel, parsedRules ))
                (EntityParser.parseMany addExtraEntityFields initialWorldModelSpec)
                (NarrativeParser.parseMany narrative_content)
                (RuleParser.parseRules addExtraRuleFields rulesSpec)
    in
    Browser.sandbox
        { init =
            parsedData
                |> Result.map Tuple.first
                |> Result.withDefault Dict.empty
                |> initialModel
        , view =
            case parsedData of
                Ok _ ->
                    view

                Err errors ->
                    -- Just show the errors, model is ignored
                    \model -> SyntaxHelpers.parseErrorsView errors
        , update =
            parsedData
                |> Result.map Tuple.second
                |> Result.withDefault Dict.empty
                |> update
        }
