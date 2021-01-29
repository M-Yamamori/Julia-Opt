# 2.1 Linear Programming Problems

- Model  
Max $ x_1 + 2x_2 + 5x_3 $  
Subject to  
constraint1 : $ -x_1 + x_2 + 3x_3 \leq -5.0 $  
constraint2 : $ x_1 + 3x_2 - 7x_3 \leq 10.0 $  
$ x_1 \geq 0.0 $  
$ x_1 \leq 10.0 $  
$ x_2 \geq 0.0 $  
$ x_3 \geq 0.0 $  
<br>

- Code
```julia:2.1_LinearProgrammingPloblems.jl
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
```
<br>

- Result  
$ x_1 = 10.0 $  
$ x_2 = 2.1875 $  
$ x_3 = 0.9375 $  
Dual Variables:  
$ dual1 = 1.8125 $  
$ dual2 = 0.06249999999999998 $  
<br>