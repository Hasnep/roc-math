module [
    sin,
    cos,
    tan,
    asin,
    acos,
    atan,
    sinh,
    cosh,
    tanh,
    coth,
    sech,
    csch,
]

import Angle exposing [Angle]
import Math exposing [exp]
import Const

## The [sine](https://en.wikipedia.org/wiki/Sine_and_cosine) of an angle.
sin : Angle -> F64
sin = \angle ->
    (Radians θ) = Angle.toRadians angle
    Num.sin θ

expect
    out = sin (Radians (Const.pi / 2))
    out |> Num.isApproxEq 1.0 {}

expect
    out = sin (Degrees 90.0)
    out |> Num.isApproxEq 1.0 {}

expect
    out = sin (Turns 0.25)
    out |> Num.isApproxEq 1.0 {}

expect
    out = sin (Gon 100.0)
    out |> Num.isApproxEq 1.0 {}

## The [cosine](https://en.wikipedia.org/wiki/Sine_and_cosine) of an angle.
cos : Angle -> F64
cos = \angle ->
    (Radians θ) = Angle.toRadians angle
    Num.cos θ

expect
    out = cos (Radians 0.0)
    out |> Num.isApproxEq 1.0 {}

expect
    out = cos (Degrees 0.0)
    out |> Num.isApproxEq 1.0 {}

expect
    out = cos (Turns 0.0)
    out |> Num.isApproxEq 1.0 {}

expect
    out = cos (Gon 0.0)
    out |> Num.isApproxEq 1.0 {}

## The [tangent](https://en.wikipedia.org/wiki/Trigonometric_functions) of an angle.
tan : Angle -> F64
tan = \angle ->
    (Radians θ) = Angle.toRadians angle
    Num.tan θ

expect
    out = tan (Radians (Const.pi / 4))
    out |> Num.isApproxEq 1.0 {}

expect
    out = tan (Degrees 45.0)
    out |> Num.isApproxEq 1.0 {}

expect
    out = tan (Turns (1 / 8))
    out |> Num.isApproxEq 1.0 {}

expect
    out = tan (Gon 50.0)
    out |> Num.isApproxEq 1.0 {}

# Inverse trigonometry functions

## The [arcsine](https://en.wikipedia.org/wiki/Sine_and_cosine#Inverses) of a number.
##
## Silently returns `NaN` if the input is outside the range `[-1, 1]`.
asin : F64, [ToRadians, ToDegrees, ToTurns, ToGon] -> Angle
asin = \x, convert ->
    angle = Radians (Num.asin x)
    when convert is
        ToRadians -> angle
        ToDegrees -> Angle.toDegrees angle
        ToTurns -> Angle.toTurns angle
        ToGon -> Angle.toGon angle

expect
    out = asin 1.0 ToRadians
    out |> Angle.isApproxEq (Radians (Const.pi / 2)) {}

expect
    out = asin 1.0 ToDegrees
    out |> Angle.isApproxEq (Degrees 90.0) {}

expect
    out = asin 1.0 ToTurns
    out |> Angle.isApproxEq (Turns 0.25) {}

expect
    out = asin 1.0 ToGon
    out |> Angle.isApproxEq (Gon 100.0) {}

expect
    out = asin 2.0 ToRadians
    Angle.isNaN out

## The [arccosine](https://en.wikipedia.org/wiki/Sine_and_cosine#Inverses) of a number.
##
## Silently returns `NaN` if the input is outside the range `[-1, 1]`.
acos : F64, [ToRadians, ToDegrees, ToTurns, ToGon] -> Angle
acos = \x, convert ->
    angle = Radians (Num.acos x)
    when convert is
        ToRadians -> angle
        ToDegrees -> Angle.toDegrees angle
        ToTurns -> Angle.toTurns angle
        ToGon -> Angle.toGon angle

expect
    out = acos 1.0 ToRadians
    out |> Angle.isApproxEq (Radians 0.0) {}

expect
    out = acos 1.0 ToDegrees
    out |> Angle.isApproxEq (Degrees 0.0) {}

expect
    out = acos 1.0 ToTurns
    out |> Angle.isApproxEq (Turns 0.0) {}

expect
    out = acos 1.0 ToGon
    out |> Angle.isApproxEq (Gon 0.0) {}

expect
    out = acos 2.0 ToRadians
    Angle.isNaN out

## The [arctangent](https://en.wikipedia.org/wiki/Trigonometric_functions#Inverses) of a number.
atan : F64, [ToRadians, ToDegrees, ToTurns, ToGon] -> Angle
atan = \x, convert ->
    angle = Radians (Num.atan x)
    when convert is
        ToRadians -> angle
        ToDegrees -> Angle.toDegrees angle
        ToTurns -> Angle.toTurns angle
        ToGon -> Angle.toGon angle

expect
    out = atan 1.0 ToRadians
    out |> Angle.isApproxEq (Radians (Const.pi / 4)) {}

expect
    out = atan 1.0 ToDegrees
    out |> Angle.isApproxEq (Degrees 45.0) {}

expect
    out = atan 1.0 ToTurns
    out |> Angle.isApproxEq (Turns (1 / 8)) {}

expect
    out = atan 1.0 ToGon
    out |> Angle.isApproxEq (Gon 50.0) {}

# Hyperbolic trigonometry functions

## The [hyperbolic sine](https://en.wikipedia.org/wiki/Hyperbolic_functions).
sinh : F64 -> F64
sinh = \x -> ((exp x) - (exp (-x))) / 2

expect
    out = sinh (Num.log 2)
    out |> Num.isApproxEq (3 / 4) {}

## The [hyperbolic cosine](https://en.wikipedia.org/wiki/Hyperbolic_functions).
cosh : F64 -> F64
cosh = \x -> ((exp x) + (exp (-x))) / 2

expect
    out = cosh (Num.log (Num.toF64 2))
    out |> Num.isApproxEq (5 / 4) {}

## The [hyperbolic tangent](https://en.wikipedia.org/wiki/Hyperbolic_functions).
tanh : F64 -> F64
tanh = \x -> (exp (2.0 * x) - 1) / (exp (2.0 * x) + 1)

expect
    out = tanh (Num.log (Num.toF64 2))
    out |> Num.isApproxEq (3 / 5) {}

## The [hyperbolic cotangent](https://en.wikipedia.org/wiki/Hyperbolic_functions).
coth : F64 -> F64
coth = \x -> 1 / (tanh x)

expect
    out = coth (Num.log (Num.toF64 2))
    out |> Num.isApproxEq (5 / 3) {}

## The [hyperbolic secant](https://en.wikipedia.org/wiki/Hyperbolic_functions).
sech : F64 -> F64
sech = \x -> 1 / (cosh x)

expect
    out = sech (Num.log (Num.toF64 2))
    out |> Num.isApproxEq (4 / 5) {}

## The [hyperbolic cosecant](https://en.wikipedia.org/wiki/Hyperbolic_functions).
csch : F64 -> F64
csch = \x -> 1 / (sinh x)

expect
    out = csch (Num.log (Num.toF64 2))
    out |> Num.isApproxEq (4 / 3) {}
