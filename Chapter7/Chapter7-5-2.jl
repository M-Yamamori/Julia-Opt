using JuMP, Juniper, Ipopt

optimizer = Juniper.Optimizer
nl_solver = optimizer_with_attributes(Ipopt.Optimizer, "print_level" => 0)

using LinearAlgebra # for the dot product

m = Model(optimizer_with_attributes(optimizer, "nl_solver"=>nl_solver))

v = [10, 20, 12, 23, 42]
w = [12, 45, 12, 22, 21]
@variable(m, x[1:5], Int)

@objective(m, Max, dot(v,x))

@NLconstraint(m, sum(w[i]*x[i]^2 for i=1:5) <= 45)   

optimize!(m)

println("x value: ", JuMP.value.(x))
println("Objective value: ", JuMP.objective_value(m))
println("Status: ", JuMP.termination_status(m))