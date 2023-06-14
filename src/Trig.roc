interface Trig
    exposes [sin, asin, cos, acos, tan, atan, sinh, cosh, tanh, coth, sech, csch]
    imports [Math.{ exp }, Utils.{ isApproxEq }]

## Trigonometric functions

## The sine function of a an angle in radians.
##
## See [Wikipedia](https://en.wikipedia.org/wiki/Sine_and_cosine) for more information.
sin : Frac a -> Frac a
sin = Num.sin

# ## A version of the [sin] function that works with angles in degrees.
# sinDeg : Frac a -> Frac a
# sinDeg = \θ -> θ |> radiansToDegrees |> sin

# expect
#     out = sinDeg 90.0
#     out |> isApproxEq 1.0

##
asin : Frac a -> Frac a
asin = Num.asin

## The cosine function of a an angle in radians.
##
## See [Wikipedia](https://en.wikipedia.org/wiki/Sine_and_cosine) for more information.
cos : Frac a -> Frac a
cos = Num.cos

# ## A version of the [cos] function that works with angles in degrees.
# cosDeg : Frac a -> Frac a
# cosDeg = \θ -> θ |> radiansToDegrees |> cos

# expect
#     out = cosDeg 0.0
#     out |> isApproxEq 1.0

##
acos : Frac a -> Frac a
acos = Num.acos

## The tangent function of a an angle in radians.
##
## See [Wikipedia](https://en.wikipedia.org/wiki/Trigonometric_functions) for more information.
tan : Frac a -> Frac a
tan = Num.tan

# ## A version of the [tan] function that works with angles in degrees.
# tanDeg : Frac a -> Frac a
# tanDeg = \θ -> θ |> radiansToDegrees |> tan

# expect
#     out = tanDeg 45
#     out |> isApproxEq 1.0

##
atan : Frac a -> Frac a
atan = Num.atan

# Hyperbolic trigonometry functions

## The hyperbolic sine function.
##
## See [Wikipedia](https://en.wikipedia.org/wiki/Hyperbolic_functions) for more information.
sinh : F64 -> F64
sinh = \θ -> ((exp θ) - (exp (-θ))) / 2

expect
    out = sinh (Num.log 2)
    out |> isApproxEq (3 / 4)

## The hyperbolic cosine function.
##
## See [Wikipedia](https://en.wikipedia.org/wiki/Hyperbolic_functions) for more information.
cosh : F64 -> F64
cosh = \θ -> ((exp θ) + (exp (-θ))) / 2

expect
    out = cosh (Num.log 2)
    out |> isApproxEq (5 / 4)

## The hyperbolic tangent function.
##
## See [Wikipedia](https://en.wikipedia.org/wiki/Hyperbolic_functions) for more information.
tanh : F64 -> F64
tanh = \θ -> (exp (2.0 * θ) - 1) / (exp (2.0 * θ) + 1)

expect
    out = tanh (Num.log 2)
    out |> isApproxEq (3 / 5)

## The hyperbolic cotangent function.
##
## See [Wikipedia](https://en.wikipedia.org/wiki/Hyperbolic_functions) for more information.
coth : F64 -> F64
coth = \θ -> 1 / (tanh θ)

expect
    out = coth (Num.log 2)
    out |> isApproxEq (5 / 3)

## The hyperbolic secant function.
##
## See [Wikipedia](https://en.wikipedia.org/wiki/Hyperbolic_functions) for more information.
sech : F64 -> F64
sech = \θ -> 1 / (cosh θ)

expect
    out = sech (Num.log 2)
    out |> isApproxEq (4 / 5)

## The hyperbolic cosecant function.
##
## See [Wikipedia](https://en.wikipedia.org/wiki/Hyperbolic_functions) for more information.
csch : F64 -> F64
csch = \θ -> 1 / (sinh θ)

expect
    out = csch (Num.log 2)
    out |> isApproxEq (4 / 3)

# # Utils
# radiansToDegrees : Num * -> F64
# radiansToDegrees = \θ -> θ |> Num.toF64 |> Num.div Const.pi |> Num.mul 180.0
