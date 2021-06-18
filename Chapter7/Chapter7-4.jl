using JuMP, Ipopt, Juniper

optimizer = Juniper.Optimizer
nl_solver = optimizer_with_attributes(Ipopt.Optimizer, "print_level" => 0)

m = Model(optimizer_with_attributes(optimizer, "nl_solver" => nl_solver))

@variable(m, x>=0)
@variable(m, y[1:2])
@variable(m, s[1:5]>=0)
@variable(m, l[1:5]>=0)

@objective(m, Min, -x -3y[1] + 2y[2])

@constraint(m, -2x +  y[1] + 4y[2] + s[1] ==  16)
@constraint(m,  8x + 3y[1] - 2y[2] + s[2] ==  48)
@constraint(m, -2x +  y[1] - 3y[2] + s[3] == -12)
@constraint(m,       -y[1]         + s[4] ==   0)
@constraint(m,        y[1]         + s[5] ==   4)
@constraint(m, -1 + l[1] + 3l[2] +  l[3] - l[4] + l[5] == 0)
@constraint(m,     4l[2] - 2l[2] - 3l[3]               == 0)
for i in 1:5
  @NLconstraint(m, l[i] * s[i] == 0)
end

optimize!(m)

println("x value: ", JuMP.value.(x))
println("Objective value: ", JuMP.objective_value(m))
println("Status: ", JuMP.termination_status(m))

println("Optimal y = ", JuMP.value.(y))
println("Optimal s = ", JuMP.value.(s))
println("Optimal l = ", JuMP.value.(l))