module Main exposing (..)

import Story exposing (..)
import World exposing (..)
import Scenes exposing (..)


main : Program Never
main =
    Story.load info interactables setup


info : Info
info =
    { title = "The Very Short Adventures of Bartholomew Barrymore featuring: The mystery of the missing marbles"
    , byline = "B. B."
    , prologue = """Bartholomew Barrymore is at it again, using his fantastic deductive skills to solve the most intriguing of mysteries.
![](img/cottage.jpg)
    """
    }


interactables : World MyItem MyLocation MyCharacter
interactables =
    world items locations characters


setup : StartingState MyItem MyLocation MyCharacter MyKnowledge
setup =
    { startingScene = learnOfMystery
    , startingLocation = Home
    , startingNarration = "Ahh, a brand new day.  I wonder what I will get up to.  There's no telling who I will meet, what I will find, where I will go..."
    , setupCommands =
        [ addInventory Umbrella
        , placeItem VegatableGarden Garden
        , addLocation Home
        , addLocation Garden
        , moveCharacter Harry Garden
        , placeItem Pint Pub
        ]
    }
