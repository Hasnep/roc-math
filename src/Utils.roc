module [unwrap, square]

unwrap = |result, message|
    when result is
        Ok(x) -> x
        Err(_) -> crash(message)

square = |x| x |> Num.to_f64 |> Num.pow(2)
