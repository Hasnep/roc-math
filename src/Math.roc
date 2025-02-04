module [exp, reciprocal, natural_log, sigmoid, relu, sign, sign_int]

import Const

## The [natural exponential function](https://en.wikipedia.org/wiki/Exponential_function), the inverse of the [naturalLog] function.
exp : F64 -> F64
exp = |x| Num.pow(Const.e, x)

expect
    out = exp(0.0)
    out |> Num.is_approx_eq(1.0, {})

## The [multiplicative inverse function](https://en.wikipedia.org/wiki/Multiplicative_inverse), defined as x⁻¹ = 1/x.
reciprocal : Num * -> F64
reciprocal = |x| 1 / (Num.to_f64(x))

expect
    out = reciprocal(2)
    out |> Num.is_approx_eq(0.5, {})

# ## logBase
# logBase : Num *, Num * -> F64
# logBase = \x,b -> x

## The [natural logarithm function](https://en.wikipedia.org/wiki/natural_logarithm), the inverse of the [exp] function.
natural_log : F64 -> F64
natural_log = Num.log

# ## commonLog
# commonLog
# commonLog = \x -> logBase x 10

## The [standard logistic function](https://en.wikipedia.org/wiki/Logistic_function), defined as S(x) = eˣ / (eˣ + 1).
sigmoid : Num * -> F64
sigmoid = |x|
    exp_x = x |> Num.to_f64 |> exp
    exp_x / (exp_x + 1)

## The [rectified linear unit activation](https://en.wikipedia.org/wiki/Rectifier_(neural_networks)) (ReLU) function.
relu : Num a -> Num a
relu = |x| if Num.is_negative(x) then 0 else x

expect
    out = [-2, -1, 0, 1, 2] |> List.map(relu)
    out == [0, 0, 0, 1, 2]

## A variant of the [mathematical sign function](https://en.wikipedia.org/wiki/Sign_function) that handles `NaN` and infinity values.
sign : F64 -> [PositiveNumber, NegativeNumber, Zero, NaN, PositiveInfinity, NegativeInfinity]
sign = |x|
    if Num.is_nan(x) then
        NaN
    else if Num.is_finite(x) then
        if Num.is_zero(x) then
            Zero
        else if Num.is_positive(x) then
            PositiveNumber
        else
            NegativeNumber
    else if Num.is_positive(x) then
        PositiveInfinity
    else
        NegativeInfinity

expect sign(1) == PositiveNumber
expect sign(-1) == NegativeNumber
expect sign(0) == Zero
expect sign(Num.nan_f64) == NaN
expect sign(Num.infinity_f64) == PositiveInfinity
expect sign(-Num.infinity_f64) == NegativeInfinity

## The [sign function](https://en.wikipedia.org/wiki/Sign_function) for integers.
##
## For getting the sign of a floating-point number, use the [sign] function instead.
sign_int : Int * -> [PositiveNumber, NegativeNumber, Zero]
sign_int = |x|
    if Num.is_zero(x) then
        Zero
    else if Num.is_positive(x) then
        PositiveNumber
    else
        NegativeNumber

expect sign_int(1) == PositiveNumber
expect sign_int(-1) == NegativeNumber
expect sign_int(0) == Zero
