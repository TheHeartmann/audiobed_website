module State exposing (init, update, subscriptions)

import RemoteData
import Types exposing (Model, Msg, Tracks)
import Types.Theme as Theme


init : ( Model, Cmd msg )
init =
    ( Model (Tracks RemoteData.NotAsked) Theme.anwar, Cmd.none )


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
