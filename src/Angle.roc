module [
    Angle,
    to_radians,
    to_degrees,
    to_turns,
    to_gon,
    is_approx_eq,
    is_nan,
    to_str,
]

import Const

## An angle, in either radians, degrees, turns or gon (also called gradians).
Angle : [Radians F64, Degrees F64, Turns F64, Gon F64]

## Convert an angle to radians.
to_radians : Angle -> [Radians F64]
to_radians = |angle|
    when angle is
        Radians(θ) -> Radians(θ)
        Degrees(θ) -> Radians(((Const.pi * θ) / 180))
        Turns(θ) -> Radians((Const.tau * θ))
        Gon(θ) -> Radians(((Const.pi * θ) / 200))

expect
    Radians(out) = to_radians(Radians(Const.pi))
    out |> Num.is_approx_eq(Const.pi, {})

expect
    Radians(out) = to_radians(Degrees(180f64)) # TODO: Remove explicit F64 type
    out |> Num.is_approx_eq(Const.pi, {})

expect
    Radians(out) = to_radians(Turns(0.5f64)) # TODO: Remove explicit F64 type
    out |> Num.is_approx_eq(Const.pi, {})

expect
    Radians(out) = to_radians(Gon(200f64)) # TODO: Remove explicit F64 type
    out |> Num.is_approx_eq(Const.pi, {})

## Convert an angle to degrees.
to_degrees : Angle -> [Degrees F64]
to_degrees = |angle|
    when angle is
        Radians(θ) -> Degrees((180 * θ / Const.pi))
        Degrees(θ) -> Degrees(θ)
        Turns(θ) -> Degrees((360 * θ))
        Gon(θ) -> Degrees((180 * θ / 200))

expect
    Degrees(out) = to_degrees(Radians(Const.pi))
    out |> Num.is_approx_eq(180f64, {}) # TODO: Remove explicit F64 type

expect
    Degrees(out) = to_degrees(Degrees(180f64)) # TODO: Remove explicit F64 type
    out |> Num.is_approx_eq(180f64, {}) # TODO: Remove explicit F64 type

expect
    Degrees(out) = to_degrees(Turns(0.5f64)) # TODO: Remove explicit F64 type
    out |> Num.is_approx_eq(180f64, {}) # TODO: Remove explicit F64 type

expect
    Degrees(out) = to_degrees(Gon(200f64)) # TODO: Remove explicit F64 type
    out |> Num.is_approx_eq(180f64, {}) # TODO: Remove explicit F64 type

## Convert an angle to turns.
to_turns : Angle -> [Turns F64]
to_turns = |angle|
    when angle is
        Radians(θ) -> Turns((θ / Const.tau))
        Degrees(θ) -> Turns((θ / 360))
        Turns(θ) -> Turns(θ)
        Gon(θ) -> Turns((θ / 400))

expect
    Turns(out) = to_turns(Radians(Const.pi))
    out |> Num.is_approx_eq(0.5f64, {}) # TODO: Remove explicit F64 type

expect
    Turns(out) = to_turns(Degrees(180f64)) # TODO: Remove explicit F64 type
    out |> Num.is_approx_eq(0.5f64, {}) # TODO: Remove explicit F64 type

expect
    Turns(out) = to_turns(Turns(0.5f64)) # TODO: Remove explicit F64 type
    out |> Num.is_approx_eq(0.5f64, {}) # TODO: Remove explicit F64 type

expect
    Turns(out) = to_turns(Gon(200f64)) # TODO: Remove explicit F64 type
    out |> Num.is_approx_eq(0.5f64, {}) # TODO: Remove explicit F64 type

## Convert an angle to gon.
to_gon : Angle -> [Gon F64]
to_gon = |angle|
    when angle is
        Radians(θ) -> Gon((200 * θ / Const.pi))
        Degrees(θ) -> Gon((200 * θ / 180))
        Turns(θ) -> Gon((400 * θ))
        Gon(θ) -> Gon(θ)

## Check if two angles are approximately equal.
##
## The tolerance values apply to the angles when converted to radians.
is_approx_eq : Angle, Angle, { rtol ?? F64, atol ?? F64 } -> Bool
is_approx_eq = |a, b, { rtol ?? 0.00001, atol ?? 0.00000001 }|
    Radians(a_radians) = to_radians(a)
    Radians(b_radians) = to_radians(b)
    Num.is_approx_eq(a_radians, b_radians, { rtol, atol })

is_nan : Angle -> Bool
is_nan = |angle|
    when angle is
        Radians(θ) -> Num.is_nan(θ)
        Degrees(θ) -> Num.is_nan(θ)
        Turns(θ) -> Num.is_nan(θ)
        Gon(θ) -> Num.is_nan(θ)

expect is_nan(Radians((0.0 / 0.0)))
expect is_nan(Radians(0.0)) |> Bool.not
expect is_nan(Degrees((0.0 / 0.0)))
expect is_nan(Degrees(0.0)) |> Bool.not
expect is_nan(Turns((0.0 / 0.0)))
expect is_nan(Turns(0.0)) |> Bool.not
expect is_nan(Gon((0.0 / 0.0)))
expect is_nan(Gon(0.0)) |> Bool.not

to_str : Angle -> Str
to_str = |angle|
    when angle is
        Radians(θ) -> Num.to_str(θ)
        Degrees(θ) -> Num.to_str(θ)
        Turns(θ) -> Num.to_str(θ)
        Gon(θ) -> Num.to_str(θ)
