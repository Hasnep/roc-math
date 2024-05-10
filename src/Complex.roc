module [
    Complex,
    i,
    zero,
    fromReal,
    fromImag,
    fromTuple,
    toTuple,
    add,
    sub,
    mul,
    div,
    reciprocal,
    abs,
    arg,
    toPolar,
]

## A complex number z = x + yi, where i = √-1.
Complex : { real : F64, imag : F64 }

# Constructors

## The imaginary unit.
i : Complex
i = { real: 0.0, imag: 1.0 }

## The complex number z = 0 + 0i.
zero : Complex
zero = { real: 0.0, imag: 0.0 }

## Convert a number x to a complex number z = x + 0i.
fromReal : Num * -> Complex
fromReal = \real -> { real: Num.toF64 real, imag: 0.0 }

expect
    out = fromReal 3
    (out.real |> Num.isApproxEq 3 {}) && (out.imag |> Num.isApproxEq 0 {})

## Convert a number y to a complex number z = 0 + yi.
fromImag : Num * -> Complex
fromImag = \imag -> { real: 0.0, imag: Num.toF64 imag }

expect
    out = fromImag 4
    (out.real |> Num.isApproxEq 0 {}) && (out.imag |> Num.isApproxEq 4.0 {})

# Tuples

## Convert two numbers x and y to a complex number z = x + yi. The inverse of [toTuple].
fromTuple : (Num *, Num *) -> Complex
fromTuple = \(real, imag) -> { real: Num.toF64 real, imag: Num.toF64 imag }

expect
    out = fromTuple (3, 4)
    (out.real |> Num.isApproxEq 3 {}) && (out.imag |> Num.isApproxEq 4 {})

## Convert a complex number z = x + yi to a tuple `(x, y)`. The inverse of [fromTuple].
toTuple : Complex -> (F64, F64)
toTuple = \z -> (z.real, z.imag)

expect
    (outReal, outImag) = toTuple { real: 3, imag: 4 }
    (outReal |> Num.isApproxEq 3 {}) && (outImag |> Num.isApproxEq 4 {})

# Arithmetic

## Add two complex numbers together.
add : Complex, Complex -> Complex
add = \x, y -> { real: x.real + y.real, imag: x.imag + y.imag }

expect
    out = add { real: 3, imag: 5 } { real: 1, imag: 2 }
    (out.real |> Num.isApproxEq 4 {}) && (out.imag |> Num.isApproxEq 7 {})

## Subtract one complex number from another.
sub : Complex, Complex -> Complex
sub = \x, y -> { real: x.real - y.real, imag: x.imag - y.imag }

expect
    out = sub { real: 3, imag: 5 } { real: 1, imag: 2 }
    (out.real |> Num.isApproxEq 2 {}) && (out.imag |> Num.isApproxEq 3 {})

## Multiply two complex numbers together.
mul : Complex, Complex -> Complex
mul = \x, y -> {
    real: (x.real * y.real) - (x.imag * y.imag),
    imag: (x.real * y.imag) + (x.imag * y.real),
}

expect
    out = mul { real: 3, imag: 5 } { real: 1, imag: 2 }
    (out.real |> Num.isApproxEq -7 {}) && (out.imag |> Num.isApproxEq 11 {})

## Divide one complex number by another.
div : Complex, Complex -> Complex
div = \w, z ->
    zAbsSquared = (z.real ^ 2) + (z.imag ^ 2)
    real = ((w.real * z.real) + (w.imag * z.imag)) / zAbsSquared
    imag = ((w.imag * z.real) - (w.real * z.imag)) / zAbsSquared
    { real: real, imag: imag }

expect
    out = div { real: 3, imag: 5 } { real: 1, imag: 2 }
    (out.real |> Num.isApproxEq (13 / 5) {}) && (out.imag |> Num.isApproxEq (-1 / 5) {})

## The reciprocal of a non-zero complex number.
reciprocal : Complex -> Complex
reciprocal = \z ->
    zAbsSquared = (z.real ^ 2) + (z.imag ^ 2)
    real = z.real / zAbsSquared
    imag = -z.imag / zAbsSquared
    { real: real, imag: imag }

expect
    out = reciprocal { real: 3, imag: 5 }
    (out.real |> Num.isApproxEq (3 / 34) {}) && (out.imag |> Num.isApproxEq (-5 / 34) {})

# Polar

## The absolute value of a complex number, which is the distance from 0. Defined as |x + yi| = √x² + y².
abs : Complex -> F64
abs = \z -> Num.sqrt ((z.real ^ 2) + (z.imag ^ 2))

expect
    out = abs { real: 3, imag: 4 }
    out |> Num.isApproxEq 5 {}

## The argument of a complex number, the angle from the positive x-axis.
arg : Complex -> F64
arg = \z -> 2.0 * Num.atan (z.imag / (z.real + (abs z)))

expect
    out = arg { real: 3, imag: 4 }
    out |> Num.isApproxEq (Num.atan (4 / 3)) {}

## Convert a complex number to polar form.
toPolar : Complex -> { r : F64, arg : F64 }
toPolar = \z -> { r: abs z, arg: arg z }

expect
    out = toPolar { real: 3, imag: 4 }
    (out.r |> Num.isApproxEq 5 {}) && (out.arg |> Num.isApproxEq (Num.atan (4 / 3)) {})
