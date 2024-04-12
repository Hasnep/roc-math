interface Utils exposes [isApproxEq, allApproxEq, unwrap, square] imports []

identity = \x -> x

unwrap = \result, message ->
    when result is
        Ok x -> x
        Err _ -> crash message

max = \x, y ->
    [x, y]
    |> List.max
    |> unwrap "This can never happen because the list is always non-empty."

## Check if two numbers are approximately equal.
##
## Two non-zero numbers `x` and `y` are approximately equal if `x` and `y` are both in the interval `(-0.01, 0.01)` or if `abs(x - y) <= 0.01 * max(abs(x), abs(y))`.
isApproxEq : Frac a, Frac a -> Bool
isApproxEq = \x, y ->
    xIsCloseToZero = x |> Num.abs |> Num.isLt 0.01
    yIsCloseToZero = y |> Num.abs |> Num.isLt 0.01
    if xIsCloseToZero && yIsCloseToZero then
        Bool.true
    else if xIsCloseToZero && yIsCloseToZero then
        Bool.false
    else
        tolerance = 0.01 * (max (Num.abs x) (Num.abs y))
        (x - y) |> Num.abs |> Num.isLte tolerance

allApproxEq = \xs, ys ->
    sameLength = (List.len xs) == (List.len ys)
    allEqual = (List.map2 xs ys isApproxEq |> List.all identity)
    sameLength && allEqual

square = \x -> x |> Num.toF64 |> Num.pow 2
