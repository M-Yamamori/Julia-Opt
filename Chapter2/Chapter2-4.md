# 2.4 Mixed Integer Linear Programming (MILP) Problems
When variables are binary or discrete, the resulting optimization problem becomes an integer programming problem. Further, if all equations are linear and variables are integers and continuous, the optimization problem is called a mixed integer linear programming (MILP) problems.  

- Model  
Max [$ x_1 + 2x_2 + 5x_3]  
subject to  
constraint1 : [$ -x_1 + x_2 + 3x_3 \leq -5.0]  
constraint2 : [$ x_1 + 3x_2 - 7x_3 \leq 10.0]  
[$ 0.0 \leq x_1 \leq 10.0]  
[$ x_2 \geq 0.0, integer]  
[$ x_3 \in {0, 1}]  
(https://scrapbox.io/kklab-ise-ag/Chapter2-4)  
<br>

- Code  
```julia
using JuMP, GLPK

m = Model(GLPK.Optimizer)

@variable(m, 0 <= x1 <= 10)
@variable(m, x2 >= 0, Int) #Add Int
@variable(m, x3, Bin) #Add Bin

@objective(m, Max, x1 + 2x2 + 5x3)

@constraint(m, constraint1, -x1 +  x2 + 3x3 <= -5)
@constraint(m, constraint2,  x1 + 3x2 - 7x3 <= 10)

print(m)

JuMP.optimize!(m)

println("Optimal Solutions:")
println("x1 = ", JuMP.value(x1))
println("x2 = ", JuMP.value(x2))
println("x3 = ", JuMP.value(x3))
```
<br>

- Result  
Optimal Solutions:  
[$ x_1 = 10.0]  
[$ x_2 = 2.0]  
[$ x_3 = 1.0]  
(https://scrapbox.io/kklab-ise-ag/Chapter2-4)  
<br>

- Note  
In this package, we can also add information such as integer and binary to variables.