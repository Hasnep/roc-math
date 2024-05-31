module [unwrap, square, xor]

unwrap : Result a b, Str -> a
unwrap = \result, message ->
    when result is
        Ok x -> x
        Err _ -> crash message

square : Num * -> F64
square = \x -> x |> Num.toF64 |> Num.pow 2

xor : Bool, Bool -> Bool
xor = \a, b -> a != b
