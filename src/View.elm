module View exposing (view)

import Html exposing (..)
import Html.Attributes as Attr
import Svg exposing (..)
import Svg.Attributes as SvgAttr
import Svg.Events as SvgEvent
import Mouse
import Json.Decode as Decode
import Messages as Msg exposing (Msg)
import Models exposing (Model)
import Mouse exposing (Position)
import Date
import Date.Format as DateFormat


view : Model -> Html Msg
view model =
    div
        [ Attr.class "hybridEditor"
        ]
        [ textEditor model
        , visualEditor model
        ]


textEditor : Model -> Html Msg
textEditor model =
    let
        hourNow =
            model |> Date.fromTime |> DateFormat.format "%H"

        minutesNow =
            model |> Date.fromTime |> DateFormat.format "%M"

        secondNow =
            model |> Date.fromTime |> DateFormat.format "%S"
    in
        div
            [ Attr.class "textEditor"
            ]
            [ div
                [ Attr.class "clock"
                ]
                [ input
                    [ Attr.class "time"
                    , Attr.value hourNow
                    , Attr.type_ "number"
                    ]
                    []
                , p [ Attr.class "colon" ]
                    [ Html.text ":" ]
                , input
                    [ Attr.class "time"
                    , Attr.value minutesNow
                    , Attr.type_ "number"
                    ]
                    []
                , p [ Attr.class "colon" ]
                    [ Html.text ":" ]
                , input
                    [ Attr.class "time"
                    , Attr.value secondNow
                    , Attr.type_ "number"
                    ]
                    []
                ]
            ]


visualEditor : Model -> Html Msg
visualEditor model =
    let
        secondNow =
            model |> Date.fromTime |> Date.second

        angleSecond =
            6 * secondNow |> toFloat

        handSecondX =
            toString (50 + 35 * sin (angleSecond * pi / 180))

        handSecondY =
            toString (50 - 35 * cos (angleSecond * pi / 180))
    in
        svg
            [ SvgAttr.viewBox "0 0 100 100"
            , SvgAttr.class "visualEditor"
            ]
        <|
            [ circle [ SvgAttr.cx "50", SvgAttr.cy "50", SvgAttr.r "45", SvgAttr.fill "#2a2a2a" ] []
            , circle [ SvgAttr.cx "50", SvgAttr.cy "50", SvgAttr.r "40", SvgAttr.fill "#f6f6f6" ] []
            , line
                [ SvgAttr.class "sNeedle"
                , SvgAttr.x1 "50"
                , SvgAttr.y1 "50"
                , SvgAttr.x2 handSecondX
                , SvgAttr.y2 handSecondY
                , SvgAttr.stroke "#2a2a2a"
                , SvgAttr.strokeWidth "0.5"
                ]
                []
            ]
