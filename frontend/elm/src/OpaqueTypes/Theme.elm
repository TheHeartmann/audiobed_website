module OpaqueTypes.Theme exposing (Theme, elm, colorful, getBackground, simple)

import Css exposing (hex)
import Css.Colors exposing (..)
import Html.Styled
import Html.Styled.Attributes exposing (css, style)
import OpaqueTypes.RadialGradient as RadialGradient exposing (RadialGradient)


type Background
    = Static Css.Color
    | Radial RadialGradient


type alias Theme =
    { background : Background
    , element : Css.Color
    , elementFont : Css.Color
    , font : Css.Color
    , highlight : Css.Color
    , highlightFont : Css.Color
    }


getBackground : Theme -> ( List ( String, String ), List Css.Style )
getBackground theme =
    case theme.background of
        Static color ->
            ( [], [ Css.backgroundColor color ] )

        Radial color ->
            ( [ RadialGradient.toStyle color ], [] )


elm : Theme
elm =
    let
        elmBlue =
            hex "64B5CB"

        elmYellow =
            hex "EEAC28"
    in
        { background = Static <| white
        , element = elmYellow
        , elementFont = black
        , font = black
        , highlight = elmYellow
        , highlightFont = black
        }


colorful : Theme
colorful =
    { background = Static <| aqua
    , element = yellow
    , elementFont = black
    , font = black
    , highlight = orange
    , highlightFont = white
    }


simple : Theme
simple =
    { background = Static <| white
    , element = black
    , elementFont = white
    , font = black
    , highlight = black
    , highlightFont = white
    }
