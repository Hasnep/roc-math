module [factorial, choose]

## The [factorial](https://en.wikipedia.org/wiki/Factorial) of `n` is product of all the integers from 1 to `n`.
factorial : U64 -> U64
factorial = |x|
    when x is
        0 -> 1
        1 -> 1
        y -> List.range({ start: At(2), end: At(y) }) |> List.product

expect
    out = List.range({ start: At(0), end: At(10) }) |> List.map(factorial)
    out == [1, 1, 2, 6, 24, 120, 720, 5_040, 40_320, 362_880, 3_628_800]

## The [binomial coefficient](https://en.wikipedia.org/wiki/Binomial_coefficient), the number of ways of choosing `k` things from a collection of size `n`.
choose : U64, U64 -> U64
choose = |n, k|
    if n > k then
        factorial_n = factorial(n)
        factorial_k = factorial(k)
        factorial_n_minus_k = factorial((n - k))
        factorial_n // (factorial_k * factorial_n_minus_k)
    else
        0

expect
    out = choose(10, 3)
    out == 120
