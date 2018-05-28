module Types.Theme exposing (Theme, Background, ColorCombination, elm, blueSky, anwar, getBackground, simple)

import Css exposing (hex)
import Css.Colors exposing (..)
import Html.Styled
import Html.Styled.Attributes exposing (css, style)


type Background
    = Color Css.Color
    | Image (Css.BackgroundImage (Css.ListStyle {}))


type alias ColorCombination =
    { background : Background

    -- , headerFont : Css.FontFamily a
    , fontColor : Css.Color
    }


type alias Theme =
    { primary : ColorCombination
    , secondary : ColorCombination
    }


getBackground : Background -> Css.Style
getBackground background =
    case background of
        Color color ->
            Css.backgroundColor color

        Image value ->
            Css.backgroundImage value


elm : Theme
elm =
    let
        elmBlue =
            hex "64B5CB"

        elmYellow =
            hex "EEAC28"
    in
        { primary = { background = Color elmBlue, fontColor = white }
        , secondary = { background = Color elmYellow, fontColor = black }
        }


simple : Theme
simple =
    { primary = { background = Color white, fontColor = black }
    , secondary = { background = Color black, fontColor = white }
    }


anwar : Theme
anwar =
    { primary = { background = Image <| Css.linearGradient2 Css.toBottom (Css.stop <| hex "cbcaa5") (Css.stop <| hex "334d50") [], fontColor = white }
    , secondary = { background = Color <| hex "fff0", fontColor = hex "d5d799" }
    }


blueSky : Theme
blueSky =
    { primary = { background = Image <| Css.linearGradient2 Css.toTop (Css.stop <| hex "FFFFFF") (Css.stop <| hex "6DD5FA") [ (Css.stop <| hex "2980B9") ], fontColor = white }
    , secondary = { background = Color <| hex "fff0", fontColor = black }
    }
