module Models exposing (..)

import Time exposing (Time)


type alias Model =
    { time : Time
    , target : Target
    , clockMode : Clock
    }


type Target
    = HourHand
    | MinuteHand
    | SecondHand
    | None


type Clock
    = Start
    | Stop


initialModel : Model
initialModel =
    { time = 0.0
    , target = None
    , clockMode = Start
    }
