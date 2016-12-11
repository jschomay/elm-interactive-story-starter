module Manifest exposing (..)

import Engine exposing (..)
import Color exposing (..)


type MyItem
    = Umbrella
    | NoteFromHarry
    | VegatableGarden
    | RedMarble
    | GreenMarble
    | SomethingGreenAndShiny
    | SomethingRedAndShiny
    | Pint


type MyLocation
    = Home
    | Garden
    | Marsh
    | Pub


type MyCharacter
    = Harry


type MyKnowledge
    = Raining


items : MyItem -> ItemInfo
items i =
    case i of
        Umbrella ->
            itemInfo "Umbrella" "My trusty brolly -- I take it everywhere."

        RedMarble ->
            itemInfo "Red Marble" "Harry's marble!  It's lovely, isn't it?"

        GreenMarble ->
            itemInfo "Green Marble" "Harry's marble!  It's lovely, isn't it?"

        SomethingRedAndShiny ->
            itemInfo "Something shiny" "What is that?  Is it...?  It's a marble!"

        SomethingGreenAndShiny ->
            itemInfo "Something shiny" "What is that?  Is it...?  It's a marble!"

        NoteFromHarry ->
            itemInfo "Note from Harry" "Very mysterious business, this.  I wonder what Harry wants in the marsh?"

        VegatableGarden ->
            itemInfo "Veg patch" "My veg patch needs some tidying up.  The cucumbers are so overgrown!"

        Pint ->
            itemInfo "Pint" "Cheers!"


characters : MyCharacter -> CharacterInfo
characters c =
    case c of
        Harry ->
            characterInfo "Harry" "Not the sharpest tool in the shed, but a good mate, always ready for a pint."


locations : MyLocation -> LocationInfo
locations l =
    case l of
        Home ->
            locationInfo "Home" Color.blue "Home sweet home.  There's nowhere I'd rather be.  Unless I'm out having an adventure."

        Garden ->
            locationInfo "Garden" Color.darkGreen "The garden is lovely.  The marigolds are in full bloom.  I really do need to tend to the vegetable patch though."

        Marsh ->
            locationInfo "Marsh" Color.purple "I wouldn't want to be caught here without my brolly!  Looks like it could rain any moment."

        Pub ->
            locationInfo "Pub" Color.darkOrange "As Samuel Johnson said, \"There is nothing which has yet been contrived by man, by which so much happiness is produced as by a good tavern or inn.\""
