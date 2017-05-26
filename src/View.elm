module View exposing (view)

import Html exposing (..)
import Html.Attributes as Attr
import Html.Events as HtmlEvent
import Svg exposing (..)
import Svg.Attributes as SvgAttr
import Svg.Events as SvgEvent
import Mouse
import Json.Decode as Json
import Messages as Msg exposing (Msg)
import Models exposing (Model)
import Mouse exposing (Position)
import Date
import Date.Format as DateFormat
import VirtualDom


view : Model -> Html Msg
view model =
    div
        [ Attr.class "hybridEditor"
        ]
        [ textEditor model
        , visualEditor model
        ]


textEditor : Model -> Html Msg
textEditor { time, target } =
    let
        hourStr =
            time |> Date.fromTime |> DateFormat.format "%H"

        minuteStr =
            time |> Date.fromTime |> DateFormat.format "%M"

        secondStr =
            time |> Date.fromTime |> DateFormat.format "%S"

        hourStrColor =
            if target == Models.HourHand then
                "#ff9900"
            else
                "#2a2a2a"

        minuteStrColor =
            if target == Models.MinuteHand then
                "#ff9900"
            else
                "#2a2a2a"

        secondStrColor =
            if target == Models.SecondHand then
                "#ff9900"
            else
                "#2a2a2a"
    in
        div
            [ Attr.class "textEditor"
            ]
            [ div
                [ Attr.class "clock"
                ]
                [ input
                    [ HtmlEvent.onInput Msg.EditHour
                    , Attr.class "time"
                    , Attr.value hourStr
                    , Attr.type_ "number"
                    , Attr.style
                        [ ( "color", hourStrColor )
                        ]
                    ]
                    []
                , p [ Attr.class "colon" ]
                    [ Html.text ":" ]
                , input
                    [ HtmlEvent.onInput Msg.EditMinute
                    , Attr.class "time"
                    , Attr.value minuteStr
                    , Attr.type_ "number"
                    , Attr.style
                        [ ( "color", minuteStrColor )
                        ]
                    ]
                    []
                , p [ Attr.class "colon" ]
                    [ Html.text ":" ]
                , input
                    [ HtmlEvent.onInput Msg.EditSecond
                    , Attr.class "time"
                    , Attr.value secondStr
                    , Attr.type_ "number"
                    , Attr.style
                        [ ( "color", secondStrColor )
                        ]
                    ]
                    []
                ]
            ]


visualEditor : Model -> Html Msg
visualEditor { time, target } =
    let
        hourNow =
            time |> Date.fromTime |> Date.hour

        minuteNow =
            time |> Date.fromTime |> Date.minute

        secondNow =
            time |> Date.fromTime |> Date.second

        angleHour =
            30 * hourNow |> toFloat

        angleMinute =
            6 * minuteNow |> toFloat

        angleSecond =
            6 * secondNow |> toFloat

        handHourX =
            toString (50 + 35 * sin (angleHour * pi / 180))

        handHourY =
            toString (50 - 35 * cos (angleHour * pi / 180))

        handMinuteX =
            toString (50 + 35 * sin (angleMinute * pi / 180))

        handMinuteY =
            toString (50 - 35 * cos (angleMinute * pi / 180))

        handSecondX =
            toString (50 + 35 * sin (angleSecond * pi / 180))

        handSecondY =
            toString (50 - 35 * cos (angleSecond * pi / 180))

        hourHandColor =
            if target == Models.HourHand then
                "#ff9900"
            else
                "#2a2a2a"

        minuteHandColor =
            if target == Models.MinuteHand then
                "#ff9900"
            else
                "#2a2a2a"

        secondHandColor =
            if target == Models.SecondHand then
                "#ff9900"
            else
                "#2a2a2a"
    in
        svg
            [ SvgEvent.onClick <| Msg.CanvasClick
            , SvgAttr.viewBox "0 0 100 100"
            , SvgAttr.class "visualEditor"
            ]
        <|
            [ circle [ SvgAttr.cx "50", SvgAttr.cy "50", SvgAttr.r "45", SvgAttr.fill "#2a2a2a" ] []
            , circle [ SvgAttr.cx "50", SvgAttr.cy "50", SvgAttr.r "40", SvgAttr.fill "#f6f6f6" ] []
            , line
                [ VirtualDom.onWithOptions "click"
                    { stopPropagation = True, preventDefault = False }
                    (Json.map (\_ -> Msg.HandClick Models.HourHand) Mouse.position)
                , SvgAttr.class "hand"
                , SvgAttr.x1 "50"
                , SvgAttr.y1 "50"
                , SvgAttr.x2 handHourX
                , SvgAttr.y2 handHourY
                , SvgAttr.stroke hourHandColor
                , SvgAttr.strokeWidth "2"
                ]
                []
            , line
                [ VirtualDom.onWithOptions "click"
                    { stopPropagation = True, preventDefault = False }
                    (Json.map (\_ -> Msg.HandClick Models.MinuteHand) Mouse.position)
                , SvgAttr.class "hand"
                , SvgAttr.x1 "50"
                , SvgAttr.y1 "50"
                , SvgAttr.x2 handMinuteX
                , SvgAttr.y2 handMinuteY
                , SvgAttr.stroke minuteHandColor
                , SvgAttr.strokeWidth "1"
                ]
                []
            , line
                [ VirtualDom.onWithOptions "click"
                    { stopPropagation = True, preventDefault = False }
                    (Json.map (\_ -> Msg.HandClick Models.SecondHand) Mouse.position)
                , SvgAttr.class "hand"
                , SvgAttr.x1 "50"
                , SvgAttr.y1 "50"
                , SvgAttr.x2 handSecondX
                , SvgAttr.y2 handSecondY
                , SvgAttr.stroke secondHandColor
                , SvgAttr.strokeWidth "0.5"
                ]
                []
            ]
