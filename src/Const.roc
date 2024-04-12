interface Const
    exposes [pi, π, tau, τ, e, ℯ, goldenRatio, φ, sqrt2]
    imports []

## The circle constant, defined as the ratio of a circle's diameter to the circle's circumference.
##
## See [Wikipedia](https://en.wikipedia.org/wiki/Pi) for more information.
pi : F64
pi = Num.pi

expect
    out = Num.sin (pi / 2)
    out |> Num.isApproxEq 1.0 {}

## An alias for [pi].
π : F64
π = Num.pi

## The other circle constant, defined as the ratio of a circle's radius to the circle's circumference.
##
## See [Wikipedia](https://en.wikipedia.org/wiki/Tau_(mathematical_constant)) for more information.
tau : F64
tau = Num.tau

expect
    out = tau / 2
    out |> Num.isApproxEq pi {}

## An alias for [tau].
τ : F64
τ = Num.tau

## Euler's number, the base of the natural logarithm.
##
## See [Wikipedia](https://en.wikipedia.org/wiki/E_(mathematical_constant)) for more information.
e : F64
e = Num.e

## An alias for [e].
ℯ : F64
ℯ = Num.e

## The golden ratio, defined as φ = (1 + √5)/2, and satisfies the quadratic equation φ² = φ + 1.
##
## See [Wikipedia](https://en.wikipedia.org/wiki/Golden_ratio) for more information.
goldenRatio : F64
goldenRatio = (1 + (Num.sqrt 5)) / 2

## An alias for [goldenRatio].
φ : F64
φ = goldenRatio

## The square root of two (√2).
##
## See [Wikipedia](https://en.wikipedia.org/wiki/Square_root_of_2) for more information.
sqrt2 : F64
sqrt2 = Num.sqrt 2

expect
    out = Num.pow sqrt2 2.0
    out |> Num.isApproxEq 2.0 {}
