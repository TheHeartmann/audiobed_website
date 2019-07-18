module Types.UnitInterval exposing (UnitInterval, fromFloat, val)


type UnitInterval
    = UnitInterval Float


fromFloat : Float -> UnitInterval
fromFloat x =
    UnitInterval (clamp 0 1 x)


val : UnitInterval -> Float
val (UnitInterval x) = x
