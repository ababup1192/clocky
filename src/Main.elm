module Main exposing (..)

import Html exposing (program)
import Models exposing (initialModel, Model)
import Messages as Msg exposing (Msg)
import View exposing (view)
import Update exposing (update)
import Task
import Time


init : ( Model, Cmd Msg )
init =
    ( Models.initialModel, now )


now : Cmd Msg
now =
    Task.perform Msg.SetTime Time.now


subscriptions : Model -> Sub Msg
subscriptions _ =
    Time.every Time.second Msg.SetTime


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , subscriptions = always Sub.none

        --  subscriptions
        , update = update
        }
