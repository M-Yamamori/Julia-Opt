using JuMP, GLPK

m = Model(GLPK.Optimizer)

@variable(m, 0 <= x1 <= 10)
@variable(m, x2 >= 0)
@variable(m, x3 >= 0)

@objective(m, Max, x1 + 2x2 + 5x3)

@constraint(m, constraint1, -x1 + x2 + 3x3 <= -5)
@constraint(m, constraint2, x1 + 3x2 - 7x3 <= 10)

println(m)

JuMP.optimize!(m)

println("Optimal Solutions: ")
println("x1 = ", JuMP.value(x1))
println("x2 = ", JuMP.value(x2))
println("x3 = ", JuMP.value(x3))

println("Dual Variables:")
println("dual1 = ", JuMP.shadow_price(constraint1))
println("dual2 = ", JuMP.shadow_price(constraint2))