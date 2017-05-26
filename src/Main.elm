module Main exposing (..)

import Html exposing (program)
import Models exposing (initialModel, Model)
import Messages as Msg exposing (Msg)
import View exposing (view)
import Update exposing (update)
import Task
import Time
import Keyboard


init : ( Model, Cmd Msg )
init =
    ( Models.initialModel, now )


now : Cmd Msg
now =
    Task.perform Msg.SetTime Time.now


subscriptions : Model -> Sub Msg
subscriptions { clockMode } =
    if clockMode == Models.Start then
        Sub.batch
            [ Time.every Time.second <| always Msg.StartTime
            , Keyboard.downs Msg.KeyDown
            ]
    else
        Sub.batch
            [ Keyboard.downs Msg.KeyDown
            ]


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , subscriptions = subscriptions
        , update = update
        }
