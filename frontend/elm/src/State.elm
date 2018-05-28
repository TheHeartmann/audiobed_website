module State exposing (init, update, subscriptions)

import Char
import Dict exposing (Dict)
import Keyboard
import RemoteData
import Types exposing (Model, Msg(..), Tracks, KeyDownMsg(..))
import Types.CyclicList as CyclicList exposing (CyclicList)
import Types.Theme as Theme exposing (Theme)


themes : CyclicList Theme
themes =
    CyclicList [] Theme.anwar [ Theme.blueSky, Theme.simple ]


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
            case Dict.get key Types.keyEvents of
                Just msg ->
                    ( handleKeyDownEvent msg model, Cmd.none )

                Nothing ->
                    ( model, Cmd.none )


handleKeyDownEvent : KeyDownMsg -> Model -> Model
handleKeyDownEvent msg model =
    case msg of
        CycleThemeForward ->
            { model | themes = CyclicList.forward model.themes }

        CycleThemeBackward ->
            { model | themes = CyclicList.backward model.themes }


subscriptions : Model -> Sub Msg
subscriptions model =
    Keyboard.downs (\x -> KeyDown <| Char.fromCode x)
