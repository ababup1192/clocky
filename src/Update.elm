module Update exposing (..)

import Models exposing (Model)
import Messages as Msg exposing (Msg)


update : Msg -> Model -> ( Model, Cmd Msg )
update (Msg.SetTime time) _ =
    ( time, Cmd.none )
