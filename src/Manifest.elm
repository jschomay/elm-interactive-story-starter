module Manifest exposing (items, locations, characters)


items : List ( String, { name : String, description : String } )
items =
    [ ( "Umbrella", { name = "Umbrella", description = "My trusty brolly -- I take it everywhere." } )
    , ( "Rain", { name = "Rain", description = "I don't mind the rain really, unless I've forgotten my brolly." } )
    , ( "RedMarble", { name = "Red Marble", description = "Harry's marble!  It's lovely, isn't it?" } )
    , ( "GreenMarble", { name = "Green Marble", description = "Harry's marble!  It's lovely, isn't it?" } )
    , ( "SomethingRedAndShiny", { name = "Something shiny", description = "What is that?  Is it...?  It's a marble!" } )
    , ( "SomethingGreenAndShiny", { name = "Something shiny", description = "What is that?  Is it...?  It's a marble!" } )
    , ( "NoteFromHarry", { name = "Note from Harry", description = "Very mysterious business, this.  I wonder what Harry wants in the marsh?" } )
    , ( "VegatableGarden", { name = "Veg patch", description = "My veg patch needs some tidying up.  The cucumbers are so overgrown!" } )
    , ( "Pint", { name = "Pint", description = "Cheers!" } )
    ]


characters : List ( String, { name : String, description : String } )
characters =
    [ ( "Harry", { name = "Harry", description = "Not the sharpest tool in the shed, but a good mate, always ready for a pint." } ) ]


locations : List ( String, { name : String, description : String } )
locations =
    [ ( "Home", { name = "Home", description = "Home sweet home.  There's nowhere I'd rather be.  Unless I'm out having an adventure." } )
    , ( "Garden", { name = "Garden", description = "The garden is lovely.  The marigolds are in full bloom.  I really do need to tend to the vegetable patch though." } )
    , ( "Marsh", { name = "Marsh", description = "Ugh, the ground is quite damp and squishy.  What in the blazes is Harry doing out here?" } )
    , ( "Pub", { name = "Pub", description = "As Samuel Johnson said, \"There is nothing which has yet been contrived by man, by which so much happiness is produced as by a good tavern or inn.\"" } )
    ]
