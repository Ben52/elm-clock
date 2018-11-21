module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Html exposing (Html, div, h1, img, text)
import Html.Attributes exposing (src)
import Task
import Time exposing (Posix, Zone)



---- MODEL ----


type alias Model =
    { hour : Int
    , minute : Int
    , second : Int
    , zone : Zone
    }


init : ( Model, Cmd Msg )
init =
    ( { hour = 0, minute = 0, second = 0, zone = Time.utc }, Task.perform GotZone Time.here )



---- UPDATE ----


type Msg
    = NewTime Posix
    | GotZone Zone


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewTime posix ->
            let
                hour =
                    Time.toHour model.zone posix

                minute =
                    Time.toMinute model.zone posix

                second =
                    Time.toSecond model.zone posix
            in
            ( { model | hour = hour, minute = minute, second = second }, Cmd.none )

        GotZone zone ->
            ( { model | zone = zone }, Task.perform NewTime Time.now )



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ img [ src "/logo.svg" ] []
        , h1 [] [ text "It is currently" ]
        , h1 [] [ text <| String.fromInt model.hour ++ ":" ++ String.fromInt model.minute ++ ":" ++ String.fromInt model.second ]
        ]



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always (Time.every 1000 NewTime)
        }
