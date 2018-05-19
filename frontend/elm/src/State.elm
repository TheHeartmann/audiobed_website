module State exposing (init, update, subscriptions)

import RemoteData
import Types exposing (Model, Msg, Tracks)


init : ( Model, Cmd msg )
init =
    ( Model (Tracks RemoteData.NotAsked), Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        _ ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
