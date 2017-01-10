module Scenes exposing (scenes)

import Engine exposing (..)
import ClientTypes exposing (..)


scenes : List ( Id, List ( Id, Engine.Rule, Narration ) )
scenes =
    [ ( "learnOfMystery", learnOfMystery )
    , ( "searchForMarbles", searchForMarbles )
    , ( "bringMarbleHome", bringMarbleHome )
    , ( "bringMarbleHome", bringMarbleHome )
    , ( "goToPub", goToPub )
    ]


learnOfMystery : List ( Id, Engine.Rule, Narration )
learnOfMystery =
    []
        ++ ( "get note from harry"
           , { interaction = withCharacter "Harry"
             , conditions = [ currentLocationIs "Garden" ]
             , changes =
                [ moveCharacterToLocation "Harry" "Marsh"
                , moveItemToInventory "NoteFromHarry"
                ]
             }
           , [ harryGivesNote ]
           )
        :: ( "read harry's note"
           , { interaction = withItem "NoteFromHarry"
             , conditions = []
             , changes = [ addLocation "Marsh" ]
             }
           , noteFromHarry
           )
        :: ( "go to marsh"
           , { interaction = withLocation "Marsh"
             , conditions = [ itemIsInInventory "NoteFromHarry" ]
             , changes =
                [ moveTo "Marsh"
                , moveItemOffScreen "NoteFromHarry"
                ]
             }
           , []
           )
        :: ( "harry asks for help"
           , { interaction = withCharacter "Harry"
             , conditions = [ currentLocationIs "Marsh" ]
             , changes = [ loadScene "searchForMarbles" ]
             }
           , [ harryAsksForHelp ]
           )
        :: []


searchForMarbles : List ( Id, Engine.Rule, Narration )
searchForMarbles =
    []
        ++ ( "more about marbles"
           , { interaction = withCharacter "Harry"
             , conditions =
                [ currentLocationIs "Marsh"
                , itemIsNotInInventory "RedMarble"
                , itemIsNotInInventory "GreenMarble"
                ]
             , changes = []
             }
           , talkWithHarry
           )
        :: ( "show both marbles"
           , { interaction = withCharacter "Harry"
             , conditions =
                [ currentLocationIs "Marsh"
                , itemIsInInventory "RedMarble"
                , itemIsInInventory "GreenMarble"
                ]
             , changes =
                [ addLocation "Pub"
                , loadScene "goToPub"
                , moveItemOffScreen "GreenMarble"
                , moveItemOffScreen "RedMarble"
                ]
             }
           , [ showHarryBothMarbles ]
           )
        :: ( "show red marble"
           , { interaction = withCharacter "Harry"
             , conditions =
                [ currentLocationIs "Marsh"
                , itemIsInInventory "RedMarble"
                ]
             , changes = [ loadScene "bringMarbleHome" ]
             }
           , [ showHarryOneMarble ]
           )
        :: ( "show green marble"
           , { interaction = withCharacter "Harry"
             , conditions =
                [ currentLocationIs "Marsh"
                , itemIsInInventory "GreenMarble"
                ]
             , changes = [ loadScene "bringMarbleHome" ]
             }
           , [ showHarryOneMarble ]
           )
        :: ( "starts raining"
           , { interaction = withLocation "Marsh"
             , conditions =
                [ itemIsNotInLocation "Rain" "Marsh" ]
             , changes =
                [ moveTo "Marsh"
                , moveItemToLocationFixed "Rain" "Marsh"
                ]
             }
           , [ "It's starting to rain!" ]
           )
        :: ( "in rain with umbrella"
           , { interaction = withLocation "Marsh"
             , conditions =
                [ itemIsInLocation "Rain" "Marsh"
                , itemIsInInventory "Umbrella"
                ]
             , changes = [ moveTo "Marsh" ]
             }
           , [ "Still raining.  Good thing I brought my brolly!" ]
           )
        :: ( "in rain without umbrella"
           , { interaction = withLocation "Marsh"
             , conditions =
                [ itemIsInLocation "Rain" "Marsh"
                , itemIsNotInInventory "Umbrella"
                ]
             , changes = [ moveTo "Marsh" ]
             }
           , [ "I'm getting all wet!  How miserable.  Foolish of me to leave my brolly at home on a day like this!" ]
           )
        :: ( "reveal red marble"
           , { interaction = withItem "Umbrella"
             , conditions =
                [ currentLocationIs "Marsh"
                , itemIsInLocation "Rain" "Marsh"
                , itemIsNotInInventory "RedMarble"
                , itemIsNotInLocation "SomethingRedAndShiny" "Marsh"
                ]
             , changes = [ moveItemToLocation "SomethingRedAndShiny" "Marsh" ]
             }
           , [ revealRedMarble ]
           )
        :: ( "find red marble"
           , { interaction = withItem "SomethingRedAndShiny"
             , conditions = []
             , changes =
                [ moveItemToInventory "RedMarble"
                , moveItemOffScreen "SomethingRedAndShiny"
                ]
             }
           , [ "Hey, it's Harry's red marble!" ]
           )
        :: ( "red marble description"
           , { interaction = withItem "RedMarble"
             , conditions = []
             , changes = []
             }
           , redMarble
           )
        :: ( "reveal green marble"
           , { interaction = withItem "VegatableGarden"
             , conditions = [ itemIsNotInInventory "GreenMarble" ]
             , changes = [ moveItemToLocation "SomethingGreenAndShiny" "Garden" ]
             }
           , [ revealGreenMarble ]
           )
        :: ( "find green marble"
           , { interaction = withItem "SomethingGreenAndShiny"
             , conditions = []
             , changes =
                [ moveItemToInventory "GreenMarble"
                , moveItemOffScreen "SomethingGreenAndShiny"
                ]
             }
           , [ "It's Harry's green marble!  How did that get there?" ]
           )
        :: ( "green marble description"
           , { interaction = withItem "GreenMarble"
             , conditions = []
             , changes = []
             }
           , greenMarble
           )
        :: []


bringMarbleHome : List ( Id, Engine.Rule, Narration )
bringMarbleHome =
    []
        ++ ( "bring red marble home"
           , { interaction = withLocation "Home"
             , conditions = [ itemIsInInventory "RedMarble" ]
             , changes =
                [ moveTo "Home"
                , moveItemToLocation "RedMarble" "Home"
                ]
             }
           , [ "This will be safe here." ]
           )
        :: ( "bring green marble home"
           , { interaction = withLocation "Home"
             , conditions = [ itemIsInInventory "GreenMarble" ]
             , changes =
                [ moveTo "Home"
                , moveItemToLocation "GreenMarble" "Home"
                ]
             }
           , [ "This will be safe here." ]
           )
        :: ( "lonely ending"
           , { interaction = withAnything
             , conditions = [ currentLocationIs "Home" ]
             , changes = [ endStory "Ending 1 of 2: All's well that ends well, though a bit lonely." ]
             }
           , [ "Well, that's quite enough adventuring for today.  I think I'll just put on some tea and wait for Harry to come around."
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
           )
        :: ( "focus on getting home"
           , { interaction = withAnyItem
             , conditions = [ currentLocationIsNot "Home" ]
             , changes = []
             }
           , [ "Harry wants me to bring his marble safely home.  I wouldn't mind a nice cup of tea besides." ]
           )
        :: ( "go where harry said"
           , { interaction = withAnyLocation
             , conditions = [ currentLocationIsNot "Home" ]
             , changes = []
             }
           , [ "I really think I should just do as Harry asked." ]
           )
        :: ( "no more to say"
           , { interaction = withCharacter "Harry"
             , conditions = []
             , changes = []
             }
           , [ "\"Go on now Bartholomew, keep that safe for me.\"" ]
           )
        :: []


goToPub : List ( Id, Engine.Rule, Narration )
goToPub =
    []
        ++ ( "go to pub with Harry"
           , { interaction = withLocation "Pub"
             , conditions = [ currentLocationIsNot "Pub" ]
             , changes =
                [ moveTo "Pub"
                , moveCharacterToLocation "Harry" "Pub"
                ]
             }
           , []
           )
        :: ( "cheers"
           , { interaction = withItem "Pint"
             , conditions = []
             , changes = []
             }
           , [ "Cheers Harry!  To the next adventure." ]
           )
        :: ( "z focus on going to pub"
             -- TODO this is needed until rules are weighted (or it matches instead of "go to pub with Harry")
           , { interaction = withAnything
             , conditions = [ currentLocationIsNot "Pub" ]
             , changes = []
             }
           , [ "Right now I just really want a pint!" ]
           )
        :: ( "good ending"
           , { interaction = withAnything
             , conditions = [ currentLocationIs "Pub" ]
             , changes = [ endStory "Ending 2 of 2: No better way to end an adventure, than with a pint in the pub with a good friend!" ]
             }
           , [ "Another daring adventure, finished."
             , "There's nothing more to do, not until the next adventure."
             , "The end."
             ]
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
