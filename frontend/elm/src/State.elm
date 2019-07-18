module State exposing (init, subscriptions, update)

import Char
import Dict exposing (Dict)
import Keyboard
import RemoteData
import Types exposing (KeyDownMsg(..), Model, Msg(..), Tracks)
import Types.CyclicList as CyclicList exposing (CyclicList)
import Types.Theme as Theme exposing (Theme)


themes : CyclicList Theme
themes =
    CyclicList [] Theme.blueSky [ Theme.anwar, Theme.simple ]


tracks : Tracks
tracks =
    Tracks RemoteData.NotAsked


init : ( Model, Cmd msg )
init =
    ( Model tracks themes, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        KeyDown key ->
            ( handleKeyDownEvent key model, Cmd.none )


handleKeyDownEvent : Char -> { model | themes : CyclicList Theme } -> { model | themes : CyclicList Theme }
handleKeyDownEvent key model =
    case Dict.get key Types.keyEvents of
        Just msg ->
            performKeyDownAction msg model

        Nothing ->
            model


performKeyDownAction : KeyDownMsg -> { model | themes : CyclicList Theme } -> { model | themes : CyclicList Theme }
performKeyDownAction msg model =
    case msg of
        CycleThemeForward ->
            { model | themes = CyclicList.forward model.themes }

        CycleThemeBackward ->
            { model | themes = CyclicList.backward model.themes }


subscriptions : Model -> Sub Msg
subscriptions _ =
    Keyboard.downs <| Char.fromCode >> KeyDown
