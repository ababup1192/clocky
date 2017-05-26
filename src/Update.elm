module Update exposing (..)

import Models exposing (Model)
import Messages as Msg exposing (Msg)
import Time
import Date


update : Msg -> Model -> ( Model, Cmd Msg )
update msg ({ target, time, clockMode } as model) =
    let
        oldHour =
            Time.hour * (time |> Date.fromTime |> Date.hour |> toFloat)

        oldMinute =
            Time.minute * (time |> Date.fromTime |> Date.minute |> toFloat)

        oldSecond =
            Time.second * (time |> Date.fromTime |> Date.second |> toFloat)
    in
        case msg of
            Msg.SetTime time ->
                ( { model | time = time }, Cmd.none )

            Msg.StartTime ->
                ( { model | time = time + Time.second }, Cmd.none )

            Msg.EditHour hourStr ->
                let
                    hour =
                        Result.withDefault oldHour <| String.toFloat hourStr

                    newHour =
                        if hour < 0 || hour > 24 then
                            oldHour
                        else
                            Time.hour * hour

                    newTime =
                        (Time.hour * 15) + newHour + oldMinute + oldSecond
                in
                    ( { model | time = newTime }, Cmd.none )

            Msg.EditMinute minuteStr ->
                let
                    minute =
                        Result.withDefault oldMinute <| String.toFloat minuteStr

                    newMinute =
                        if minute < 0 || minute > 60 then
                            oldHour
                        else
                            Time.minute * minute

                    newTime =
                        (Time.hour * 15) + oldHour + newMinute + oldSecond
                in
                    ( { model | time = newTime }, Cmd.none )

            Msg.EditSecond secondStr ->
                let
                    second =
                        Result.withDefault oldSecond <| String.toFloat secondStr

                    newSecond =
                        if second < 0 || second > 60 then
                            oldHour
                        else
                            Time.second * second

                    newTime =
                        (Time.hour * 15) + oldHour + oldMinute + newSecond
                in
                    ( { model | time = newTime }, Cmd.none )

            Msg.HandClick target ->
                ( { model | target = target }, Cmd.none )

            Msg.CanvasClick ->
                let
                    newClockMode =
                        if clockMode == Models.Start then
                            Models.Stop
                        else
                            Models.Start
                in
                    ( { model | target = Models.None, clockMode = newClockMode }, Cmd.none )

            Msg.KeyDown code ->
                let
                    diffHour =
                        if target == Models.HourHand && code == 39 then
                            Time.hour
                        else if target == Models.HourHand && code == 37 then
                            negate Time.hour
                        else
                            0.0

                    diffMinute =
                        if target == Models.MinuteHand && code == 39 then
                            Time.minute
                        else if target == Models.MinuteHand && code == 37 then
                            negate Time.minute
                        else
                            0.0

                    diffSecond =
                        if target == Models.SecondHand && code == 39 then
                            Time.second
                        else if target == Models.SecondHand && code == 37 then
                            negate Time.second
                        else
                            0.0

                    diff =
                        diffHour + diffMinute + diffSecond
                in
                    ( { model | time = time + diff }, Cmd.none )
