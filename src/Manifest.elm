module Manifest exposing (items, locations, characters)

import Components exposing (..)


{- Here is where you define your manifest -- all of the items, characters, and locations in your story. You can add what ever components you wish to each entity.  Note that the first argument to `entity` is the id for that entity, which is the id you must refer to in your rules.
   In the current theme, the description in the display info component is only used as a fallback narrative if a rule does not match with a more specific narrative when interacting with that story object.
-}


items : List Entity
items =
    [ entity "cape"
        |> addDisplayInfo "Cape" "Little Red Riding Hood's namesake."
    , entity "basket"
        |> addDisplayInfo "Basket of food" "Some goodies to take to Grandma."
    ]


characters : List Entity
characters =
    [ entity "lrrh"
        |> addDisplayInfo "Little Red Riding Hood" "Sweet and innocent, she spent her days playing around her cottage where she lived with her mother."
    , entity "mother"
        |> addDisplayInfo "Mother" "Little Red Riding Hood's mother, who looks after her."
    , entity "wolf"
        |> addDisplayInfo "Wolf" "A very sly and clever wolf, who lives in the woods."
    , entity "grandma"
        |> addDisplayInfo "Grandma" "Little Red Riding Hood's grandmother, who lives alone in a cottage in the woods."
    ]


locations : List Entity
locations =
    [ entity "cottage"
        |> addDisplayInfo "Cottage" "The cottage where Little Red Riding Hood and her mother live."
        |> addConnectingLocations [ ( East, "river" ) ]
        |> addClassName "cottage"
    , entity "river"
        |> addDisplayInfo "River" "A river that runs by Little Red Riding Hood's cottage."
        |> addConnectingLocations [ ( West, "cottage" ), ( East, "woods" ) ]
        |> addClassName "river"
    , entity "woods"
        |> addDisplayInfo "Woods" "The forests that surround Little Red Riding Hood's cottage."
        |> addConnectingLocations [ ( West, "river" ), ( East, "grandmasHouse" ) ]
        |> addClassName "woods"
    , entity "grandmasHouse"
        |> addDisplayInfo "Grandma's house" "The cabin in the woods where Grandma lives alone."
        |> addClassName "grandmasHouse"
    ]
