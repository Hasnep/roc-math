module [
    mean,
    mean_unchecked,
    variance,
    variance_unchecked,
    variance_with_mean,
    mean_and_variance,
    mean_and_variance_unchecked,
    standard_deviation,
    nth_sample_moment,
    nth_sample_moment_unchecked,
    nth_sample_moment_with_mean,
    median,
    median_unchecked,
    range,
]

import Utils

## The [arithmetic mean](https://en.wikipedia.org/wiki/Mean#Arithmetic_mean_(AM)) of a list `x` is defined as the sum of the elements of `x` divided by the number of elements in `x`.
##
## For a version of this function that silently returns `NaN` when the input list is empty, see [meanUnchecked].
mean : List (Num *) -> Result F64 [ListWasEmpty]
mean = |x|
    when x is
        [] -> Err(ListWasEmpty)
        x_non_empty -> Ok(mean_unchecked(x_non_empty))

expect
    out = mean([1, 2, 3, 4])
    out |> Result.map_ok(|x| x |> Num.is_approx_eq(2.5, {})) |> Result.with_default(Bool.false)

expect
    out = mean([])
    Result.is_err(out)

## A version of [mean] that silently returns `NaN` when the input list is empty.
mean_unchecked : List (Num *) -> F64
mean_unchecked = |x|
    numerator = x |> List.sum |> Num.to_f64
    denominator = x |> List.len |> Num.to_f64
    numerator / denominator

expect
    out = mean_unchecked([1, 2, 3, 4])
    out |> Num.is_approx_eq(2.5, {})

expect
    out = mean_unchecked([])
    out |> Num.is_nan

## The [unbiased sample variance](https://en.wikipedia.org/wiki/Variance#Unbiased_sample_variance) of a list of numbers.
##
## Defined as S² = ∑(x - x̄)² / (n − 1).
variance : List (Num *) -> Result F64 [ListWasEmpty]
variance = |x|
    when x is
        [] -> Err(ListWasEmpty)
        x_non_empty -> Ok(variance_unchecked(x_non_empty))

expect
    out = variance([1, 2, 3])
    out |> Result.map_ok(|x| x |> Num.is_approx_eq(1.0, {})) |> Result.with_default(Bool.false)

expect
    out = variance(List.range({ start: At(1), end: At(10) }))
    out |> Result.map_ok(|x| x |> Num.is_approx_eq(9.166666666666666, {})) |> Result.with_default(Bool.false)

expect
    out = variance([])
    out |> Result.is_err

## A version of the [variance] function that silently returns `NaN` when the input list is empty.
variance_unchecked : List (Num *) -> F64
variance_unchecked = |x|
    when x is
        [] -> Num.nan_f64
        _ -> variance_with_mean(x, mean_unchecked(x))

expect
    out = variance_unchecked([1, 2, 3])
    out |> Num.is_approx_eq(1.0, {})

expect
    out = variance_unchecked(List.range({ start: At(1), end: At(10) }))
    out |> Num.is_approx_eq(9.166666666666666, {})

expect
    out = variance_unchecked([])
    out |> Num.is_nan

## A version of the [variance] function that uses a pre-calculated mean value for efficiency.
variance_with_mean : List (Num *), F64 -> F64
variance_with_mean = |x, mu|
    x
    |> List.map(Num.to_f64)
    |> List.map(|xi| xi - mu)
    |> List.map(Utils.square)
    |> List.sum
    |> Num.div((x |> List.len |> Num.sub(1) |> Num.to_f64))

expect
    out = variance_with_mean([1, 2, 3, 4], 2.5)
    out |> Num.is_approx_eq((5 / 3), {})

## A function that calculates both the [mean] and [variance] of a list at the same time.
## This is more efficient than calculating both values separately.
mean_and_variance : List (Num *) -> Result (F64, F64) [ListWasEmpty]
mean_and_variance = |x|
    when x is
        [] -> Err(ListWasEmpty)
        x_non_empty -> Ok(mean_and_variance_unchecked(x_non_empty))

## A function that calculates both the [mean] and [variance] of a list at the same time.
## This is more efficient than calculating both values separately.
mean_and_variance_unchecked : List (Num *) -> (F64, F64)
mean_and_variance_unchecked = |x|
    mu = mean_unchecked(x)
    var = variance_with_mean(x, mu)
    (mu, var)

## The [corrected sample standard deviation](https://en.wikipedia.org/wiki/Standard_deviation#Corrected_sample_standard_deviation) of a list of numbers.
standard_deviation : List (Num *) -> Result F64 [ListWasEmpty]
standard_deviation = |x| x |> variance |> Result.map_ok(Num.sqrt)

## The [n-th sample moment](https://en.wikipedia.org/wiki/Moment_(mathematics)#Sample_moments) of a list of numbers.
nth_sample_moment : List (Num *), U64 -> Result F64 [ListWasEmpty]
nth_sample_moment = |x, n|
    when x is
        [] -> Err(ListWasEmpty)
        x_non_empty -> Ok(nth_sample_moment_unchecked(x_non_empty, n))

expect
    out = nth_sample_moment([1, 2, 3, 4], 2)
    out |> Result.map_ok(|x| x |> Num.is_approx_eq(5.0, {})) |> Result.with_default(Bool.false)

expect
    out = nth_sample_moment([], 2)
    Result.is_err(out)

## The [n-th sample moment](https://en.wikipedia.org/wiki/Moment_(mathematics)#Sample_moments) of a list of numbers that silently returns NaN when the input list is empty.
nth_sample_moment_unchecked : List (Num *), U64 -> F64
nth_sample_moment_unchecked = |x, n|
    when x is
        [] -> Num.nan_f64
        _ -> nth_sample_moment_with_mean(x, n, mean_unchecked(x))

expect
    out = nth_sample_moment_unchecked([1, 2, 3, 4], 2)
    out |> Num.is_approx_eq(5.0, {})

expect
    out = nth_sample_moment_unchecked([], 2)
    out |> Num.is_nan

## The [n-th sample moment](https://en.wikipedia.org/wiki/Moment_(mathematics)#Sample_moments) of a list of numbers, given a pre-calculated mean.
nth_sample_moment_with_mean : List (Num *), U64, F64 -> F64
nth_sample_moment_with_mean = |x, n, mu|
    x
    |> List.map(Num.to_frac)
    |> List.map(|xᵢ| xᵢ - mu)
    |> List.map(|xᵢ| Num.pow(xᵢ, Num.to_frac(n)))
    |> List.sum

## The [median](https://en.wikipedia.org/wiki/Median) of a list of numbers.
median : List (Num *) -> Result F64 [ListWasEmpty]
median = |x|
    when x is
        [] -> Err(ListWasEmpty)
        x_non_empty -> Ok(median_unchecked(x_non_empty))

expect
    out = median([5, 4, 3, 2, 1])
    out |> Result.map_ok(|x| x |> Num.is_approx_eq(3.0, {})) |> Result.with_default(Bool.false)

expect
    out = median([1, 2, 3, 4])
    out |> Result.map_ok(|x| x |> Num.is_approx_eq(2.5, {})) |> Result.with_default(Bool.false)

expect
    out = median([])
    Result.is_err(out)

## A version of the [median] function that silently returns `NaN` when the input list is empty.
median_unchecked : List (Num *) -> F64
median_unchecked = |x|
    x_length = List.len(x)
    if x_length == 0 then
        Num.nan_f64
    else if (x_length % 2) == 0 then
        # Even length
        x
        |> List.sort_asc
        |> List.sublist({ start: (x_length // 2) - 1, len: 2 })
        |> List.sum
        |> Num.to_f64
        |> Num.div(2)
    else
        # Odd length
        x
        |> List.sort_asc
        |> List.get((x_length // 2))
        |> Utils.unwrap("This can never happen because we're getting the middle element.")
        |> Num.to_f64

expect
    out = median_unchecked([5, 4, 3, 2, 1])
    out |> Num.is_approx_eq(3.0, {})

expect
    out = median_unchecked([1, 2, 3, 4])
    out |> Num.is_approx_eq(2.5, {})

expect
    out = median_unchecked([])
    Num.is_nan(out)

## The difference between the maximum and minimum values in a list.
range : List (Num a) -> Result (Num a) [ListWasEmpty]
range = |x|
    when (List.max(x), List.min(x)) is
        (Ok(max), Ok(min)) -> Ok((max - min))
        _ -> Err(ListWasEmpty)

expect
    out = range([1, 2, 3, 4, 5])
    out == Ok(4)
