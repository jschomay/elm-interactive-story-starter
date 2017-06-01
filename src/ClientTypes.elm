module ClientTypes exposing (..)

import Dict exposing (Dict)


type Msg
    = Interact String
    | Loaded


type alias RuleData a =
    { a
        | summary : String
        , narrative : Narrative
    }


type alias Narrative =
    List String


type alias StorySnippet =
    { interactableName : String
    , interactableCssSelector : String
    , narrative : String
    }
