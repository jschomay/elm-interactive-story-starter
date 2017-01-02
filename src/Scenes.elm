module Scenes exposing (scenes)

import Engine exposing (..)


scenes : List ( String, List ( String, Engine.Rule ) )
scenes =
    [ ( "learnOfMystery", learnOfMystery )
    , ( "searchForMarbles", searchForMarbles )
    , ( "bringMarbleHome", bringMarbleHome )
    , ( "bringMarbleHome", bringMarbleHome )
    , ( "goToPub", goToPub )
    ]


learnOfMystery : List ( String, Engine.Rule )
learnOfMystery =
    []
        ++ ( "get note from harry"
           , { interaction = withCharacter "Harry"
             , conditions = [ isInLocation "Garden" ]
             , changes =
                [ moveCharacter "Harry" "Marsh"
                , moveItemToInventory "NoteFromHarry"
                ]
             , narration = [ harryGivesNote ]
             }
           )
        :: ( "read harry's note"
           , { interaction = withItem "NoteFromHarry"
             , conditions = []
             , changes = [ addLocation "Marsh" ]
             , narration = noteFromHarry
             }
           )
        :: ( "go to marsh"
           , { interaction = withLocation "Marsh"
             , conditions = [ itemIsInInventory "NoteFromHarry" ]
             , changes =
                [ moveTo "Marsh"
                , moveItemOffScreen "NoteFromHarry"
                ]
             , narration = []
             }
           )
        :: ( "harry asks for help"
           , { interaction = withCharacter "Harry"
             , conditions = [ isInLocation "Marsh" ]
             , changes = [ loadScene "searchForMarbles" ]
             , narration = [ harryAsksForHelp ]
             }
           )
        :: []


searchForMarbles : List ( String, Engine.Rule )
searchForMarbles =
    []
        ++ ( "more about marbles"
           , { interaction = withCharacter "Harry"
             , conditions =
                [ isInLocation "Marsh"
                , itemIsNotInInventory "RedMarble"
                , itemIsNotInInventory "GreenMarble"
                ]
             , changes = []
             , narration = talkWithHarry
             }
           )
        :: ( "show both marbles"
           , { interaction = withCharacter "Harry"
             , conditions =
                [ isInLocation "Marsh"
                , itemIsInInventory "RedMarble"
                , itemIsInInventory "GreenMarble"
                ]
             , changes =
                [ addLocation "Pub"
                , loadScene "goToPub"
                , moveItemOffScreen "GreenMarble"
                , moveItemOffScreen "RedMarble"
                ]
             , narration = [ showHarryBothMarbles ]
             }
           )
        :: ( "show red marble"
           , { interaction = withCharacter "Harry"
             , conditions =
                [ isInLocation "Marsh"
                , itemIsInInventory "RedMarble"
                ]
             , changes = [ loadScene "bringMarbleHome" ]
             , narration = [ showHarryOneMarble ]
             }
           )
        :: ( "show green marble"
           , { interaction = withCharacter "Harry"
             , conditions =
                [ isInLocation "Marsh"
                , itemIsInInventory "GreenMarble"
                ]
             , changes = [ loadScene "bringMarbleHome" ]
             , narration = [ showHarryOneMarble ]
             }
           )
        :: ( "rain in marsh"
           , { interaction = withLocation "Marsh"
             , conditions =
                [ itemIsNotPresent "Rain" ]
                -- TODO, needs location fix
             , changes =
                [ moveTo "Marsh"
                , moveItem "Rain" "Marsh"
                ]
             , narration = [ "It's starting to rain!" ]
             }
           )
        :: ( "reveal red marble"
           , { interaction = withItem "Umbrella"
             , conditions =
                [ isInLocation "Marsh"
                , itemIsPresent "Rain"
                , itemIsNotInInventory "RedMarble"
                , itemIsNotPresent "SomethingRedAndShiny"
                ]
             , changes = [ moveItem "SomethingRedAndShiny" "Marsh" ]
             , narration = [ revealRedMarble ]
             }
           )
        :: ( "find red marble"
           , { interaction = withItem "SomethingRedAndShiny"
             , conditions = []
             , changes =
                [ moveItemToInventory "RedMarble"
                , moveItemOffScreen "SomethingRedAndShiny"
                ]
             , narration = [ "Hey, it's Harry's red marble!" ]
             }
           )
        :: ( "red marble description"
           , { interaction = withItem "RedMarble"
             , conditions = []
             , changes = []
             , narration = redMarble
             }
           )
        :: ( "reveal green marble"
           , { interaction = withItem "VegatableGarden"
             , conditions = [ itemIsNotInInventory "GreenMarble" ]
             , changes = [ moveItem "SomethingGreenAndShiny" "Garden" ]
             , narration = [ revealGreenMarble ]
             }
           )
        :: ( "find green marble"
           , { interaction = withItem "SomethingGreenAndShiny"
             , conditions = []
             , changes =
                [ moveItemToInventory "GreenMarble"
                , moveItemOffScreen "SomethingGreenAndShiny"
                ]
             , narration = [ "It's Harry's green marble!  How did that get there?" ]
             }
           )
        :: ( "green marble description"
           , { interaction = withItem "GreenMarble"
             , conditions = []
             , changes = []
             , narration = greenMarble
             }
           )
        :: []


bringMarbleHome : List ( String, Engine.Rule )
bringMarbleHome =
    []
        ++ ( "bring red marble home"
           , { interaction = withLocation "Home"
             , conditions = [ itemIsInInventory "RedMarble" ]
             , changes =
                [ moveTo "Home"
                , moveItem "RedMarble" "Home"
                ]
             , narration =
                [ "This will be safe here." ]
             }
           )
        :: ( "bring green marble home"
           , { interaction = withLocation "Home"
             , conditions = [ itemIsInInventory "GreenMarble" ]
             , changes =
                [ moveTo "Home"
                , moveItem "GreenMarble" "Home"
                ]
             , narration = [ "This will be safe here." ]
             }
           )
        :: ( "lonely ending"
           , { interaction = withAnything
             , conditions = [ isInLocation "Home" ]
             , changes = [ endStory "Ending 1 of 2: All's well that ends well, though a bit lonely." ]
             , narration =
                [ "Well, that's quite enough adventuring for today.  I think I'll just put on some tea and wait for Harry to come around."
                , "Ah yes, lovely tea."
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
           )
        :: ( "focus on getting home"
           , { interaction = withAnyItem
             , conditions = [ isNotInLocation "Home" ]
             , changes = []
             , narration =
                [ "Harry wants me to bring his marble safely home.  I wouldn't mind a nice cup of tea besides." ]
             }
           )
        :: ( "go where harry said"
           , { interaction = withAnyLocation
             , conditions = [ isNotInLocation "Home" ]
             , changes = []
             , narration =
                [ "I really think I should just do as Harry asked." ]
             }
           )
        :: ( "no more to say"
           , { interaction = withCharacter "Harry"
             , conditions = []
             , changes = []
             , narration =
                [ "\"Go on now Bartholomew, keep that safe for me.\"" ]
             }
           )
        :: []


goToPub : List ( String, Engine.Rule )
goToPub =
    []
        ++ ( "go to pub with Harry"
           , { interaction = withLocation "Pub"
             , conditions = [ isNotInLocation "Pub" ]
             , changes =
                [ moveTo "Pub"
                , moveCharacter "Harry" "Pub"
                ]
             , narration = []
             }
           )
        :: ( "cheers"
           , { interaction = withItem "Pint"
             , conditions = []
             , changes = []
             , narration = [ "Cheers Harry!  To the next adventure." ]
             }
           )
        :: ( "z focus on going to pub"
             -- TODO this is needed until rules are weighted (or it matches instead of "go to pub with Harry")
           , { interaction = withAnything
             , conditions = [ isNotInLocation "Pub" ]
             , changes = []
             , narration = [ "Right now I just really want a pint!" ]
             }
           )
        :: ( "good ending"
           , { interaction = withAnything
             , conditions = [ isInLocation "Pub" ]
             , changes = [ endStory "Ending 2 of 2: No better way to end an adventure, than with a pint in the pub with a good friend!" ]
             , narration =
                [ "Another daring adventure, finished."
                , "There's nothing more to do, not until the next adventure."
                , "The end."
                ]
             }
           )
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
"""


talkWithHarry : List String
talkWithHarry =
    [ "\"Will you help me find them?\""
    , "\"I'm still missing a red and a green one.\""
    , "Poor Harry.  Not the sharpest tool in the shed.  But a good mate, always ready for a pint."
    , "\"Have you found one yet?\""
    ]


showHarryOneMarble : String
showHarryOneMarble =
    """
"Harry, I've found one!"
"Let's see.  Well done Bartholomew!  That's lovely.  Only one more left.  Bring it to your house to keep it safe.  I'll pop by later to pick it up."
"""


showHarryBothMarbles : String
showHarryBothMarbles =
    """
"Harry, look what I've found!"
"Let's see.  My red marble.  And my green one too!  Well done Bartholomew, you found both of them.  That's just smashing!  Job done, want to nip to the pub for a pint?"
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
