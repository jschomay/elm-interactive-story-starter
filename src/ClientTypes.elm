module ClientTypes exposing (..)


type Route
    = TitlePage
    | GamePage


type Msg
    = Interact Id
    | StartGame
    | Loaded


type alias Id =
    String


type alias RuleData a =
    { a
        | summary : String
        , narrative : Narrative
    }


type alias Attributes =
    { name : String
    , description : String
    , cssSelector : String
    }


type alias Narrative =
    List String


type alias StorySnippet =
    { interactableName : String
    , interactableCssSelector : String
    , narrative : String
    }
