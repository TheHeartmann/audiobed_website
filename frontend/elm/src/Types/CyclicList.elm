module Types.CyclicList exposing (CyclicList, backward, foldl, foldr, forward, map, reverse, toList)


type alias CyclicList a =
    { previous : List a
    , current : a
    , next : List a
    }


first : { x | previous : List a, current : a } -> a
first { previous, current } =
    List.head previous |> Maybe.withDefault current


last : { x | next : List a, current : a } -> a
last { next, current } =
    List.reverse next |> List.head |> Maybe.withDefault current


nextElement : CyclicList a -> a
nextElement { previous, current, next } =
    List.head next |> Maybe.withDefault (first { previous = previous, current = current })


previousElement : CyclicList a -> a
previousElement { previous, current, next } =
    List.reverse previous |> List.head |> Maybe.withDefault (last { next = next, current = current })


toList : CyclicList a -> List a
toList { previous, current, next } =
    previous ++ [ current ] ++ next


reverse : CyclicList a -> CyclicList a
reverse { previous, current, next } =
    CyclicList (List.reverse next) current (List.reverse previous)


forward : CyclicList a -> CyclicList a
forward list =
    let
        current =
            nextElement list

        ( previous, next ) =
            if List.isEmpty list.previous && List.isEmpty list.next then
                ( [], [] )

            else if List.isEmpty list.next then
                -- we're at the end of the list; cycle around
                ( [], (List.tail list.previous |> Maybe.withDefault []) ++ [ list.current ] )

            else
                ( list.previous ++ [ list.current ], List.tail list.next |> Maybe.withDefault [] )
    in
    CyclicList previous current next


backward : CyclicList a -> CyclicList a
backward list =
    list |> reverse |> forward |> reverse


foldr : (a -> b -> b) -> b -> CyclicList a -> b
foldr func initial cyclicList =
    cyclicList
        |> toList
        |> List.foldr func initial


foldl : (a -> b -> b) -> b -> CyclicList a -> b
foldl func initial cyclicList =
    cyclicList
        |> toList
        |> List.foldl func initial


map : (a -> b) -> CyclicList a -> CyclicList b
map func { previous, current, next } =
    CyclicList (List.map func previous) (func current) (List.map func next)
