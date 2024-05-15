module [pi, π, tau, τ, e, ℯ, goldenRatio, φ, sqrt2]

## The circle constant [π](https://en.wikipedia.org/wiki/Pi), defined as the ratio of a circle's diameter to the circle's circumference.
pi : F64
pi = Num.pi

expect
    out = Num.sin (pi / 2)
    out |> Num.isApproxEq 1.0 {}

## An alias for [pi].
π : F64
π = Num.pi

## The other circle constant [τ](https://en.wikipedia.org/wiki/Tau_(mathematical_constant)), defined as the ratio of a circle's radius to the circle's circumference.
tau : F64
tau = Num.tau

expect
    out = tau / 2
    out |> Num.isApproxEq pi {}

## An alias for [tau].
τ : F64
τ = Num.tau

## [Euler's number](https://en.wikipedia.org/wiki/E_(mathematical_constant)), the base of the natural logarithm.
e : F64
e = Num.e

## An alias for [e].
ℯ : F64
ℯ = Num.e

## [The golden ratio](https://en.wikipedia.org/wiki/Golden_ratio), defined as φ = (1 + √5)/2, and satisfies the quadratic equation φ² = φ + 1.
goldenRatio : F64
goldenRatio = (1 + (Num.sqrt 5)) / 2

## An alias for [goldenRatio].
φ : F64
φ = goldenRatio

## The [square root of two](https://en.wikipedia.org/wiki/Square_root_of_2) (√2).
sqrt2 : F64
sqrt2 = Num.sqrt 2

expect
    out = Num.pow sqrt2 2.0
    out |> Num.isApproxEq 2.0 {}
