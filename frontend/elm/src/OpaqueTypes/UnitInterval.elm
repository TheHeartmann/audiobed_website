module OpaqueTypes.UnitInterval exposing (UnitInterval, fromFloat, val)


type UnitInterval
    = UnitInterval Float


fromFloat : Float -> UnitInterval
fromFloat x =
    UnitInterval (clamp 0 1 x)


val : UnitInterval -> Float
val unitInterval =
    case unitInterval of
        UnitInterval x ->
            x
