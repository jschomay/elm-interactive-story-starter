module Scenes exposing (..)

import World exposing (..)
import Story exposing (..)


{-| "Scene 1"
-}
learnOfMystery : List (Story.Rule MyItem MyLocation MyCharacter MyKnowledge)
learnOfMystery =
    [ { interaction = withCharacter Harry
      , conditions = [ inLocation Garden ]
      , changes =
            [ moveCharacter Harry Marsh
            , addInventory NoteFromHarry
            ]
      , narration = [ harryGivesNote ]
      }
    , { interaction = withItem NoteFromHarry
      , conditions = []
      , changes = [ addLocation Marsh ]
      , narration = noteFromHarry
      }
    , { interaction = withLocation Marsh
      , conditions = [ withInventory NoteFromHarry ]
      , changes =
            [ moveTo Marsh
            , removeInventory NoteFromHarry
            ]
      , narration = []
      }
    , { interaction = withCharacter Harry
      , conditions = [ inLocation Marsh ]
      , changes = [ loadScene searchForMarbles ]
      , narration = [ harryAsksForHelp ]
      }
    ]


{-| "Scene 2"
-}
searchForMarbles : List (Story.Rule MyItem MyLocation MyCharacter MyKnowledge)
searchForMarbles =
    [ -- returning marbles
      { interaction = withCharacter Harry
      , conditions =
            [ inLocation Marsh
            , unless (withInventory RedMarble)
            , unless (withInventory GreenMarble)
            ]
      , changes = []
      , narration = talkWithHarry
      }
    , { interaction = withCharacter Harry
      , conditions =
            [ inLocation Marsh
            , withInventory RedMarble
            , withInventory GreenMarble
            ]
      , changes =
            [ addLocation Pub
            , loadScene goToPub
            , removeInventory GreenMarble
            , removeInventory RedMarble
            ]
      , narration = [ showHarryBothMarbles ]
      }
    , { interaction = withCharacter Harry
      , conditions =
            [ inLocation Marsh
            , withInventory RedMarble
            ]
      , changes = [ loadScene bringMarbleHome ]
      , narration = [ showHarryOneMarble ]
      }
    , { interaction = withCharacter Harry
      , conditions =
            [ inLocation Marsh
            , withInventory GreenMarble
            ]
      , changes = [ loadScene bringMarbleHome ]
      , narration = [ showHarryOneMarble ]
      }
      -- hidden red marble
    , { interaction = withLocation Marsh
      , conditions = []
      , changes = [ moveTo Marsh, addKnowledge Raining ]
      , narration = [ "It's starting to rain!" ]
      }
    , { interaction = withItem Umbrella
      , conditions =
            [ inLocation Marsh
            , unless (withInventory RedMarble)
            , withKnowledge Raining
            ]
      , changes = [ placeItem SomethingRedAndShiny Marsh ]
      , narration = [ revealRedMarble ]
      }
    , { interaction = withItem Umbrella
      , conditions =
            [ inLocation Marsh
            , unless (withKnowledge Raining)
            ]
      , changes = []
      , narration = [ "It's not raining yet." ]
      }
    , { interaction = withItem SomethingRedAndShiny
      , conditions = []
      , changes =
            [ addInventory RedMarble
            , removeItem SomethingRedAndShiny
            ]
      , narration = [ "Hey, it's Harry's red marble!" ]
      }
    , { interaction = withItem RedMarble
      , conditions = []
      , changes = []
      , narration = redMarble
      }
      -- hidden green marble
    , { interaction = withItem VegatableGarden
      , conditions = [ unless (withInventory GreenMarble) ]
      , changes = [ placeItem SomethingGreenAndShiny Garden ]
      , narration = [ revealGreenMarble ]
      }
    , { interaction = withItem SomethingGreenAndShiny
      , conditions = []
      , changes =
            [ addInventory GreenMarble
            , removeItem SomethingGreenAndShiny
            ]
      , narration = [ "It's Harry's green marble!  How did that get there?" ]
      }
    , { interaction = withItem GreenMarble
      , conditions = []
      , changes = []
      , narration = greenMarble
      }
    ]


{-| "Ending 1"
-}
bringMarbleHome : List (Story.Rule MyItem MyLocation MyCharacter MyKnowledge)
bringMarbleHome =
    [ { interaction = withLocation Home
      , conditions = [ withInventory RedMarble ]
      , changes = [ moveTo Home, placeItem RedMarble Home ]
      , narration =
            [ "This will be safe here." ]
      }
    , { interaction = withAnything
      , conditions = [ inLocation Home ]
      , changes = []
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
    , { interaction = withAnyItem
      , conditions = []
      , changes = []
      , narration =
            [ "Harry wants me to bring his marble safely home.  I wouldn't mind a nice cup of tea besides." ]
      }
    , { interaction = withAnyLocation
      , conditions = []
      , changes = []
      , narration =
            [ "I really think I should just do as Harry asked." ]
      }
    , { interaction = withCharacter Harry
      , conditions = []
      , changes = []
      , narration =
            [ "\"Go on now Bartholomew, keep that safe for me.\"" ]
      }
    ]


{-| "Ending 2"
-}
goToPub : List (Story.Rule MyItem MyLocation MyCharacter MyKnowledge)
goToPub =
    [ { interaction = withLocation Pub
      , conditions = [ unless (inLocation Pub) ]
      , changes =
            [ moveTo Pub
            , moveCharacter Harry Pub
            ]
      , narration = []
      }
    , { interaction = withItem Pint
      , conditions = []
      , changes = []
      , narration = [ "Cheers Harry!  To the next adventure." ]
      }
    , { interaction = withAnything
      , conditions = [ unless (inLocation Pub) ]
      , changes = []
      , narration = [ "I can't think of any better way to end an adventure, than with a pint in the pub with a good friend." ]
      }
    , { interaction = withAnything
      , conditions = [ inLocation Pub ]
      , changes = []
      , narration =
            [ "Another daring adventure, finished."
            , "There's nothing more to do, not until the next adventure."
            , "The end."
            ]
      }
    ]


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
