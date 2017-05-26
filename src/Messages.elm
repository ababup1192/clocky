module Messages exposing (..)

import Time exposing (Time)
import Models
import Keyboard exposing (KeyCode)


type Msg
    = SetTime Time
    | StartTime
    | HandClick Models.Target
    | CanvasClick
    | KeyDown KeyCode
    | EditHour String
    | EditMinute String
    | EditSecond String
