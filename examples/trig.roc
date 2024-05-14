app [main] {
    cli: platform "https://github.com/roc-lang/basic-cli/releases/download/0.11.0/SY4WWMhWQ9NvQgvIthcv15AUeA7rAIJHAHgiaSHGhdY.tar.br",
    math: "../src/main.roc",
}

import cli.Stdout
import cli.Task
import math.Angle
import math.Trig

main =
    θ = Degrees 45
    Stdout.line! "sin of $(Angle.toStr θ) degrees is $(Trig.sin θ |> Num.toStr)."

    θᵣ = Angle.toRadians θ
    Stdout.line! "cos of $(Angle.toStr θᵣ) radians is $(Trig.cos θᵣ |> Num.toStr)."

    θₜ = Angle.toTurns θᵣ
    Stdout.line! "sin of $(Angle.toStr θₜ) turn is $(Trig.sin θₜ |> Num.toStr)."

    θᵧ = Angle.toGon θₜ
    Stdout.line! "cos of $(Angle.toStr θᵧ) gon is $(Trig.cos θᵧ |> Num.toStr)."
