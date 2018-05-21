module State exposing (init, update, subscriptions)

import OpaqueTypes.Theme as Theme
import RemoteData
import Types exposing (Model, Msg, Tracks)


init : ( Model, Cmd msg )
init =
    ( Model (Tracks RemoteData.NotAsked) Theme.elm, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        Types.ChangeTheme newTheme ->
            ( { model | theme = newTheme }, Cmd.none )

        _ ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
