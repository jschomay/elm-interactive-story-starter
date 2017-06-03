module Rules exposing (..)

import Engine exposing (..)
import Components exposing (..)
import Dict exposing (Dict)
import Narrative


{-| This specifies the initial story world model.  At a minimum, you need to set a starting location with the `moveTo` command.  You may also want to place various items and characters in different locations.  You can also specify a starting scene if required.
-}
startingState : List Engine.ChangeWorldCommand
startingState =
    [ moveTo "cottage"
    , moveItemToLocation "cape" "cottage"
    , moveItemToLocation "basket" "cottage"
    , moveCharacterToLocation "lrrh" "cottage"
    , moveCharacterToLocation "mother" "cottage"
    , moveCharacterToLocation "wolf" "woods"
    , moveCharacterToLocation "grandma" "grandmasHouse"
    ]


{-| A simple helper for making rules, since I want all of my rules to include RuleData and Narrative components.
-}
rule : String -> Engine.Rule -> List String -> Entity
rule id ruleData narrative =
    entity id
        |> addRuleData ruleData
        |> addNarrative narrative


{-| All of the rules that govern your story.  The first parameter to `rule` is an id for that rule.  It must be unique, but generally isn't used directly anywhere else (though it gets returned from `Engine.update`, so you could do some special behavior if a specific rule matches).  I like to write a short summary of what the rule is for as the id to help me easily identify them.
Also, order does not matter, but I like to organize the rules by the story objects they are triggered by.  This makes it easier to ensure I have set up the correct criteria so the right rule will match at the right time.
Note that the ids used in the rules must match the ids set in `Manifest.elm`.
-}
rules : Dict String Components
rules =
    Dict.fromList <|
        []
            ++ -- cottage
               [ rule "going back to the Cottage"
                    { interaction = with "cottage"
                    , conditions =
                        [ currentLocationIsNot "cottage"
                        ]
                    , changes =
                        []
                    }
                    Narrative.returningToCottage
               ]
            ++ -- grandmas house
               [ rule "ignoring the wolf"
                    { interaction = with "grandmasHouse"
                    , conditions =
                        [ currentLocationIs "woods"
                        , hasNotPreviouslyInteractedWith "wolf"
                        ]
                    , changes =
                        [ moveTo "grandmasHouse"
                        , moveCharacterToLocation "lrrh" "grandmasHouse"
                        ]
                    }
                    Narrative.ignoreWolf
               , rule "finding the wolf at Grandma's house"
                    { interaction = with "grandmasHouse"
                    , conditions =
                        [ currentLocationIs "woods"
                        , characterIsInLocation "wolf" "grandmasHouse"
                        ]
                    , changes =
                        [ moveTo "grandmasHouse"
                        , moveCharacterToLocation "lrrh" "grandmasHouse"
                        ]
                    }
                    Narrative.findWolfAtGrandmas
               ]
            ++ -- woods
               [ rule "entering the Woods"
                    { interaction = with "woods"
                    , conditions =
                        [ currentLocationIs "river"
                        , characterIsInLocation "wolf" "woods"
                        ]
                    , changes =
                        [ moveTo "woods"
                        , moveCharacterToLocation "lrrh" "woods"
                        ]
                    }
                    Narrative.enteringWoods
               ]
            ++ -- river
               [ rule "leaving cottage without cape"
                    { interaction = with "river"
                    , conditions =
                        [ currentLocationIs "cottage"
                        , itemIsNotInInventory "cape"
                        ]
                    , changes =
                        []
                    }
                    Narrative.leavingWithoutCape
               , rule "leaving cottage without basket"
                    { interaction = with "river"
                    , conditions =
                        [ currentLocationIs "cottage"
                        , itemIsNotInInventory "basket"
                        ]
                    , changes =
                        []
                    }
                    Narrative.leavingWithoutBasket
               , rule "leaving the Cottage"
                    { interaction = with "river"
                    , conditions =
                        [ currentLocationIs "cottage"
                        , itemIsInInventory "cape"
                        , itemIsInInventory "basket"
                        ]
                    , changes =
                        [ moveTo "river"
                        , moveCharacterToLocation "lrrh" "river"
                        ]
                    }
                    Narrative.leavingCottage
               , rule "going from Woods to River"
                    { interaction = with "river"
                    , conditions =
                        [ currentLocationIs "woods"
                        , itemIsInInventory "cape"
                        , itemIsInInventory "basket"
                        ]
                    , changes =
                        []
                    }
                    Narrative.returningToRiver
               ]
            ++ -- wolf
               [ rule "talking to the wolf in the Woods"
                    { interaction = with "wolf"
                    , conditions =
                        [ currentLocationIs "woods"
                        , characterIsInLocation "wolf" "woods"
                        ]
                    , changes =
                        [ moveCharacterToLocation "wolf" "grandmasHouse"
                        , moveCharacterOffScreen "grandma"
                        ]
                    }
                    Narrative.talkToWolf
               , rule "Little Red Riding Hood's demise"
                    { interaction = with "wolf"
                    , conditions =
                        [ currentLocationIs "grandmasHouse"
                        , characterIsInLocation "lrrh" "grandmasHouse"
                        , characterIsInLocation "wolf" "grandmasHouse"
                        ]
                    , changes =
                        []
                    }
                    Narrative.demise
               ]
            ++ -- mother
               [ rule "further talking to mother"
                    { interaction = with "mother"
                    , conditions =
                        []
                    , changes =
                        []
                    }
                    Narrative.talkToMother
               ]
            ++ -- grandma
               [ rule "sharing food with grandma"
                    { interaction = with "grandma"
                    , conditions =
                        [ characterIsInLocation "lrrh" "grandmasHouse"
                        , characterIsInLocation "grandma" "grandmasHouse"
                        , itemIsInInventory "basket"
                        ]
                    , changes =
                        [ endStory "The End"
                        ]
                    }
                    Narrative.sharingFoodWithGrandma
               ]
            ++ -- Little Red Riding Hood
               [ rule "excited to visit grandma"
                    { interaction = with "lrrh"
                    , conditions =
                        [ characterIsInLocation "lrrh" "cottage" ]
                    , changes =
                        []
                    }
                    Narrative.excitedToVisitGrandma
               , rule "dallying"
                    { interaction = with "lrrh"
                    , conditions =
                        [ characterIsInLocation "lrrh" "cottage"
                        , itemIsInInventory "basket"
                        , itemIsInInventory "cape"
                        ]
                    , changes =
                        []
                    }
                    Narrative.dallying
               , rule "crossing the river"
                    { interaction = with "lrrh"
                    , conditions =
                        [ characterIsInLocation "lrrh" "river" ]
                    , changes =
                        []
                    }
                    Narrative.crossingTheRiver
               , rule "in the woods"
                    { interaction = with "lrrh"
                    , conditions =
                        [ characterIsInLocation "lrrh" "woods" ]
                    , changes =
                        []
                    }
                    Narrative.inTheWoods
               , rule "surprised by the wolf"
                    { interaction = with "lrrh"
                    , conditions =
                        [ characterIsInLocation "lrrh" "woods"
                        , characterIsInLocation "wolf" "woods"
                        ]
                    , changes =
                        []
                    }
                    Narrative.surprisedByWolf
               , rule "realizing her mistake"
                    { interaction = with "lrrh"
                    , conditions =
                        [ characterIsInLocation "lrrh" "woods"
                        , characterIsInLocation "wolf" "grandmasHouse"
                        ]
                    , changes =
                        []
                    }
                    Narrative.realizingMistake
               , rule "happy to see Grandma"
                    { interaction = with "lrrh"
                    , conditions =
                        [ characterIsInLocation "lrrh" "grandmasHouse"
                        , characterIsInLocation "grandma" "grandmasHouse"
                        ]
                    , changes =
                        []
                    }
                    Narrative.happyToSeeGrandma
               , rule "confused by wolf in grandma's bed"
                    { interaction = with "lrrh"
                    , conditions =
                        [ characterIsInLocation "lrrh" "grandmasHouse"
                        , characterIsInLocation "wolf" "grandmasHouse"
                        ]
                    , changes =
                        []
                    }
                    Narrative.confusedByWolf
               ]
            ++ -- basket
               [ rule "taking basket"
                    { interaction = with "basket"
                    , conditions =
                        [ itemIsInLocation "basket" "cottage" ]
                    , changes =
                        [ moveItemToInventory "basket" ]
                    }
                    Narrative.takeBasket
               , rule "giving basket of food to grandma"
                    { interaction = with "basket"
                    , conditions =
                        [ characterIsInLocation "lrrh" "grandmasHouse"
                        , characterIsInLocation "grandma" "grandmasHouse"
                        , itemIsInInventory "basket"
                        ]
                    , changes =
                        [ endStory "The End"
                        ]
                    }
                    Narrative.sharingFoodWithGrandma
               , rule "forgetting about the baseket"
                    { interaction = with "basket"
                    , conditions =
                        [ characterIsInLocation "lrrh" "grandmasHouse"
                        , characterIsInLocation "wolf" "grandmasHouse"
                        ]
                    , changes =
                        []
                    }
                    Narrative.forgettingBasket
               ]
            ++ -- cape
               [ rule "taking cape"
                    { interaction = with "cape"
                    , conditions =
                        [ itemIsInLocation "cape" "cottage" ]
                    , changes =
                        [ moveItemToInventory "cape" ]
                    }
                    Narrative.takeCape
               , rule "shivering"
                    { interaction = with "cape"
                    , conditions =
                        [ characterIsInLocation "lrrh" "grandmasHouse"
                        , characterIsInLocation "wolf" "grandmasHouse"
                        ]
                    , changes =
                        []
                    }
                    Narrative.shivering
               ]
