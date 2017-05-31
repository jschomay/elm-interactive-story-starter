module Manifest exposing (items, locations, characters)

import ClientTypes exposing (..)
import Dict exposing (Dict)


display : String -> String -> Components
display name description =
    Dict.fromList [ ( "display", Display { name = name, description = description } ) ]


addStyle : String -> Components -> Components
addStyle selector components =
    Dict.insert "style" (Style selector) components


addDirections : List ( Direction, String ) -> Components -> Components
addDirections exits components =
    Dict.insert "connectedLocations" (ConnectedLocations exits) components


item : String -> String -> Entity
item name description =
    { id = name
    , components = display name description
    }


location : String -> String -> List ( Direction, String ) -> Entity
location name description exits =
    { id = name
    , components =
        display name description
            |> addStyle name
            |> addDirections exits
    }


character : String -> String -> Entity
character name description =
    { id = name
    , components = display name description
    }


items : List Entity
items =
    [ item "Cape" "Little Red Riding Hood's namesake."
    , item "Basket of food" "Some goodies to take to Grandma."
    ]


characters : List Entity
characters =
    [ character "Little Red Riding Hood" "Sweet and innocent, she spent her days playing around her cottage where she lived with her mother."
    , character "Mother" "Little Red Riding Hood's mother, who looks after her."
    , character "Wolf" "A very sly and clever wolf, who lives in the woods."
    , character "Grandma" "Little Red Riding Hood's grandmother, who lives alone in a cottage in the woods."
    ]


locations : List Entity
locations =
    [ location "Cottage" "The cottage where Little Red Riding Hood and her mother live." [ ( East, "River" ) ]
    , location "River" "A river that runs by Little Red Riding Hood's cottage." [ ( West, "Cottage" ), ( East, "Woods" ) ]
    , location "Woods" "The forests that surround Little Red Riding Hood's cottage." [ ( West, "River" ), ( East, "Grandma's house" ) ]
    , location "Grandma's house" "The cabin in the woods where Grandma lives alone." []
    ]
