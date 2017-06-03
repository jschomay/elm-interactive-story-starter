module ClientTypes exposing (..)


type Msg
    = Interact String
    | Loaded


type alias StorySnippet =
    { interactableName : String
    , interactableCssSelector : String
    , narrative : String
    }
