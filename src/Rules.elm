module Rules exposing (rulesData)

import Engine exposing (..)
import ClientTypes exposing (..)


rulesData : List (RuleData Engine.Rule)
rulesData =
    []
        -- learnOfMystery
        ++
            { summary = "get note from harry"
            , interaction = withCharacter "Harry"
            , conditions =
                [ currentLocationIs "Garden"
                , currentSceneIs "learnOfMystery"
                ]
            , changes =
                [ moveCharacterToLocation "Harry" "Marsh"
                , moveItemToInventory "NoteFromHarry"
                ]
            , narrative = [ harryGivesNote ]
            }
        :: { summary = "read harry's note"
           , interaction = withItem "NoteFromHarry"
           , conditions =
                [ currentSceneIs "learnOfMystery"
                ]
           , changes = [ addLocation "Marsh" ]
           , narrative = noteFromHarry
           }
        :: { summary = "go to marsh"
           , interaction = withLocation "Marsh"
           , conditions =
                [ itemIsInInventory "NoteFromHarry"
                , currentSceneIs "learnOfMystery"
                ]
           , changes =
                [ moveTo "Marsh"
                , moveItemOffScreen "NoteFromHarry"
                ]
           , narrative = []
           }
        :: { summary = "harry asks for help"
           , interaction = withCharacter "Harry"
           , conditions =
                [ currentLocationIs "Marsh"
                , currentSceneIs "learnOfMystery"
                ]
           , changes = [ loadScene "searchForMarbles" ]
           , narrative = [ harryAsksForHelp ]
           }
        -- searchForMarbles
        ::
            { summary = "more about marbles"
            , interaction = withCharacter "Harry"
            , conditions =
                [ currentLocationIs "Marsh"
                , itemIsNotInInventory "RedMarble"
                , itemIsNotInInventory "GreenMarble"
                , currentSceneIs "searchForMarbles"
                ]
            , changes = []
            , narrative = talkWithHarry
            }
        :: { summary = "show both marbles"
           , interaction = withCharacter "Harry"
           , conditions =
                [ currentLocationIs "Marsh"
                , itemIsInInventory "RedMarble"
                , itemIsInInventory "GreenMarble"
                , currentSceneIs "searchForMarbles"
                ]
           , changes =
                [ addLocation "Pub"
                , loadScene "goToPub"
                , moveItemOffScreen "GreenMarble"
                , moveItemOffScreen "RedMarble"
                ]
           , narrative = [ showHarryBothMarbles ]
           }
        :: { summary = "show red marble"
           , interaction = withCharacter "Harry"
           , conditions =
                [ currentLocationIs "Marsh"
                , itemIsInInventory "RedMarble"
                , currentSceneIs "searchForMarbles"
                ]
           , changes = [ loadScene "bringMarbleHome" ]
           , narrative = [ showHarryOneMarble ]
           }
        :: { summary = "show green marble"
           , interaction = withCharacter "Harry"
           , conditions =
                [ currentLocationIs "Marsh"
                , itemIsInInventory "GreenMarble"
                , currentSceneIs "searchForMarbles"
                ]
           , changes = [ loadScene "bringMarbleHome" ]
           , narrative = [ showHarryOneMarble ]
           }
        :: { summary = "starts raining"
           , interaction = withLocation "Marsh"
           , conditions =
                [ itemIsNotInLocation "Rain" "Marsh"
                , currentSceneIs "searchForMarbles"
                ]
           , changes =
                [ moveTo "Marsh"
                , moveItemToLocationFixed "Rain" "Marsh"
                ]
           , narrative = [ "It's starting to rain!" ]
           }
        :: { summary = "in rain with umbrella"
           , interaction = withLocation "Marsh"
           , conditions =
                [ itemIsInLocation "Rain" "Marsh"
                , itemIsInInventory "Umbrella"
                , currentSceneIs "searchForMarbles"
                ]
           , changes = [ moveTo "Marsh" ]
           , narrative = [ "Still raining.  Good thing I brought my brolly!" ]
           }
        :: { summary = "in rain without umbrella"
           , interaction = withLocation "Marsh"
           , conditions =
                [ itemIsInLocation "Rain" "Marsh"
                , itemIsNotInInventory "Umbrella"
                , currentSceneIs "searchForMarbles"
                ]
           , changes = [ moveTo "Marsh" ]
           , narrative = [ "I'm getting all wet!  How miserable.  Foolish of me to leave my brolly at home on a day like this!" ]
           }
        :: { summary = "reveal red marble"
           , interaction = withItem "Umbrella"
           , conditions =
                [ currentLocationIs "Marsh"
                , itemIsInLocation "Rain" "Marsh"
                , itemIsNotInInventory "RedMarble"
                , itemIsNotInLocation "SomethingRedAndShiny" "Marsh"
                , currentSceneIs "searchForMarbles"
                ]
           , changes = [ moveItemToLocation "SomethingRedAndShiny" "Marsh" ]
           , narrative = [ revealRedMarble ]
           }
        :: { summary = "find red marble"
           , interaction = withItem "SomethingRedAndShiny"
           , conditions =
                [ currentSceneIs "searchForMarbles"
                ]
           , changes =
                [ moveItemToInventory "RedMarble"
                , moveItemOffScreen "SomethingRedAndShiny"
                ]
           , narrative = [ "Hey, it's Harry's red marble!" ]
           }
        :: { summary = "red marble description"
           , interaction = withItem "RedMarble"
           , conditions =
                [ currentSceneIs "searchForMarbles"
                ]
           , changes = []
           , narrative = redMarble
           }
        :: { summary = "reveal green marble"
           , interaction = withItem "VegatableGarden"
           , conditions =
                [ itemIsNotInInventory "GreenMarble"
                , currentSceneIs "searchForMarbles"
                ]
           , changes = [ moveItemToLocation "SomethingGreenAndShiny" "Garden" ]
           , narrative = [ revealGreenMarble ]
           }
        :: { summary = "find green marble"
           , interaction = withItem "SomethingGreenAndShiny"
           , conditions =
                [ currentSceneIs "searchForMarbles"
                ]
           , changes =
                [ moveItemToInventory "GreenMarble"
                , moveItemOffScreen "SomethingGreenAndShiny"
                ]
           , narrative = [ "It's Harry's green marble!  How did that get there?" ]
           }
        :: { summary = "green marble description"
           , interaction = withItem "GreenMarble"
           , conditions =
                [ currentSceneIs "searchForMarbles"
                ]
           , changes = []
           , narrative = greenMarble
           }
        -- bringMarbleHome
        ::
            { summary = "bring red marble home"
            , interaction = withLocation "Home"
            , conditions =
                [ itemIsInInventory "RedMarble"
                , currentSceneIs "bringMarbleHome"
                ]
            , changes =
                [ moveTo "Home"
                , moveItemToLocation "RedMarble" "Home"
                , endStory "Ending 1 of 2: All's well that ends well, though a bit lonely."
                ]
            , narrative =
                [ "Well, that's quite enough adventuring for today.  I think I'll just put on some tea and wait for Harry to come around." ]
            }
        :: { summary = "bring green marble home"
           , interaction = withLocation "Home"
           , conditions =
                [ itemIsInInventory "GreenMarble"
                , currentSceneIs "bringMarbleHome"
                ]
           , changes =
                [ moveTo "Home"
                , moveItemToLocation "GreenMarble" "Home"
                , endStory "Ending 1 of 2: All's well that ends well, though a bit lonely."
                ]
           , narrative =
                [ "Well, that's quite enough adventuring for today.  I think I'll just put on some tea and wait for Harry to come around." ]
           }
        :: { summary = "lonely ending"
           , interaction = withAnything
           , conditions =
                [ currentSceneIs "bringMarbleHome"
                , currentLocationIs "Home"
                ]
           , changes = []
           , narrative =
                [ "Ah yes, lovely tea."
                , "Harry hasn't show up yet.  I wonder if he'll find his other marble."
                , "Might do another cup of tea."
                , "I don't think Harry's coming."
                , "I really do think the adventure is over now."
                , "The end."
                , "Or is it?"
                , "Yes, it really is.  The end."
                , "The end."
                ]
           }
        :: { summary = "focus on getting home"
           , interaction = withAnyItem
           , conditions =
                [ currentLocationIsNot "Home"
                , currentSceneIs "bringMarbleHome"
                ]
           , changes = []
           , narrative = [ "Harry wants me to bring his marble safely home.  I wouldn't mind a nice cup of tea besides." ]
           }
        :: { summary = "go where harry said"
           , interaction = withAnyLocation
           , conditions =
                [ currentLocationIsNot "Home"
                , currentSceneIs "bringMarbleHome"
                ]
           , changes = []
           , narrative = [ "I really think I should just do as Harry asked." ]
           }
        :: { summary = "no more to say"
           , interaction = withCharacter "Harry"
           , conditions =
                [ currentSceneIs "bringMarbleHome"
                ]
           , changes = []
           , narrative = [ "\"Go on now Bartholomew, keep that safe for me.\"" ]
           }
        -- goToPub
        ::
            { summary = "go to pub with Harry"
            , interaction = withLocation "Pub"
            , conditions =
                [ currentLocationIsNot "Pub"
                , currentSceneIs "goToPub"
                ]
            , changes =
                [ moveTo "Pub"
                , moveCharacterToLocation "Harry" "Pub"
                , endStory "Ending 2 of 2: No better way to end an adventure, than with a pint in the pub with a good friend!"
                ]
            , narrative = []
            }
        :: { summary = "cheers"
           , interaction = withItem "Pint"
           , conditions =
                [ currentSceneIs "goToPub"
                ]
           , changes = []
           , narrative = [ "Cheers Harry!  To the next adventure." ]
           }
        :: { summary =
                "z focus on going to pub"
                -- TODO this is needed until rules are weighted (or it matches instead of "go to pub with Harry")
           , interaction = withAnything
           , conditions =
                [ currentLocationIsNot "Pub"
                , currentSceneIs "goToPub"
                ]
           , changes = []
           , narrative = [ "Right now I just really want a pint!" ]
           }
        :: { summary = "good ending"
           , interaction = withAnything
           , conditions =
                [ currentLocationIs "Pub"
                , currentSceneIs "goToPub"
                ]
           , changes = []
           , narrative =
                [ "Another daring adventure, finished."
                , "There's nothing more to do, not until the next adventure."
                , "The end."
                ]
           }
        :: []


harryGivesNote : String
harryGivesNote =
    """
Ah, my dear colleague Harry.

"Alright Harry?  What are you getting up to today?"

What's this?  He's given me a note.  And now he's run off.

How peculiar.
"""


noteFromHarry : List String
noteFromHarry =
    [ "It says, \"*Meet me in the marsh.*\""
    , "I wonder what Harry could possibly be doing in the marsh."
    , "He's expecting me.  I better go find him."
    ]


harryAsksForHelp : String
harryAsksForHelp =
    """"Bartholomew, my friend!  Thanks for coming."

"What is it Harry?  Why have you brought me here?"

"I didn't want to say this earlier, but..."

"Yes?"

"I seem to have lost my marbles.  I've been all over looking for them."

"Will you help me find them?"
"""


talkWithHarry : List String
talkWithHarry =
    [ "\"I'm still missing a red and a green one.\""
    , "Poor Harry.  Not the sharpest tool in the shed.  But a good mate, always ready for a pint."
    , "\"Have you found one yet?\""
    ]


showHarryOneMarble : String
showHarryOneMarble =
    """
"Harry, I've found one!"

"Let's see...  Ah yes, well done Bartholomew!  That's lovely.  But there's still one more left.

Bring this to your house to keep it safe, and I'll keep looking for the other one.  I'll pop by later to pick it up."
"""


showHarryBothMarbles : String
showHarryBothMarbles =
    """
"Harry, look what I've found!"

"Let's see...  My red marble.  And my green one too!  Well done Bartholomew, you found both of them, smashing!  Job done, let's nip off to the pub for a pint."

"Right, off to the pub!"
"""


revealRedMarble : String
revealRedMarble =
    """Good thing I brought my brolly.

Hey... there's something shiny down there in the moss.  What is it?
"""


redMarble : List String
redMarble =
    [ "It's a bright, red, perfectly round, glass marble.  It feels cool to the touch, and heavier than it looks for its size.  "
    , "I should go show Harry."
    ]


revealGreenMarble : String
revealGreenMarble =
    """Looking for Harry's marbles is a bore, maybe I'll just do a bit of gardening.

Hold on... what's this?
"""


greenMarble : List String
greenMarble =
    [ "This is a nice marble!  I can see swirls of blues and greens suspended in the dark glass when I hold it up to the light."
    , "Harry will definitely be happy I found it!"
    , "I should go show Harry."
    ]
