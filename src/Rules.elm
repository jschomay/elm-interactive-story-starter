module Rules exposing (rulesData)

import Engine exposing (..)
import ClientTypes exposing (..)


rulesData : List (RuleData Engine.Rule)
rulesData =
    { summary = "leaving without cape"
    , interaction = withAnyLocation
    , conditions =
        [ currentLocationIs "Cottage"
        , itemIsNotInInventory "Cape"
        ]
    , changes =
        []
    , narrative =
        [ """
"Oh Little Red Riding Hood," her mother called out, "don't forget your cape.  It might be cold in the woods."
"""
        ]
    }
        :: { summary = "leaving without basket"
           , interaction = withAnyLocation
           , conditions =
                [ currentLocationIs "Cottage"
                , itemIsNotInInventory "Basket of food"
                ]
           , changes =
                []
           , narrative =
                [ """
 "Oh Little Red Riding Hood," her mother called out, "don't forget the basket of food to bring to Grandma!"
"""
                ]
           }
        :: { summary = "describe cottage"
           , interaction = with "Cottage"
           , conditions =
                [ currentLocationIs "Cottage"
                ]
           , changes =
                []
           , narrative =
                [ """
The cottage where Little Red Riding Hood and her mother live.
"""
                ]
           }
        :: { summary = "trying to jump directly from Cottage to Grandma's house"
           , interaction = with "Grandma's house"
           , conditions =
                [ currentLocationIs "Cottage"
                , itemIsInInventory "Cape"
                , itemIsInInventory "Basket of food"
                ]
           , changes =
                []
           , narrative =
                [ """
The way to Grandma's house is over the river and through the woods.
"""
                ]
           }
        :: { summary = "trying to jump directly from River to Grandma's house"
           , interaction = with "Grandma's house"
           , conditions =
                [ currentLocationIs "River"
                , itemIsInInventory "Cape"
                , itemIsInInventory "Basket of food"
                ]
           , changes =
                []
           , narrative =
                [ """
The way to Grandma's house is through the woods.
"""
                ]
           }
        :: { summary = "trying to jump directly from Cottage to Woods"
           , interaction = with "Woods"
           , conditions =
                [ currentLocationIs "Cottage"
                , itemIsInInventory "Cape"
                , itemIsInInventory "Basket of food"
                ]
           , changes =
                []
           , narrative =
                [ """
The woods are on the other side of the river.
"""
                ]
           }
        :: { summary = "going back to the Cottage"
           , interaction = with "Cottage"
           , conditions =
                [ currentLocationIsNot "Cottage"
                ]
           , changes =
                []
           , narrative =
                [ """
Little Red Riding Hood knew that her mother would be cross if she did not bring the basket of food to Grandma.
"""
                ]
           }
        :: { summary = "leaving the Cottage"
           , interaction = with "River"
           , conditions =
                [ currentLocationIs "Cottage"
                , itemIsInInventory "Cape"
                , itemIsInInventory "Basket of food"
                ]
           , changes =
                [ moveTo "River"
                , moveCharacterToLocation "Little Red Riding Hood" "River"
                ]
           , narrative =
                [ """
Little Red Riding Hood skipped out of the cottage, singing a happy song and swinging the basket of food by her side.  Soon she arrived at the old bridge that went over the river.  On the other side of the bridge were the woods where Grandma lived.
"""
                ]
           }
        :: { summary = "going from Woods to River"
           , interaction = with "River"
           , conditions =
                [ currentLocationIs "Woods"
                , itemIsInInventory "Cape"
                , itemIsInInventory "Basket of food"
                ]
           , changes =
                []
           , narrative =
                [ """
Grandma's house is the other direction.
"""
                , """
The wolf was still there, trying to hide the hungry look in his eye.
"""
                ]
           }
        :: { summary = "entering the Woods"
           , interaction = with "Woods"
           , conditions =
                [ currentLocationIs "River"
                , itemIsInInventory "Cape"
                , itemIsInInventory "Basket of food"
                , characterIsInLocation "Wolf" "Woods"
                ]
           , changes =
                [ moveTo "Woods"
                , moveCharacterToLocation "Little Red Riding Hood" "Woods"
                ]
           , narrative =
                [ """
Little Red Riding Hood followed the path deep into the woods.  Birds chirped in the trees high above, and squirrels scampered up the trunks, looking for nuts.  Little Red Riding Hood loved the woods and all of the animals that lived there.

At first, Little Red Riding Hood did not see the wolf spying on her in the shadows, looking at her basket of food and licking his chops.  He was a crafty wolf, and came up with a plan.

Putting on his best smile, the wolf greeted Little Red Riding Hood.  "Good morning my pretty child.  What a lovely cape you have on.  May I ask, where are you going with that delicious looking basket of food?"
"""
                ]
           }
        :: { summary = "ignoring the wolf"
           , interaction = with "Grandma's house"
           , conditions =
                [ currentLocationIs "Woods"
                , itemIsInInventory "Cape"
                , itemIsInInventory "Basket of food"
                , characterIsInLocation "Wolf" "Woods"
                ]
           , changes =
                [ moveTo "Grandma's house"
                , moveCharacterToLocation "Little Red Riding Hood" "Grandma's house"
                , endStory "The End"
                ]
           , narrative =
                [ """
Little Red Riding Hood remembered her mother's warning about not talking to strangers, and hurried away to Grandma's house.

Grandma was so happy to see Little Red Riding Hood, and they ate the goodies she had brought, and everyone lived happily ever after.
"""
                ]
           }
        :: { summary = "talking to the wolf in the Woods"
           , interaction = with "Wolf"
           , conditions =
                [ currentLocationIs "Woods"
                , itemIsInInventory "Cape"
                , itemIsInInventory "Basket of food"
                , characterIsInLocation "Wolf" "Woods"
                ]
           , changes =
                [ moveCharacterToLocation "Wolf" "Grandma's house"
                , moveCharacterOffScreen "Grandma"
                ]
           , narrative =
                [ """
Little Red Riding Hood thought the wolf looked so kind and so friendly that she happily told him, "I'm going to visit Grandma, who lives in these woods.  She isn't feeling well, so I am bringing her a basket of food."

The wolf muttered "That's very interesting.  I hope she feels better soon."  Then he made a funny little bow and scampered off down the path.
"""
                ]
           }
        :: { summary = "finding the wolf at Grandma's house"
           , interaction = with "Grandma's house"
           , conditions =
                [ currentLocationIs "Woods"
                , characterIsInLocation "Wolf" "Grandma's house"
                ]
           , changes =
                [ moveTo "Grandma's house"
                , moveCharacterToLocation "Little Red Riding Hood" "Grandma's house"
                , endStory "The End"
                ]
           , narrative =
                [ """
Little Red Riding Hood found the door to Grandma's house unlocked, so she went in.  She saw Grandma sleeping in the bed with the covers pulled high over her face, and her nightcap pulled low over her forehead.

But she looked a little different than usual.  Little Red Riding Hood did not know that the wolf had ran to Grandma's house before her, and eaten Grandma up, and was now lying in her bed pretending to be Grandma!

"Grandma, what big eyes you have."

"The better to see you with, my dear," said the wolf, as softly as he could.

"And Grandma, what big ears you have."

"The better to hear you with, my dear."

"And Grandma, what big teeth you have!"

"The better to gobble you up with!"  And the wolf jumped out of bed and that is exactly what he did.  And that is why we don't talk to strangers.
"""
                ]
           }
        :: []
