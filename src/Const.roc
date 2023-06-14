interface Const
    exposes [pi, π, tau, τ, e, ℯ, goldenRatio, φ, sqrt2]
    imports [Utils.{ isApproxEq }]

## The circle constant, defined as the ratio of a circle's diameter to the circle's circumference.
##
## See [Wikipedia](https://en.wikipedia.org/wiki/Pi) for more information.
pi : F64
pi = 3.141592653589793238462643383279502884197169399375105820974944592307816406286208998628034825342117067982148086513282306647093844609550582231725359408128481117450284102701938521105559644622948954930381964428810975665933446128475648233786783165271201909145648566923460348610454326648213393607260249141273724587006606315588174881520920962829254091715364367892590360

expect
    out = Num.sin (pi / 2)
    out |> isApproxEq 1.0

## An alias for [pi].
π : F64
π = pi

## The other circle constant, defined as the ratio of a circle's radius to the circle's circumference.
##
## See [Wikipedia](https://en.wikipedia.org/wiki/Tau_(mathematical_constant)) for more information.
tau : F64
tau = 2.0 * pi

expect
    out = tau / 2
    out |> isApproxEq pi

## An alias for [tau].
τ : F64
τ = tau

## Euler's number, the base of the natural logarithm.
##
## See [Wikipedia](https://en.wikipedia.org/wiki/E_(mathematical_constant)) for more information.
e : F64
e = 2.718281828459045235360287471352662497757247093699959574966967627724076630353547594571382178525166427427466391932003059921817413596629043572900334295260595630738132328627943490763233829880753195251019011573834187930702154089149934884167509244761460668082264800168477411853742345442437107539077744992069551702761838606261331384583000752044933826560297606737113200

## An alias for [e].
ℯ : F64
ℯ = e

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
    out |> isApproxEq 2.0
