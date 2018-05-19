module Example exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)


suite : Test
suite =
    describe "Getting familiar with elm-test"
        [ describe "Testing String.reverse"
            [ test "has no effect on palindromes" <|
                \_ ->
                    let
                        palindrome =
                            "otto"
                    in
                        Expect.equal palindrome (String.reverse palindrome)
            , test "reverses a known string" <|
                \_ ->
                    "789456"
                        |> String.reverse
                        |> Expect.equal "654987"
            , fuzz string "running it twice returns the original" <|
                \generated ->
                    generated
                        |> String.reverse
                        |> String.reverse
                        |> Expect.equal generated
            ]
        ]
