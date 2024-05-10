module [
    gcd,
    # lcm, divides, divisors, isPrime, primeFactors,
]

## The [greatest common divisor](https://en.wikipedia.org/wiki/Greatest_common_divisor) of two positive integers `a` and `b` is the largest integer that divides both `a` and `b`.
gcd : U64, U64 -> U64
gcd = \a, b -> if b == 0 then a else gcd b (a % b)

expect
    out = gcd 12 15
    out == 3

expect
    out = gcd 34 53
    out == 1

## The [least common multiple](https://en.wikipedia.org/wiki/Least_common_multiple) of two positive integer `a` and `b` is the smallest positive integer that is a multiple of both `a` and `b`.
lcm : U64, U64 -> U64
lcm = \a, b -> (a * b) // gcd a b

expect
    out = lcm 12 15
    out == 60

expect
    out = lcm 34 53
    out == 1802

## An integer `a` divides another integer `b` if and only if there exists an integer `c` such that `a * c = b`
divides : I64, I64 -> Bool
divides = \a, b -> b % a == 0

expect
    out = divides 3 9
    out == Bool.true

expect
    out = divides 3 10
    out == Bool.false

## The positive [divisors](https://en.wikipedia.org/wiki/Divisor) of a positive integer `n` are all the positive numbers that divide `n` with no remainder, including `n` itself.
divisors : U64 -> List U64
divisors = \n ->
    List.range { start: At 1, end: At n }
    |> List.keepIf (\x -> divides (Num.toI64 x) (Num.toI64 n))

expect
    out = divisors 12
    out == [1, 2, 3, 4, 6, 12]

isPrime : U64 -> Bool
isPrime = \n -> divisors n == [1, n]

expect
    out = isPrime 1
    out == Bool.false

expect
    out = isPrime 2
    out == Bool.true

expect
    out = isPrime 3
    out == Bool.true

## The [prime factors](https://en.wikipedia.org/wiki/Prime_factor) of a positive integer `n` are the prime numbers that divide `n` exactly.
primeFactors : U64 -> List U64
primeFactors = \n -> divisors n |> List.keepIf isPrime

expect
    out = primeFactors 12
    out == [2, 3]

expect
    out = primeFactors 15
    out == [3, 5]
