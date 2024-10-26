using HarmonicBalance

@testset begin
    # define equation of motion
    @variables ω1, ω2, t, ω, F, γ, α1, α2, k, x(t), y(t)
    rhs = [
        d(x, t, 2) + ω1^2 * x + γ * d(x, t) + α1 * x^3 - k * y,
        d(d(y, t), t) + ω2^2 * y + γ * d(y, t) + α2 * y^3 - k * x,
    ]
    eqs = rhs .~ [F * cos(ω * t), 0]

    @test eqs != (rhs ~ [F * cos(ω * t), 0])
    @test eqs == (rhs .~ [F * cos(ω * t), 0])
    @test_throws ArgumentError DifferentialEquation(rhs ~ [F * cos(ω * t), 0], [x, y])
end

@testset begin
    @variables ω1, ω2, ωₘ, t, ω, F, γ, λ, x(t), y(t)
    eqs = [d(x, t, 2) + (ω1^2 - λ * cos(ωₘ * t)) * x + γ * d(x, t)]

    diff_eq = DifferentialEquation(eqs, [x])

    add_harmonic!(diff_eq, x, ω) # drive frequency, close to ω1

    harmonic_eq = get_harmonic_equations(diff_eq)
    varied = ω => range(0.7, 1.3, 100)
    @test_throws MethodError get_steady_states(harmonic_eq, varied, threading=true)
    @test_throws ArgumentError get_steady_states(harmonic_eq, Dict(varied), threading=true)
end
