module View exposing (view)

import Css exposing (..)
import Css.Colors exposing (..)
import FontAwesome exposing (icon, gitHub)
import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css, class, href, title)
import Html.Styled.Events exposing (onClick)
import Types exposing (Model, Msg)


view : Model -> Html Msg
view _ =
    div
        [ class "main-grid"
        , css
            [ height <| vh 100
            , backgroundColor <| hex "2C3330"
            ]
        ]
        [ main_ [] [ div [] [] ]
        , footer
        ]


footer : Html Msg
footer =
    Html.Styled.footer
        [ css
            [ backgroundColor <| hex "dddddd80"
            , displayFlex
            , justifyContent center
            , alignItems center
            , fontSize <| px 30
            ]
        ]
        [ a
            [ href "https://github.com/TheHeartmann/audiobed_website"
            , title "Visit us on Github"
            ]
            [ styledIcon gitHub ]
        ]


styledIcon : FontAwesome.Icon -> Html Msg
styledIcon x =
    icon x |> fromUnstyled
