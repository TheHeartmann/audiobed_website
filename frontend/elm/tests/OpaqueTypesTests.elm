module OpaqueTypesTests exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, float, percentage)
import OpaqueTypes.UnitInterval as UnitInterval exposing (..)
import Test exposing (..)


unitIntervalSuite : Test
unitIntervalSuite =
    describe "Testing the UnitInterval works"
        [ describe "Testing output is always between 0 and 1"
            [ fuzz percentage "value is always equal" <|
                \x ->
                    Expect.equal x (UnitInterval.fromFloat x |> UnitInterval.val)
            , fuzz float "Output is always clamped" <|
                \x ->
                    Expect.all [ Expect.atLeast 0, Expect.atMost 1 ] (UnitInterval.fromFloat x |> UnitInterval.val)
            ]
        ]
