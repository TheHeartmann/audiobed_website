module View exposing (view)

import Css exposing (..)
import FontAwesome exposing (icon, gitHub)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css, class, href, title, style)
import Html.Styled.Events exposing (onClick)
import OpaqueTypes.Theme as Theme exposing (Theme, getBackground)
import Svg
import Svg.Attributes
import SvgIcons as Icons
import Types exposing (Model, Msg)


grid : List ( String, String ) -> List ( String, String )
grid params =
    [ ( "display", "grid" ) ] ++ params


mainGrid : List ( String, String )
mainGrid =
    grid [ ( "grid-template-rows", "1fr 50px" ) ]


view : { a | theme : Theme } -> Html Msg
view { theme } =
    div
        [ style <|
            grid [ ( "grid-template-columns", "1fr 1fr" ) ]
        ]
        [ pageHalf theme Icons.elmSvg
        , pageHalf Theme.simple Icons.rustSvg
        ]


pageHalf : Theme -> Html Msg -> Html Msg
pageHalf theme mainContent =
    let
        ( styleList, cssList ) =
            Theme.getBackground theme
    in
        div
            [ style <| mainGrid ++ styleList
            , css <|
                [ height <| vh 100
                ]
                    ++ cssList
            ]
            [ main_ [ style <| grid [ ( "placeItems", "center" ) ] ] [ mainContent ]
            , footer theme
            ]


footer : { a | highlight : Color, highlightFont : Color } -> Html Msg
footer { highlight, highlightFont } =
    Html.Styled.footer
        [ css
            [ backgroundColor highlight
            , color highlightFont
            , textDecoration none
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
