app [main!] {
    cli: platform "https://github.com/roc-lang/basic-cli/releases/download/0.19.0/Hj-J_zxz7V9YurCSTFcFdu6cQJie4guzsPMUi5kBYUk.tar.br",
    math: "../src/main.roc",
}

import cli.Stdout
import math.Angle
import math.Trig

main! = |_|
    θ = Degrees 45
    _ = Stdout.line! "sin of ${Angle.to_str(θ)} degrees is ${Num.to_str(Trig.sin(θ))}."

    θᵣ = Angle.to_radians θ
    _ = Stdout.line! "cos of ${Angle.to_str(θᵣ)} radians is ${Num.to_str(Trig.cos(θᵣ))}."

    θₜ = Angle.to_turns θᵣ
    _ = Stdout.line! "sin of ${Angle.to_str(θₜ)} turn is ${Num.to_str(Trig.sin(θₜ))}."

    θᵧ = Angle.to_gon θₜ
    Stdout.line! "cos of ${Angle.to_str(θᵧ)} gon is ${Num.to_str(Trig.cos(θᵧ))}."
