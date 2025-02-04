module [
    gcd,
    lcm,
    divides,
    divisors,
    proper_divisors,
    is_prime,
    prime_factors,
    is_perfect,
]

## The [greatest common divisor](https://en.wikipedia.org/wiki/Greatest_common_divisor) of two positive integers `a` and `b` is the largest integer that divides both `a` and `b`.
gcd : U64, U64 -> U64
gcd = |a, b| if b == 0 then a else gcd(b, (a % b))

expect
    out = gcd(12, 15)
    out == 3

expect
    out = gcd(34, 53)
    out == 1

## The [least common multiple](https://en.wikipedia.org/wiki/Least_common_multiple) of two positive integer `a` and `b` is the smallest positive integer that is a multiple of both `a` and `b`.
lcm : U64, U64 -> U64
lcm = |a, b| (a * b) // gcd(a, b)

expect
    out = lcm(12, 15)
    out == 60

expect
    out = lcm(34, 53)
    out == 1802

## An integer `a` divides another integer `b` if and only if there exists an integer `c` such that `a * c = b`
divides : I64, I64 -> Bool
divides = |a, b| b % a == 0

expect divides(3, 9)
expect divides(3, 10) |> Bool.not

## The positive [divisors](https://en.wikipedia.org/wiki/Divisor) of a positive integer `n` are all the positive numbers that divide `n` with no remainder, including `n` itself.
##
## To get the divisors of `n` excluding `n` itself, see [properDivisors].
divisors : U64 -> List U64
divisors = |n|
    List.range({ start: At(1), end: At(n) })
    |> List.keep_if(|x| divides(Num.to_i64(x), Num.to_i64(n)))

expect
    out = divisors(12)
    out == [1, 2, 3, 4, 6, 12]

## The [proper divisors](https://en.wikipedia.org/wiki/Divisor) of a positive integer `n` are all the positive numbers that divide `n` with no remainder, excluding `n` itself.
##
## To get the divisors of `n` including `n` itself, see [divisors].
proper_divisors : U64 -> List U64
proper_divisors = |n|
    List.range({ start: At(1), end: Before(n) })
    |> List.keep_if(|x| divides(Num.to_i64(x), Num.to_i64(n)))

expect
    out = proper_divisors(12)
    out == [1, 2, 3, 4, 6]

is_prime : U64 -> Bool
is_prime = |n| divisors(n) == [1, n]

expect is_prime(1) |> Bool.not
expect is_prime(2)
expect is_prime(3)

## The [prime factors](https://en.wikipedia.org/wiki/Prime_factor) of a positive integer `n` are the prime numbers that divide `n` exactly.
prime_factors : U64 -> List U64
prime_factors = |n| divisors(n) |> List.keep_if(is_prime)

expect
    out = prime_factors(12)
    out == [2, 3]

expect
    out = prime_factors(15)
    out == [3, 5]

## A [perfect number](https://en.wikipedia.org/wiki/Perfect_number) is a positive integer that is equal to the sum of its proper divisors, excluding itself.
is_perfect : U64 -> Bool
is_perfect = |n| List.sum(proper_divisors(n)) == n

expect is_perfect(6)
expect is_perfect(7) |> Bool.not
expect is_perfect(8128)
