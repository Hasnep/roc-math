module [
    Angle,
    toRadians,
    toDegrees,
    toTurns,
    toGon,
    isApproxEq,
    isNaN,
    toStr,
]

import Const

## An angle, in either radians, degrees, turns or gon (also called gradians).
Angle : [Radians F64, Degrees F64, Turns F64, Gon F64]

## Convert an angle to radians.
toRadians : Angle -> [Radians F64]
toRadians = \angle ->
    when angle is
        Radians θ -> Radians θ
        Degrees θ -> Radians ((Const.pi * θ) / 180)
        Turns θ -> Radians (Const.tau * θ)
        Gon θ -> Radians ((Const.pi * θ) / 200)

expect
    (Radians out) = toRadians (Radians Const.pi)
    out |> Num.isApproxEq Const.pi {}

expect
    (Radians out) = toRadians (Degrees 180f64) # TODO: Remove explicit F64 type
    out |> Num.isApproxEq Const.pi {}

expect
    (Radians out) = toRadians (Turns 0.5f64) # TODO: Remove explicit F64 type
    out |> Num.isApproxEq Const.pi {}

expect
    (Radians out) = toRadians (Gon 200f64) # TODO: Remove explicit F64 type
    out |> Num.isApproxEq Const.pi {}

## Convert an angle to degrees.
toDegrees : Angle -> [Degrees F64]
toDegrees = \angle ->
    when angle is
        Radians θ -> Degrees (180 * θ / Const.pi)
        Degrees θ -> Degrees θ
        Turns θ -> Degrees (360 * θ)
        Gon θ -> Degrees (180 * θ / 200)

expect
    (Degrees out) = toDegrees (Radians Const.pi)
    out |> Num.isApproxEq 180f64 {} # TODO: Remove explicit F64 type

expect
    (Degrees out) = toDegrees (Degrees 180f64) # TODO: Remove explicit F64 type
    out |> Num.isApproxEq 180f64 {} # TODO: Remove explicit F64 type

expect
    (Degrees out) = toDegrees (Turns 0.5f64) # TODO: Remove explicit F64 type
    out |> Num.isApproxEq 180f64 {} # TODO: Remove explicit F64 type

expect
    (Degrees out) = toDegrees (Gon 200f64) # TODO: Remove explicit F64 type
    out |> Num.isApproxEq 180f64 {} # TODO: Remove explicit F64 type

## Convert an angle to turns.
toTurns : Angle -> [Turns F64]
toTurns = \angle ->
    when angle is
        Radians θ -> Turns (θ / Const.tau)
        Degrees θ -> Turns (θ / 360)
        Turns θ -> Turns θ
        Gon θ -> Turns (θ / 400)

expect
    (Turns out) = toTurns (Radians Const.pi)
    out |> Num.isApproxEq 0.5f64 {} # TODO: Remove explicit F64 type

expect
    (Turns out) = toTurns (Degrees 180f64) # TODO: Remove explicit F64 type
    out |> Num.isApproxEq 0.5f64 {} # TODO: Remove explicit F64 type

expect
    (Turns out) = toTurns (Turns 0.5f64) # TODO: Remove explicit F64 type
    out |> Num.isApproxEq 0.5f64 {} # TODO: Remove explicit F64 type

expect
    (Turns out) = toTurns (Gon 200f64) # TODO: Remove explicit F64 type
    out |> Num.isApproxEq 0.5f64 {} # TODO: Remove explicit F64 type

## Convert an angle to gon.
toGon : Angle -> [Gon F64]
toGon = \angle ->
    when angle is
        Radians θ -> Gon (200 * θ / Const.pi)
        Degrees θ -> Gon (200 * θ / 180)
        Turns θ -> Gon (400 * θ)
        Gon θ -> Gon θ

## Check if two angles are approximately equal.
##
## The tolerance values apply to the angles when converted to radians.
isApproxEq : Angle, Angle, { rtol ? F64, atol ? F64 } -> Bool
isApproxEq = \a, b, { rtol ? 0.00001, atol ? 0.00000001 } ->
    (Radians aRadians) = toRadians a
    (Radians bRadians) = toRadians b
    Num.isApproxEq aRadians bRadians { rtol, atol }

isNaN : Angle -> Bool
isNaN = \angle ->
    when angle is
        Radians θ -> Num.isNaN θ
        Degrees θ -> Num.isNaN θ
        Turns θ -> Num.isNaN θ
        Gon θ -> Num.isNaN θ

expect isNaN (Radians (0.0 / 0.0))
expect isNaN (Radians 0.0) |> Bool.not
expect isNaN (Degrees (0.0 / 0.0))
expect isNaN (Degrees 0.0) |> Bool.not
expect isNaN (Turns (0.0 / 0.0))
expect isNaN (Turns 0.0) |> Bool.not
expect isNaN (Gon (0.0 / 0.0))
expect isNaN (Gon 0.0) |> Bool.not

toStr : Angle -> Str
toStr = \angle ->
    when angle is
        Radians θ -> Num.toStr θ
        Degrees θ -> Num.toStr θ
        Turns θ -> Num.toStr θ
        Gon θ -> Num.toStr θ
