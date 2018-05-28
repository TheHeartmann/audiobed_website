module View exposing (view)

import Css exposing (..)
import FontAwesome exposing (icon, gitHub)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css, class, href, title, style)
import Html.Styled.Events exposing (onClick)
import Svg
import Svg.Attributes
import SvgIcons as Icons
import Types exposing (Model, Msg)
import Types.CyclicList as CyclicList exposing (CyclicList)
import Types.Theme as Theme exposing (Theme, getBackground)


grid : List ( String, String ) -> List ( String, String )
grid params =
    [ ( "display", "grid" ) ] ++ params


mainGrid : List ( String, String )
mainGrid =
    grid [ ( "grid-template-rows", "1fr 50px" ) ]


view : { a | themes : CyclicList Theme } -> Html Msg
view { themes } =
    let
        theme =
            themes.current

        backgroundTheme =
            Theme.getBackground theme.primary.background
    in
        div
            [ style <| mainGrid
            , css <|
                [ height <| vh 100
                , backgroundTheme
                , fontFamilies [ "Satisfy" ]
                ]
            ]
            [ main_ [ style <| grid [ ( "placeItems", "center" ) ] ] [ h1 [ css <| [ color theme.primary.fontColor ] ] [ text "Audiobed" ] ]
            , footer theme.secondary
            ]


footer : { background : Theme.Background, fontColor : Color } -> Html Msg
footer { background, fontColor } =
    Html.Styled.footer
        [ css
            [ Theme.getBackground background
            , displayFlex
            , justifyContent center
            , alignItems center
            , fontSize <| px 30
            ]
        ]
        [ a
            [ href "https://github.com/TheHeartmann/audiobed_website"
            , title "Visit us on Github"
            , css
                [ color fontColor
                , textDecoration none
                ]
            ]
            [ styledIcon gitHub ]
        ]


styledIcon : FontAwesome.Icon -> Html Msg
styledIcon x =
    icon x |> fromUnstyled
