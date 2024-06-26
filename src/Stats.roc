module [
    mean,
    meanUnchecked,
    variance,
    varianceWithMean,
    meanAndVariance,
    standardDeviation,
    median,
    medianUnchecked,
]

import Utils

## The [arithmetic mean](https://en.wikipedia.org/wiki/Mean#Arithmetic_mean_(AM)) of a list `x` is defined as the sum of the elements of `x` divided by the number of elements in `x`.
##
## For a version of this function that silently returns `NaN` when the input list is empty, see [meanUnchecked].
mean : List (Num *) -> Result F64 [ListWasEmpty]
mean = \x ->
    when x is
        [] -> Err ListWasEmpty
        xNonEmpty -> Ok (meanUnchecked xNonEmpty)

expect
    out = mean [1, 2, 3, 4]
    out |> Result.map (\x -> x |> Num.isApproxEq 2.5 {}) |> Result.withDefault Bool.false

expect
    out = mean []
    Result.isErr out

## A version of [mean] that silently returns `NaN` when the input list is empty.
meanUnchecked : List (Num *) -> F64
meanUnchecked = \x ->
    numerator = x |> List.sum |> Num.toF64
    denominator = x |> List.len |> Num.toF64
    numerator / denominator

expect
    out = meanUnchecked [1, 2, 3, 4]
    out |> Num.isApproxEq 2.5 {}

expect
    out = meanUnchecked []
    out |> Num.isNaN

## The [unbiased sample variance](https://en.wikipedia.org/wiki/Variance#Unbiased_sample_variance) of a list of numbers.
##
## Defined as S² = ∑(x - x̄)² / (n − 1).
variance : List (Num *) -> Result F64 [ListWasEmpty]
variance = \x ->
    when x is
        [] -> Err ListWasEmpty
        xNonEmpty -> Ok (varianceWithMean xNonEmpty (meanUnchecked xNonEmpty))

expect
    out = variance [1, 2, 3]
    out |> Result.map (\x -> x |> Num.isApproxEq 1.0 {}) |> Result.withDefault Bool.false

expect
    out = variance []
    out |> Result.isErr

## A version of the [variance] function that uses a pre-calculated mean value for efficiency.
varianceWithMean : List (Num *), F64 -> F64
varianceWithMean = \x, mu ->
    x
    |> List.map Num.toF64
    |> List.map (\xi -> xi - mu)
    |> List.map Utils.square
    |> List.sum
    |> Num.div (x |> List.len |> Num.sub 1 |> Num.toF64)

expect
    out = varianceWithMean [1, 2, 3, 4] 2.5
    out |> Num.isApproxEq (5 / 3) {}

## A function that calculates both the [mean] and [variance] of a list at the same time.
## This is more efficient than calculating both values separately.
meanAndVariance : List (Num *) -> Result (F64, F64) [ListWasEmpty]
meanAndVariance = \x ->
    when x is
        [] -> Err ListWasEmpty
        xNonEmpty ->
            muX = meanUnchecked x
            varX = varianceWithMean xNonEmpty muX
            Ok (muX, varX)

## The [corrected sample standard deviation](https://en.wikipedia.org/wiki/Standard_deviation#Corrected_sample_standard_deviation) of a list of numbers.
standardDeviation : List (Num *) -> Result F64 [ListWasEmpty]
standardDeviation = \x -> x |> variance |> Result.map Num.sqrt

# ## skew
# skew = \x -> x
#
# ## kurtosis
# kurtosis = \x -> x
#
# ## covariance
# covariance = \x -> x
#
# ## quantiles
# # quantiles = \x -> x

## The [median](https://en.wikipedia.org/wiki/Median) of a list of numbers.
median : List (Num *) -> Result F64 [ListWasEmpty]
median = \x ->
    when x is
        [] -> Err ListWasEmpty
        xNonEmpty -> Ok (medianUnchecked xNonEmpty)

expect
    out = median [5, 4, 3, 2, 1]
    out |> Result.map (\x -> x |> Num.isApproxEq 3.0 {}) |> Result.withDefault Bool.false

expect
    out = median [1, 2, 3, 4]
    out |> Result.map (\x -> x |> Num.isApproxEq 2.5 {}) |> Result.withDefault Bool.false

expect
    out = median []
    Result.isErr out

## A version of the [median] function that silently returns `NaN` when the input list is empty.
medianUnchecked : List (Num *) -> F64
medianUnchecked = \x ->
    xLength = List.len x
    if xLength == 0 then
        Num.nanF64
    else if (xLength % 2) == 0 then
        # Even length
        x
        |> List.sortAsc
        |> List.sublist { start: (xLength // 2) - 1, len: 2 }
        |> List.sum
        |> Num.toF64
        |> Num.div 2
    else
        # Odd length
        x
        |> List.sortAsc
        |> List.get (xLength // 2)
        |> Utils.unwrap "This can never happen because we're getting the middle element."
        |> Num.toF64

expect
    out = medianUnchecked [5, 4, 3, 2, 1]
    out |> Num.isApproxEq 3.0 {}

expect
    out = medianUnchecked [1, 2, 3, 4]
    out |> Num.isApproxEq 2.5 {}

expect
    out = medianUnchecked []
    Num.isNaN out

## The difference between the maximum and minimum values in a list.
range : List (Num a) -> Result (Num a) [ListWasEmpty]
range = \x ->
    when (List.max x, List.min x) is
        (Ok max, Ok min) -> Ok (max - min)
        _ -> Err ListWasEmpty

expect
    out = range [1, 2, 3, 4, 5]
    out == Ok 4
