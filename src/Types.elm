module Types exposing (..)

import Dict exposing (Dict)
import NarrativeEngine.Core.Rules as Rules
import NarrativeEngine.Core.WorldModel as WorldModel
import NarrativeEngine.Debug



-- You can add fields to the model here


type alias Model =
    { worldModel : WorldModel
    , rules : Rules
    , started : Bool
    , story : String
    , ruleCounts : Dict String Int
    , debug : NarrativeEngine.Debug.State
    , showDebug : Bool
    }



-- You can add more messages here


type Msg
    = InteractWith WorldModel.ID
    | UpdateDebugSearchText String
    | AddEntities WorldModel
    | AddRules Rules



-- flats used upon init


type alias Flags =
    { showDebug : Bool }



-- set up entity types with extra name and description fields


type alias ExtraEntityFields =
    { name : String
    , description : String
    }


type alias Entity =
    WorldModel.NarrativeComponent ExtraEntityFields


type alias WorldModel =
    Dict WorldModel.ID Entity



-- set up rule types with extra narrative field


type alias ExtraRuleFields =
    { narrative : String }


type alias Rule =
    Rules.Rule ExtraRuleFields


type alias Rules =
    Dict String Rule
