module ClientTypes exposing (..)

import Dict exposing (Dict)


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


type alias Narrative =
    List String


type alias StorySnippet =
    { interactableName : String
    , interactableCssSelector : String
    , narrative : String
    }


type alias Components =
    Dict String Component


type Component
    = Display { name : String, description : String }
    | Style String


type alias Entity =
    { id : String
    , components : Components
    }
