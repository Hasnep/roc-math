module [
    Complex,
    i,
    zero,
    from_real,
    from_imag,
    from_tuple,
    to_tuple,
    add,
    sub,
    mul,
    div,
    reciprocal,
    abs,
    arg,
    to_polar,
    is_approx_eq,
]

## A complex number z = x + yi, where i = √-1.
Complex : { real : F64, imag : F64 }

# Constructors

## The imaginary unit.
i : Complex
i = { real: 0, imag: 1 }

## The complex number z = 0 + 0i.
zero : Complex
zero = { real: 0, imag: 0 }

## Convert a number x to a complex number z = x + 0i.
from_real : Num * -> Complex
from_real = |real| { real: Num.to_f64(real), imag: 0 }

expect
    out = from_real(3)
    out |> is_approx_eq({ real: 3, imag: 0 }, {})

## Convert a number y to a complex number z = 0 + yi.
from_imag : Num * -> Complex
from_imag = |imag| { real: 0, imag: Num.to_f64(imag) }

expect
    out = from_imag(4)
    out |> is_approx_eq({ real: 0, imag: 4 }, {})

# Tuples

## Convert two numbers x and y to a complex number z = x + yi. The inverse of [toTuple].
from_tuple : (Num *, Num *) -> Complex
from_tuple = |(real, imag)| { real: Num.to_f64(real), imag: Num.to_f64(imag) }

expect
    out = from_tuple((3, 4))
    out |> is_approx_eq({ real: 3, imag: 4 }, {})

## Convert a complex number z = x + yi to a tuple `(x, y)`. The inverse of [fromTuple].
to_tuple : Complex -> (F64, F64)
to_tuple = |z| (z.real, z.imag)

expect
    (out_real, out_imag) = to_tuple({ real: 3, imag: 4 })
    out_real |> Num.is_approx_eq(3, {}) and out_imag |> Num.is_approx_eq(4, {})

# Arithmetic

## Add two complex numbers together.
add : Complex, Complex -> Complex
add = |x, y| { real: x.real + y.real, imag: x.imag + y.imag }

expect
    out = add({ real: 3, imag: 5 }, { real: 1, imag: 2 })
    out |> is_approx_eq({ real: 4, imag: 7 }, {})

## Subtract one complex number from another.
sub : Complex, Complex -> Complex
sub = |x, y| { real: x.real - y.real, imag: x.imag - y.imag }

expect
    out = sub({ real: 3, imag: 5 }, { real: 1, imag: 2 })
    out |> is_approx_eq({ real: 2, imag: 3 }, {})

## Multiply two complex numbers together.
mul : Complex, Complex -> Complex
mul = |x, y| {
    real: (x.real * y.real) - (x.imag * y.imag),
    imag: (x.real * y.imag) + (x.imag * y.real),
}

expect
    out = mul({ real: 3, imag: 5 }, { real: 1, imag: 2 })
    out |> is_approx_eq({ real: -7, imag: 11 }, {})

## Divide one complex number by another.
div : Complex, Complex -> Complex
div = |w, z|
    z_abs_squared = (z.real ^ 2) + (z.imag ^ 2)
    real = ((w.real * z.real) + (w.imag * z.imag)) / z_abs_squared
    imag = ((w.imag * z.real) - (w.real * z.imag)) / z_abs_squared
    { real, imag }

expect
    out = div({ real: 3, imag: 5 }, { real: 1, imag: 2 })
    out |> is_approx_eq({ real: 13 / 5, imag: -1 / 5 }, {})

## The reciprocal of a non-zero complex number.
reciprocal : Complex -> Complex
reciprocal = |z|
    z_abs_squared = (z.real ^ 2) + (z.imag ^ 2)
    { real: z.real / z_abs_squared, imag: (-z.imag) / z_abs_squared }

expect
    out = reciprocal({ real: 3, imag: 5 })
    out |> is_approx_eq({ real: 3 / 34, imag: -5 / 34 }, {})

# Polar

## The absolute value of a complex number, which is the distance from 0. Defined as |x + yi| = √x² + y².
abs : Complex -> F64
abs = |z| Num.sqrt(((z.real ^ 2) + (z.imag ^ 2)))

expect
    out = abs({ real: 3, imag: 4 })
    out |> Num.is_approx_eq(5, {})

## The argument of a complex number, the angle from the positive x-axis.
arg : Complex -> F64
arg = |z| 2.0 * Num.atan((z.imag / (z.real + (abs(z)))))

expect
    out = arg({ real: 3, imag: 4 })
    out |> Num.is_approx_eq(Num.atan((4 / 3)), {})

## Convert a complex number to polar form.
to_polar : Complex -> { r : F64, arg : F64 }
to_polar = |z| { r: abs(z), arg: arg(z) }

expect
    out = to_polar({ real: 3, imag: 4 })
    (out.r |> Num.is_approx_eq(5, {}))
    and (out.arg |> Num.is_approx_eq(Num.atan((4 / 3)), {}))

## Check if two complex numbers are approximately equal.
is_approx_eq : Complex, Complex, { rtol ?? F64, atol ?? F64 } -> Bool
is_approx_eq = |x, y, { rtol ?? 0.00001, atol ?? 0.00000001 }|
    (x.real |> Num.is_approx_eq(y.real, { rtol, atol })) and (x.imag |> Num.is_approx_eq(y.imag, { rtol, atol }))
