module View exposing (view)

import Html exposing (Html, main_, h1, text)
import Types exposing (Model, Msg)


view : Model -> Html Msg
view _ =
    main_ []
        [ h1 [] [ text "This is only the beginning." ]
        ]
