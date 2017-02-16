module Manifest exposing (items, locations, characters)

import ClientTypes exposing (..)
import Dict exposing (Dict)


display : String -> String -> Components
display name description =
    Dict.fromList [ ( "display", Display { name = name, description = description } ) ]


addStyle : String -> Components -> Components
addStyle selector components =
    Dict.insert "style" (Style selector) components


item : String -> String -> Entity
item name description =
    { id = name
    , components = display name description
    }


location : String -> String -> Entity
location name description =
    { id = name
    , components = display name description |> addStyle name
    }


character : String -> String -> Entity
character name description =
    { id = name
    , components = display name description
    }


items : List Entity
items =
    [ item "Umbrella" "My trusty brolly -- I take it everywhere."
    , item "Rain" "I don't mind the rain really, unless I've forgotten my brolly."
    , item "RedMarble" "Harry's marble!  It's lovely, isn't it?"
    , item "GreenMarble" "Harry's marble!  It's lovely, isn't it?"
    , item "SomethingRedAndShiny" "What is that?  Is it...?  It's a marble!"
    , item "SomethingGreenAndShiny" "What is that?  Is it...?  It's a marble!"
    , item "NoteFromHarry" "Very mysterious business, this.  I wonder what Harry wants in the marsh?"
    , item "VegatableGarden" "My veg patch needs some tidying up.  The cucumbers are so overgrown!"
    , item "Pint" "Cheers!"
    ]


characters : List Entity
characters =
    [ character "Harry" "Not the sharpest tool in the shed, but a good mate, always ready for a pint." ]


locations : List Entity
locations =
    [ location "Home" "Home sweet home.  There's nowhere I'd rather be.  Unless I'm out having an adventure."
    , location "Garden" "The garden is lovely.  The marigolds are in full bloom.  I really do need to tend to the vegetable patch though."
    , location "Marsh" "Ugh, the ground is quite damp and squishy.  What in the blazes is Harry doing out here?"
    , location "Pub" "As Samuel Johnson said, \"There is nothing which has yet been contrived by man, by which so much happiness is produced as by a good tavern or inn.\""
    ]
