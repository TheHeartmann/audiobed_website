module CyclicListTests exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, float, percentage)
import Test exposing (..)
import Types.CyclicList as CyclicList exposing (..)


toList : Test
toList =
    test "It creates correct list representations" <|
        \_ ->
            let
                a =
                    CyclicList [] 1 [ 2, 3 ]

                b =
                    CyclicList [ 1 ] 2 [ 3 ]

                c =
                    CyclicList [ 1, 2 ] 3 []
            in
                Expect.all
                    [ Expect.equal <| CyclicList.toList a
                    , Expect.equal <| CyclicList.toList b
                    , Expect.equal <| CyclicList.toList c
                    ]
                    [ 1, 2, 3 ]


reversing : Test
reversing =
    describe "Reversing"
        [ test "twice gives the original order" <|
            \_ ->
                let
                    list =
                        CyclicList [ 1, 2 ] 3 [ 4, 5 ]
                in
                    Expect.equal (reverse list |> reverse) list
        , test "orders items as expected" <|
            \_ ->
                let
                    list =
                        CyclicList [ 1, 2 ] 3 [ 4, 5 ]
                in
                    Expect.equal (CyclicList [ 5, 4 ] 3 [ 2, 1 ]) (reverse list)
        ]


cycling : Test
cycling =
    describe "Cycling"
        [ describe "General"
            [ test "it handles a single element" <|
                \_ ->
                    let
                        list =
                            CyclicList [] 1 []
                    in
                        Expect.all
                            [ Expect.equal <| forward list
                            , Expect.equal <| backward list
                            ]
                            list
            , test "it handles empty previous list" <|
                \_ ->
                    let
                        list =
                            CyclicList [] 1 [ 2 ]

                        expected =
                            CyclicList [ 1 ] 2 []
                    in
                        Expect.all
                            [ Expect.equal <| forward list
                            , Expect.equal <| backward list
                            ]
                            expected
            , test "it handles empty next list" <|
                \_ ->
                    let
                        list =
                            CyclicList [ 1 ] 2 []

                        expected =
                            CyclicList [] 1 [ 2 ]
                    in
                        Expect.all
                            [ Expect.equal <| forward list
                            , Expect.equal <| backward list
                            ]
                            expected
            ]
        , describe "It cycles backward"
            [ test "with two populated lists" <|
                \_ ->
                    let
                        list =
                            CyclicList [ 1, 2 ] 3 [ 4, 5 ]

                        expected =
                            CyclicList [ 1 ] 2 [ 3, 4, 5 ]
                    in
                        Expect.equal expected (backward list)
            , test "into empty list" <|
                \_ ->
                    let
                        list =
                            CyclicList [ 1 ] 2 [ 3, 4 ]

                        expected =
                            CyclicList [] 1 [ 2, 3, 4 ]
                    in
                        Expect.equal expected (backward list)
            , test "through empty list" <|
                \_ ->
                    let
                        list =
                            CyclicList [] 1 [ 2, 3, 4 ]

                        expected =
                            CyclicList [ 1, 2, 3 ] 4 []
                    in
                        Expect.equal expected (backward list)
            ]
        , describe "Forward motion"
            [ test "it cycles forward" <|
                \_ ->
                    let
                        list =
                            CyclicList [ 1 ] 2 [ 3, 4 ]

                        expected =
                            CyclicList [ 1, 2 ] 3 [ 4 ]
                    in
                        Expect.equal expected (forward list)
            , test "into empty list" <|
                \_ ->
                    let
                        list =
                            CyclicList [ 1, 2 ] 3 [ 4 ]

                        expected =
                            CyclicList [ 1, 2, 3 ] 4 []
                    in
                        Expect.equal expected (forward list)
            , test "through empty list" <|
                \_ ->
                    let
                        list =
                            CyclicList [ 1, 2, 3 ] 4 []

                        expected =
                            CyclicList [] 1 [ 2, 3, 4 ]
                    in
                        Expect.equal expected (forward list)
            ]
        ]


higherOrderFunctions : Test
higherOrderFunctions =
    describe "Higher order functions"
        [ test "It maps" <|
            \_ ->
                let
                    list =
                        CyclicList [] 4 [ 2, 6 ]

                    func =
                        (+) 1
                in
                    Expect.equal (CyclicList [] 5 [ 3, 7 ]) (map func list)
        , test "it folds" <|
            \_ ->
                let
                    list =
                        CyclicList [] 4 [ 2, 6 ]

                    func =
                        (+)

                    initial =
                        0
                in
                    Expect.all
                        [ Expect.equal (foldr func initial list)
                        , Expect.equal (foldl func initial list)
                        ]
                        12
        ]
