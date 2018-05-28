module Types.NonEmptyList exposing (NonEmptyList, new, append, join)


type alias NonEmptyList a =
    { head : a
    , tail : a
    , contents : List a
    }


new : a -> NonEmptyList a
new a =
    { head = a
    , tail = a
    , contents = [ a ]
    }


append : NonEmptyList a -> a -> NonEmptyList a
append list x =
    { list | tail = x, contents = list.contents ++ [ x ] }


concat : NonEmptyList a -> List a -> NonEmptyList a
concat x y =
    let
        tailElement =
            case (List.reverse >> List.head) y of
                Just z ->
                    z

                Nothing ->
                    x.tail
    in
        { x | tail = tailElement, contents = x.contents ++ y }


join : String -> NonEmptyList String -> String
join sep x =
    String.join sep x.contents
