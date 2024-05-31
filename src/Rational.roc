module [
    Rational,
    rational,
    toTuple,
    negative,
    add,
    sub,
    mul,
    div,
    # compare,
    toF64,
    reciprocal,
]

import Utils

## A rational number.
Rational := { numerator : U64, denominator : U64, sign : [Positive, Negative] } implements [Eq]

## Create a [Rational] number.
rational : I64, I64 -> Rational
rational = \numerator, denominator ->
    numeratorAbs = Num.toU64 (Num.abs numerator)
    denominatorAbs = Num.toU64 (Num.abs denominator)
    sign = if Utils.xor (Num.isNegative numerator) (Num.isNegative denominator) then Negative else Positive
    @Rational { numerator: numeratorAbs, denominator: denominatorAbs, sign }

expect
    out = rational 1 2
    out == @Rational { numerator: 1, denominator: 2, sign: Positive }

expect
    out = rational -1 2
    out == @Rational { numerator: 1, denominator: 2, sign: Negative }

expect
    out = rational 1 -2
    out == @Rational { numerator: 1, denominator: 2, sign: Negative }

expect
    out = rational -1 -2
    out == @Rational { numerator: 1, denominator: 2, sign: Positive }

##
toTuple : Rational -> (I64, U64)
toTuple = \@Rational { numerator, denominator, sign } -> ((if sign == Negative then -1 else 1) * Num.toI64 numerator, Num.toU64 denominator)

## Add two [Rational] numbers.
add : Rational, Rational -> Rational
add = \@Rational { numerator: aN, denominator: aD, sign: aSign }, @Rational { numerator: bN, denominator: bD, sign: bSign } ->
    numerator =
        (if aSign == Negative then -1 else 1)
        * (Num.toI64 aN)
        * (Num.toI64 bD)
        + (if bSign == Negative then -1 else 1)
        * (Num.toI64 bN)
        * (Num.toI64 aD)
    if numerator == 0 then
        @Rational { numerator: 0, denominator: 1, sign: Positive }
    else
        numeratorAbs = Num.toU64 (Num.abs numerator)
        denominator = aD * bD
        sign = if Num.isNegative numerator then Negative else Positive
        @Rational { numerator: numeratorAbs, denominator, sign }

expect
    out = add (rational 1 2) (rational 1 2)
    out == @Rational { numerator: 4, denominator: 4, sign: Positive }

expect
    out = add (rational 1 2) (rational -1 2)
    out == @Rational { numerator: 0, denominator: 1, sign: Positive }

## Subtract a [Rational] number from another.
sub : Rational, Rational -> Rational
sub = \a, b -> a |> add (negative b)

## Multiply two [Rational] numbers.
mul : Rational, Rational -> Rational
mul = \@Rational { numerator: aN, denominator: aD, sign: aSign }, @Rational { numerator: bN, denominator: bD, sign: bSign } ->
    numerator = aN * bN
    denominator = aD * bD
    sign = if Utils.xor (aSign == Negative) (bSign == Negative) then Negative else Positive
    @Rational { numerator, denominator, sign }

## Divide a [Rational] number by another.
div : Rational, Rational -> Rational
div = \a, b -> a |> mul (reciprocal b)

## Get the negative of a [Rational] number.
negative : Rational -> Rational
negative = \@Rational { numerator, denominator, sign } ->
    @Rational { numerator, denominator, sign: if sign == Negative then Positive else Negative }

# ## Compare two [Rational] numbers.
# compare : Rational, Rational -> [LT, EQ, GT]
# compare = \{ numerator: aN, denominator: aD }, { numerator: bN, denominator: bD } ->
#     a = aN * (Num.toI64 bD)
#     b = bN * (Num.toI64 aD)
#     if a < b then
#         LT
#     else if a > b then
#         GT
#     else
#         EQ

## Convert a [Rational] number to a [F64].
toF64 : Rational -> F64
toF64 = \@Rational { numerator, denominator, sign } ->
    (if sign == Negative then -1 else 1) * (Num.toF64 numerator) / (Num.toF64 denominator)

## Get the reciprocal of a [Rational] number.
reciprocal : Rational -> Rational
reciprocal = \@Rational { numerator, denominator, sign } ->
    @Rational { numerator: denominator, denominator: numerator, sign }

expect
    out = reciprocal (rational 1 2)
    out == (rational 2 1)

expect
    out = reciprocal (rational -1 2)
    out == (rational 2 -1)

expect
    out = reciprocal (rational 1 -2)
    out == (rational 2 -1)

expect
    out = reciprocal (rational -1 -2)
    out == (rational 2 1)
