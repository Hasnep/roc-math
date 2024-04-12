interface Math
    exposes [exp, reciprocal, naturalLog, sigmoid, relu]
    imports [Utils.{ isApproxEq }, Const]

## The natural exponential function, the inverse of the [naturalLog] function.
##
## See [Wikipedia](https://en.wikipedia.org/wiki/Exponential_function) for more information.
exp : F64 -> F64
exp = \x -> Num.pow Const.e x

expect
    out = exp 0.0
    out |> isApproxEq 1.0

## The multiplicative inverse function, defined as x⁻¹ = 1/x.
##
## See [Wikipedia](https://en.wikipedia.org/wiki/Multiplicative_inverse) for more information.
reciprocal : Num * -> F64
reciprocal = \x -> 1 / (Num.toF64 x)

expect
    out = reciprocal 2
    out |> isApproxEq 0.5

# ## logBase
# logBase : Num *, Num * -> F64
# logBase = \x,b -> x

## The natural logarithm function, the inverse of the [exp] function.
##
## See [Wikipedia](https://en.wikipedia.org/wiki/Natural_logarithm) for more information.
naturalLog = Num.log

# ## commonLog
# commonLog
# commonLog = \x -> logBase x 10

## The standard logistic function, defined as S(x) = eˣ / (eˣ + 1).
##
## See [Wikipedia](https://en.wikipedia.org/wiki/Logistic_function) for more information.
sigmoid : Num * -> F64
sigmoid = \x ->
    expX = x |> Num.toF64 |> exp
    expX / (expX + 1)

## The rectified linear unit activation function.
##
## See [Wikipedia](https://en.wikipedia.org/wiki/Rectifier_(neural_networks)) for more information.
relu : Num a -> Num a
relu = \x -> if Num.isNegative x then 0 else x

expect
    out = [-2, -1, 0, 1, 2] |> List.map relu
    out == [0, 0, 0, 1, 2]
