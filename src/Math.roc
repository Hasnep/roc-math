module [exp, reciprocal, naturalLog, sigmoid, relu, sign, signInt]

import Const

## The [natural exponential function](https://en.wikipedia.org/wiki/Exponential_function), the inverse of the [naturalLog] function.
exp : F64 -> F64
exp = \x -> Num.pow Const.e x

expect
    out = exp 0.0
    out |> Num.isApproxEq 1.0 {}

## The [multiplicative inverse function](https://en.wikipedia.org/wiki/Multiplicative_inverse), defined as x⁻¹ = 1/x.
reciprocal : Num * -> F64
reciprocal = \x -> 1 / (Num.toF64 x)

expect
    out = reciprocal 2
    out |> Num.isApproxEq 0.5 {}

# ## logBase
# logBase : Num *, Num * -> F64
# logBase = \x,b -> x

## The [natural logarithm function](https://en.wikipedia.org/wiki/natural_logarithm), the inverse of the [exp] function.
naturalLog : F64 -> F64
naturalLog = Num.log

# ## commonLog
# commonLog
# commonLog = \x -> logBase x 10

## The [standard logistic function](https://en.wikipedia.org/wiki/Logistic_function), defined as S(x) = eˣ / (eˣ + 1).
sigmoid : Num * -> F64
sigmoid = \x ->
    expX = x |> Num.toF64 |> exp
    expX / (expX + 1)

## The [rectified linear unit activation function](https://en.wikipedia.org/wiki/Rectifier_(neural_networks)).
relu : Num a -> Num a
relu = \x -> if Num.isNegative x then 0 else x

expect
    out = [-2, -1, 0, 1, 2] |> List.map relu
    out == [0, 0, 0, 1, 2]

## A variant of the [mathematical sign function](https://en.wikipedia.org/wiki/Sign_function) that handles `NaN` and infinity values.
sign : F64 -> [PositiveNumber, NegativeNumber, Zero, NaN, PositiveInfinity, NegativeInfinity]
sign = \x ->
    if Num.isNaN x then
        NaN
    else if Num.isFinite x then
        if Num.isZero x then
            Zero
        else if Num.isPositive x then
            PositiveNumber
        else
            NegativeNumber
    else if Num.isPositive x then
        PositiveInfinity
    else
        NegativeInfinity

expect sign 1 == PositiveNumber
expect sign -1 == NegativeNumber
expect sign 0 == Zero
expect sign Num.nanF64 == NaN
expect sign Num.infinityF64 == PositiveInfinity
expect sign (-Num.infinityF64) == NegativeInfinity

## The [sign function](https://en.wikipedia.org/wiki/Sign_function) for integers.
##
## For getting the sign of a floating-point number, use the [sign] function instead.
signInt : Int * -> [PositiveNumber, NegativeNumber, Zero]
signInt = \x ->
    if Num.isZero x then
        Zero
    else if Num.isPositive x then
        PositiveNumber
    else
        NegativeNumber

expect signInt 1 == PositiveNumber
expect signInt -1 == NegativeNumber
expect signInt 0 == Zero
