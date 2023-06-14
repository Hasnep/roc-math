interface Stats
    exposes [
        mean,
        meanUnchecked,
        variance,
        varianceWithMean,
        meanAndVariance,
        standardDeviation,
        median,
    ]
    imports [Utils.{ isApproxEq }, Utils]

## The arithmetic mean of a list `x` is defined as the sum of the elements of `x` divided by the number of elements in `x`.
## https://en.wikipedia.org/wiki/Mean#Arithmetic_mean_(AM)
mean : List (Num *) -> Result (Frac *) [ListWasEmpty]
mean = \x ->
    when x is
        [] -> Err ListWasEmpty
        xNonEmpty -> Ok (meanUnchecked xNonEmpty)

expect
    out = mean [1, 2, 3, 4]
    out |> Result.map (\x -> x |> isApproxEq 2.5) |> Result.withDefault Bool.false

expect
    out = mean []
    Result.isErr out

## An unchecked version of [mean] that silently returns `NaN` when the input list is empty.
meanUnchecked : List (Num *) -> Frac *
meanUnchecked = \x ->
    numerator = x |> List.sum |> Num.toFrac
    denominator = x |> List.len |> Num.toFrac
    numerator / denominator

expect
    out = meanUnchecked [1, 2, 3, 4]
    out |> isApproxEq 2.5

expect
    out = meanUnchecked []
    out |> Num.isNaN

## The unbiased sample variance of a list of numbers.
## Defined as S² = ∑(x - x̄)² / (n − 1).
##
## See [Wikipedia](https://en.wikipedia.org/wiki/Variance#Unbiased_sample_variance) for more information.
variance : List (Num *) -> Result (Frac *) [ListWasEmpty]
variance = \x ->
    when x is
        [] -> Err ListWasEmpty
        xNonEmpty -> Ok (varianceWithMean xNonEmpty (meanUnchecked xNonEmpty))

expect
    out = variance [1, 2, 3]
    out |> Result.map (\x -> x |> isApproxEq 1.0) |> Result.withDefault Bool.false

expect
    out = variance []
    out |> Result.isErr

## A version of the [variance] function that uses a pre-calculated mean value for efficiency.
varianceWithMean : List (Num *), Frac * -> Frac *
varianceWithMean = \x, mu ->
    x
    |> List.map Num.toFrac
    |> List.map (\xi -> xi - mu)
    |> List.map Utils.square
    |> List.sum
    |> Num.div (x |> List.len |> Num.sub 1 |> Num.toFrac)

expect
    out = varianceWithMean [1, 2, 3, 4] 2.5
    out |> isApproxEq (5 / 3)

## A function that calculates both the [mean] and [variance] of a list at the same time.
## This is more efficient than calculating both values separately.
meanAndVariance : List (Num *) -> Result (Frac *, Frac *) [ListWasEmpty]
meanAndVariance = \x ->
    when x is
        [] -> Err ListWasEmpty
        xNonEmpty ->
            muX = meanUnchecked x
            varX = varianceWithMean xNonEmpty muX
            Ok (muX, varX)

## The corrected sample standard deviation of a list of numbers.
##
## See [Wikipedia](https://en.wikipedia.org/wiki/Standard_deviation#Corrected_sample_standard_deviation) for more information.
standardDeviation : List (Num *) -> Result (Frac *) [ListWasEmpty]
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

## The number that divides a list of numbers into a lower half and a higher half.
median : List (Num *) -> Frac *
median = \x ->
    xLength = List.len x
    if (xLength % 2) == 0 then
        # Even length
        x
        |> List.sortAsc
        |> List.sublist { start: (xLength // 2) - 1, len: 2 }
        |> List.sum
        |> Num.toFrac
        |> Num.div 2
    else
        # Odd length
        x
        |> List.sortAsc
        |> List.get (xLength // 2)
        |> Utils.unwrap "This can never happen because we're getting the middle element."
        |> Num.toFrac

expect
    out = median [5, 4, 3, 2, 1]
    out |> isApproxEq 3.0

expect
    out = median [1, 2, 3, 4]
    out |> isApproxEq 2.5

## The difference between the maximum and minimum values in a list.
range : List (Num a) -> Result (Num a) [ListWasEmpty]
range = \x ->
    when (List.max x, List.min x) is
        (Ok max, Ok min) -> Ok (max - min)
        _ -> Err ListWasEmpty

expect
    out = range [1, 2, 3, 4, 5]
    out == Ok 4
