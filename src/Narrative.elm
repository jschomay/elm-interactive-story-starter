module Narrative exposing (..)

import ClientTypes exposing (..)


{- Here is where you can write all of your story text, which keeps the Rules.elm file a little cleaner.
   The narrative that you add to a rule will be shown when that rule matches.  If you give a list of strings, each time the rule matches, it will show the next narrative in the list, which is nice for adding variety and texture to your story.
   I sometimes like to write all my narrative content first, then create the rules they correspond to.
   Note that you can use **markdown** in your text!
-}


{-| The text that will show when the story first starts, before the player interacts with anythin.
-}
startingNarrative : StorySnippet
startingNarrative =
    { interactableName = "Once upon a time..."
    , interactableCssSelector = "opening"
    , narrative =
        """Once upon a time there was a young girl named Little Red Riding Hood, because she was so fond of her red cape that her grandma gave to her.

One day, her mother said to her, "Little Red Riding Hood, take this basket of food to your Grandma, who lives in the woods, because she is not feeling well.  And remember, don't talk to strangers on the way!"
"""
    }


leavingWithoutCape : List String
leavingWithoutCape =
    [ """
"Oh Little Red Riding Hood," her mother called out, "don't forget your cape.  It might be cold in the woods."
"""
    ]


leavingWithoutBasket : List String
leavingWithoutBasket =
    [ """
 "Oh Little Red Riding Hood," her mother called out, "don't forget the basket of food to bring to Grandma!"
"""
    ]


returningToCottage : List String
returningToCottage =
    [ """
Little Red Riding Hood knew that her mother would be cross if she did not bring the basket of food to Grandma.
"""
    ]


ignoreWolf : List String
ignoreWolf =
    [ """
Little Red Riding Hood remembered her mother's warning about not talking to strangers, and hurried away to Grandma's house.

Grandma was so happy to see Little Red Riding Hood.
"""
    ]


findWolfAtGrandmas : List String
findWolfAtGrandmas =
    [ """
Little Red Riding Hood found the door to Grandma's house unlocked, so she went in.  She saw Grandma sleeping in the bed with the covers pulled high over her face, and her nightcap pulled low over her forehead.
But she looked a little different than usual.

Little Red Riding Hood did not know that the wolf had ran to Grandma's house before her, and eaten Grandma up, and was now lying in her bed pretending to be Grandma!

![](img/wolf-as-grandma.jpg)
"""
    ]


demise : List String
demise =
    [ """
"Grandma, what big eyes you have."

"The better to see you with, my dear," said the wolf, as softly as he could.
"""
    , """
"And Grandma, what big ears you have."

"The better to hear you with, my dear."
"""
    , """
"And Grandma, what big teeth you have!"

"The better to gobble you up with!"  And the wolf jumped out of bed and that is exactly what he did.  And that is why we don't talk to strangers.
"""
    ]


enteringWoods : List String
enteringWoods =
    [ """
Little Red Riding Hood followed the path deep into the woods.  Birds chirped in the trees high above, and squirrels scampered up the trunks, looking for nuts.

At first, Little Red Riding Hood did not see the wolf spying on her in the shadows, looking at her basket of food and licking his chops.  He was a crafty wolf, and came up with a plan.

Putting on his best smile, the wolf greeted Little Red Riding Hood.

"Good morning my pretty child.  What a lovely cape you have on.  May I ask, where are you going with that delicious looking basket of food?"

![](img/meet-wolf.jpg)
                """
    ]


leavingCottage : List String
leavingCottage =
    [ """
Little Red Riding Hood skipped out of the cottage, singing a happy song and swinging the basket of food by her side.  Soon she arrived at the old bridge that went over the river.

On the other side of the bridge were the woods where Grandma lived.
"""
    ]


returningToRiver : List String
returningToRiver =
    [ """
Grandma's house is the other direction.
"""
    , """
The wolf was still there, trying to hide the hungry look in his eye.
"""
    ]


talkToWolf : List String
talkToWolf =
    [ """
Little Red Riding Hood thought the wolf looked so kind and so friendly that she happily told him, "I'm going to visit Grandma, who lives in these woods.  She isn't feeling well, so I am bringing her a basket of food."

The wolf muttered "That's very interesting.  I hope she feels better soon."

Then he smiled a crafty smile and dashed off into the woods.

Little Red Riding Hood thought that seemed a little unusual.
"""
    ]


talkToMother : List String
talkToMother =
    [ "\"Don't keep Grandma waiting.\""
    , "\"Remember, don't talk to strangers.\""
    , "\"Hurry along Little Red Riding Hood.\""
    ]


excitedToVisitGrandma : List String
excitedToVisitGrandma =
    [ "Little Red Riding Hood always enjoyed visiting her Grandma, and was excited to see her again." ]


dallying : List String
dallying =
    [ "Shouldn't keep Grandma waiting." ]


takeBasket : List String
takeBasket =
    [ "Little Red Riding Hood took the nice basket that her mother had prepared.  It was full of delicious food and cakes and even a little wine." ]


takeCape : List String
takeCape =
    [ "Little Red Riding Hood eagerly put on her red cape." ]


crossingTheRiver : List String
crossingTheRiver =
    [ "Little Red Riding Hood loved to be outside, although her mother usually forbade her to go past the old bridge that went over the river.  But today she pressed on."
    , "Little Red Riding Hood was eager to see her Grandma."
    ]


inTheWoods : List String
inTheWoods =
    [ "Little Red Riding Hood felt slightly afraid in the dark woods."
    , "She seemed very small amongst the tall trees."
    , "She couldn't wait to safely get to her Grandma's house."
    ]


surprisedByWolf : List String
surprisedByWolf =
    [ "At first the wolf startled her, but he seemed so friendly that she soon relaxed."
    , "Grandma's house wasn't far, but it would be rude to ignore the wolf, wouldn't it?"
    ]


realizingMistake : List String
realizingMistake =
    [ "Only then did Little Red Riding Hood remember her mother's warning about not talking to strangers.  That couldn't have done any harm, could it?" ]


happyToSeeGrandma : List String
happyToSeeGrandma =
    [ "Little Red Riding Hood was happy to see her Grandma again." ]


confusedByWolf : List String
confusedByWolf =
    [ "Little Red Riding Hood knew that something was different about Grandma, but she shouldn't quite put her finger on it." ]


forgettingBasket : List String
forgettingBasket =
    [ "Little Red Riding Hood was so focused on her Grandma that she forgot all about the basket of food." ]


shivering : List String
shivering =
    [ "A shiver passed through her body, even though she was wrapped in her warm cape." ]


sharingFoodWithGrandma : List String
sharingFoodWithGrandma =
    [ """
Little Red Riding Hood hefted the basket of food onto her grandma's bed.  "Grandma, look at all of this nice food I brought you!"

"Oh, you are such a good little girl!  Thank you."

And together they ate the goodies she had brought, and everyone lived happily ever after.

![](img/grandma.jpg)
 """ ]
