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


type alias Attributes =
    { name : String
    , description : String
    , cssSelector : String
    }


type alias Narration =
    List String


type alias StorySnippet =
    { interactableName : String
    , interactableCssSelector : String
    , narration : String
    }
