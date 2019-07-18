module Types.RadialGradient exposing (RadialGradient, toStyle)

import Types.NonEmptyList as NonEmptyList exposing (NonEmptyList)


type Extent
    = ClosestSide
    | ClosestCorner
    | FarthestSide
    | FarthestCorner


extentToString : Extent -> String
extentToString x =
    case x of
        ClosestSide ->
            "closest-side"

        ClosestCorner ->
            "closest-corner"

        FarthestSide ->
            "farthest-side"

        FarthestCorner ->
            "farthest-corner"


type Shape
    = Circle
    | Ellipse


shapeToString : Shape -> String
shapeToString x =
    case x of
        Circle ->
            "circle"

        Ellipse ->
            "ellipse"


type Position
    = Pixels Int Int
    | Percentage Int Int


positionToString : Position -> String
positionToString pos =
    let
        val =
            case pos of
                Pixels x y ->
                    "top " ++ toString x ++ "px" ++ " left " ++ toString y ++ "px"

                Percentage x y ->
                    toString x ++ "% " ++ toString y ++ "%"
    in
    "at " ++ val


type alias RadialGradient =
    { colorStops : NonEmptyList String
    , position : Position
    , shape : Maybe Shape
    , extent : Maybe Extent
    }


toStyle : RadialGradient -> ( String, String )
toStyle { colorStops, position, shape, extent } =
    let
        colors =
            NonEmptyList.join " " colorStops

        pos =
            positionToString position

        s =
            case shape of
                Just s ->
                    shapeToString s

                Nothing ->
                    ""

        ext =
            case extent of
                Just e ->
                    extentToString e

                Nothing ->
                    ""

        vals =
            [ colors ]
                |> (++) [ String.join " " [ s, ext, pos ] ]
                |> String.join ", "

        string =
            "radial-gradient(" ++ vals ++ ")"
    in
    ( "background", s )
