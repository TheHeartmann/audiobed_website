module Main exposing (main)

import Html
import Html.Styled exposing (..)
import State
import Types exposing (Model, Msg)
import View


main : Program Never Model Msg
main =
    Html.program
        { init = State.init
        , update = State.update
        , subscriptions = State.subscriptions
        , view = View.view >> toUnstyled
        }
