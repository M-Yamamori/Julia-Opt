# Chapter 7 General Optimization Problems  
In this chapter, we will learn a few more packages that are useful in solving optimization problems.  
<br>

## 7.1 Unconstrained Optimization  
We first look at [Optim package](https://julianlsolvers.github.io/Optim.jl/stable/). This package implements basic optimization algorithms, mainly for un-constraint nonlinear optimization problems.  
<br>

### 7.1.1 Line search  
More advanced problems often require solving sub-problems, which are mostly line search problems.  
<br>

Consider to solve the following [line search problem](https://scrapbox.io/kklab-ise-ag/Chapter_7).  
<br>

We first define x_bar and d_bar.  
```julia
x_bar = [2.0, 3.0]
d_bar = [-1.0, 0.0]
```
<br>

```julia
function f_line(x_bar, d_bar, lambda)
  x_new = x_bar + lambda*d_bar
  return (2x_new[1] - 3)^4 + (3x_new[1] - x_new[2])^2
end
```
Here, f_line is a function of lambda. x_bar and d_bar are regarded as constant parameters, or optional arguments for optimization respect to lambda.  
<br>

When you want to create a function that depends on the current x_bar and d_bar value and accepts only one argument, lambda, you can use this code.  
```julia
lambda -> f_line(x_bar, d_bar, lambda)
```
<br>

Then, we will optimize the function in the interval [0.0, 1.0] by using ***Golden Section line search algorithm*** which is in Optim package.  
```julia
using Optim
opt = optimize(lambda -> f_line(x_bar, d_bar, lambda), 0.0, 1.0, GoldenSection())
```
```julia
julia> opt
Results of Optimization Algorithm
 * Algorithm: Golden Section Search
 * Search Interval: [0.000000, 1.000000]
 * Minimizer: 8.489384e-01
 * Minimum: 4.425767e-01
 * Iterations: 36
 * Convergence: max(|x - x_upper|, |x - x_lower|) <= 2*(1.5e-08*|x|+2.2e-16): true
 * Objective Function Calls: 37
```
```optimize``` will accept defined function as the first argument, the point as the second, and the method as the third argument. If we do not specify the algorithm, the default algorithm, Nelder-Mead will be used.  
<br>

We can get the optimal lambda value by  
```julia
julia> Optim.minimizer(opt)
0.8489384490968053
```
The function value can be hold by
```julia
julia> Optim.minimum(opt)
0.44257665922759026
```
<br>
<br>


### 7.1.2 Unconstrained Optimization  
We consider the same function as 7.1.1, but this time, we will find a minimum value of this function.  
```julia
function f(x)
  return (2x[1] - 3)^4 + (3x[1] - x[2])^2
end
```
Optimize f(x) with an initial point [1.0, 3.0].
```julia
using Optim

opt = optimize(f, [1.0, 3.0])
```
```julia
julia> opt
 * Status: success

 * Candidate solution
    Final objective value:     4.958621e-09

 * Found with
    Algorithm:     Nelder-Mead

 * Convergence measures
    √(Σ(yᵢ-ȳ)²)/n ≤ 1.0e-08

 * Work counters
    Seconds run:   0  (vs limit Inf)
    Iterations:    29
    f(x) calls:    60
```
The optimal x is
```julia
julia> opt.minimizer
2-element Vector{Float64}:
 1.4958064632784969
 4.487422627595517
```
<br>
<br>


### 7.1.3 Box-constrained Optimization  
When there are only lower and upper bound constraints, the optimization problems are called box-constrained.  
<br>

We consider the following [problem](https://scrapbox.io/kklab-ise-ag/Chapter_7).  
<br>

We first define the function, lower bound, upper bound, and initial point.  
```julia
f(x) = (2x[1] - 3)^4 + (3x[1] - x[2])^2

lower = [2.0, 6.0]
upper = [5.0, 10.0]
initial_x = [3.0, 7.0]
```
<br>

Then, we select the line search algorism which is required to solve box constrained problem.  
```
using Optim

inner_optimizer = GradientDescent()
```
<br>

Get the results.  
```julia
results = optimize(f, lower, upper, initial_x, Fminbox(inner_optimizer))

print(results)
```
```Fminbox()``` is one of the solvers available in this package, and it represents box constrained minimization.  
<br>

Inside of the ```Fminbox(inner_optimizer)``` is
```julia
julia> Fminbox(inner_optimizer)
Fminbox{GradientDescent{LineSearches.InitialPrevious{Float64}, LineSearches.HagerZhang{Float64, Base.RefValue{Bool}}, Nothing, Optim.var"#11#13"}, Float64, Optim.var"#47#49"}(GradientDescent{LineSearches.InitialPrevious{Float64}, LineSearches.HagerZhang{Float64, Base.RefValue{Bool}}, Nothing, Optim.var"#11#13"}(LineSearches.InitialPrevious{Float64}
  alpha: Float64 1.0
  alphamin: Float64 0.0
  alphamax: Float64 Inf
, LineSearches.HagerZhang{Float64, Base.RefValue{Bool}}
  delta: Float64 0.1
  sigma: Float64 0.9
  alphamax: Float64 Inf
  rho: Float64 5.0
  epsilon: Float64 1.0e-6
  gamma: Float64 0.66
  linesearchmax: Int64 50
  psi3: Float64 0.1
  display: Int64 0
  mayterminate: Base.RefValue{Bool}
, nothing, Optim.var"#11#13"(), Flat()), NaN, 0.001, Optim.var"#47#49"())
```
<br>

The result will be
```julia
 * Status: success

 * Candidate solution
    Final objective value:     6.250000e-02

 * Found with
    Algorithm:     Fminbox with Gradient Descent

 * Convergence measures
    |x - x'|               = 1.52e-01 ≰ 0.0e+00
    |x - x'|/|x'|          = 7.62e-02 ≰ 0.0e+00
    |f(x) - f(x')|         = 0.00e+00 ≤ 0.0e+00
    |f(x) - f(x')|/|f(x')| = 0.00e+00 ≤ 0.0e+00
    |g(x)|                 = 2.22e-16 ≤ 1.0e-08

 * Work counters
    Seconds run:   8  (vs limit Inf)
    Iterations:    7
    f(x) calls:    16597
    ∇f(x) calls:   16597
```
<br>
<br>
<br>


## 7.2 Convex Optimization  
By using juMP and [Ipopt package](https://www.zib.de/vigerske/ipopt3.14/index.html), we want to handle second-order conic programming (SOCP) which involves convex quadratic constraints and objective functions. We want to consider [this convex optimization problem](https://scrapbox.io/kklab-ise-ag/Chapter_7).  
<br>

We first create a model by Ipopt optimizer.  
```julia
using JuMP, Ipopt
m = Model(Ipopt.Optimizer)
```
<br>

Then, add variable, nonlinear objective function, and constraints.  
```julia
@variable(m, x[1:2])
@NLobjective(m, Min, (x[1]-3)^3 + (x[2]-4)^2)
@NLconstraint(m, (x[1]-1)^2 + (x[2]+1)^3 + exp(-x[1]) <= 1)
```
This time, the objective function and constraint function is not linear, so we use ```@NLobjective``` and ```@NLconstraint``` macros.  
- Note  
   ```julia
   julia> @objective(m, Min, (x[1]-3)^3 + (x[2]-4)^2)
   ERROR: Only exponents of 0, 1, or 2 are currently supported. Are you trying to build a nonlinear problem? Make sure you use @NLconstraint/@NLobjective.
   ```

```
julia> m
A JuMP Model
Minimization problem with:
Variables: 2
Objective function type: Nonlinear
Nonlinear: 1 constraint
Model mode: AUTOMATIC
CachingOptimizer state: EMPTY_OPTIMIZER
Solver name: Ipopt
Names registered in the model: x
```
<br>

Optimize it and print the results.
```julia
JuMP.optimize!(m)
println("** Optimal objective function value = ", JuMP.objective_value(m))
println("** Optimal solution = ", JuMP.value.(x))
```
```julia
******************************************************************************
This program contains Ipopt, a library for large-scale nonlinear optimization.
 Ipopt is released as open source code under the Eclipse Public License (EPL).
         For more information visit https://github.com/coin-or/Ipopt
******************************************************************************

This is Ipopt version 3.13.4, running with linear solver mumps.
NOTE: Other linear solvers might be more efficient (see Ipopt documentation).

Number of nonzeros in equality constraint Jacobian...:        0
Number of nonzeros in inequality constraint Jacobian.:        2
Number of nonzeros in Lagrangian Hessian.............:        4

Total number of variables............................:        2
                     variables with only lower bounds:        0
                variables with lower and upper bounds:        0
                     variables with only upper bounds:        0
Total number of equality constraints.................:        0
Total number of inequality constraints...............:        1
        inequality constraints with only lower bounds:        0
   inequality constraints with lower and upper bounds:        0
        inequality constraints with only upper bounds:        1

iter    objective    inf_pr   inf_du lg(mu)  ||d||  lg(rg) alpha_du alpha_pr  ls
   0 -1.1000000e+01 2.00e+00 1.03e+01  -1.0 0.00e+00    -  0.00e+00 0.00e+00   0
   1 -2.7940943e+00 7.05e-01 3.15e+00  -1.0 5.31e-01    -  1.00e+00 1.00e+00h  1
   2  3.0252074e+00 1.24e-01 1.20e+00  -1.0 2.96e-01    -  1.00e+00 1.00e+00h  1
   3  4.4351082e+00 0.00e+00 1.50e-01  -1.0 5.43e-02    -  1.00e+00 1.00e+00h  1
   4  4.4112067e+00 0.00e+00 2.19e-04  -2.5 8.60e-03    -  1.00e+00 1.00e+00h  1
   5  4.4092612e+00 0.00e+00 2.49e-07  -3.8 1.69e-04    -  1.00e+00 1.00e+00f  1
   6  4.4091126e+00 0.00e+00 1.24e-09  -5.7 1.28e-05    -  1.00e+00 1.00e+00h  1
   7  4.4091108e+00 0.00e+00 1.95e-13  -8.6 1.59e-07    -  1.00e+00 1.00e+00h  1

Number of Iterations....: 7

                                   (scaled)                 (unscaled)
Objective...............:   4.4091107643665541e+00    4.4091107643665541e+00
Dual infeasibility......:   1.9539925233402755e-13    1.9539925233402755e-13
Constraint violation....:   0.0000000000000000e+00    0.0000000000000000e+00
Complementarity.........:   2.5060365853569629e-09    2.5060365853569629e-09
Overall NLP error.......:   2.5060365853569629e-09    2.5060365853569629e-09


Number of objective function evaluations             = 8
Number of objective gradient evaluations             = 8
Number of equality constraint evaluations            = 0
Number of inequality constraint evaluations          = 8
Number of equality constraint Jacobian evaluations   = 0
Number of inequality constraint Jacobian evaluations = 8
Number of Lagrangian Hessian evaluations             = 7
Total CPU secs in IPOPT (w/o function evaluations)   =      3.249
Total CPU secs in NLP function evaluations           =      2.088

EXIT: Optimal Solution Found.
** Optimal objective function value = 4.409110764366554
** Optimal solution = [0.49239864764413793, -0.4918893479728137]
```
<br>

Ipopt package has [some more options](https://www.zib.de/vigerske/ipopt3.14/OPTIONS.html) to solve problems.  
<br>
<br>
<br>



## 7.3 Nonlinear Optimization  
A general nonlinear optimization problem, which is potentially nonconvex, can also be modeled by JuMP and solved by Ipopt.  
<br>

We consider [this problem](https://scrapbox.io/kklab-ise-ag/Chapter_7).  
<br>

### 7.3.1 Using Ipopt package  
We first make a model of JuMP using Ipopt as an optimizer.  
```julia
using JuMP, Ipopt
m = Model(Ipopt.Optimizer)
```
```julia
julia> m
A JuMP Model
Feasibility problem with:
Variables: 0
Model mode: AUTOMATIC
CachingOptimizer state: EMPTY_OPTIMIZER
Solver name: Ipopt
```
<br>

Then, we add variables, objective, and constraint.  
```julia
@variable(m, x[1:2])
@NLobjective(m, Min, (x[1]-3)^3 + (x[2]-4)^2)
@NLconstraint(m, (x[1]-1)^2 + (x[2]+1)^3 + exp(-x[1]) <= 1)
```
<br>

After we add them, model m looks like following.
```julia
julia> m
A JuMP Model
Minimization problem with:
Variables: 2
Objective function type: Nonlinear
Nonlinear: 1 constraint
Model mode: AUTOMATIC
CachingOptimizer state: EMPTY_OPTIMIZER
Solver name: Ipopt
Names registered in the model: x
```
<br>

We optimize it and print the results.  
```julia
optimize!(m)

println("Optimal objective function value = ", getobjectivevalue(m))
println("Optimal solution = ", JuMP.value.(x))
```
<br>

The result was,
```julia
******************************************************************************
This program contains Ipopt, a library for large-scale nonlinear optimization.
 Ipopt is released as open source code under the Eclipse Public License (EPL).
         For more information visit https://github.com/coin-or/Ipopt
******************************************************************************

This is Ipopt version 3.13.4, running with linear solver mumps.
NOTE: Other linear solvers might be more efficient (see Ipopt documentation). 

Number of nonzeros in equality constraint Jacobian...:        0
Number of nonzeros in inequality constraint Jacobian.:        2
Number of nonzeros in Lagrangian Hessian.............:        4

Total number of variables............................:        2
                     variables with only lower bounds:        0
                variables with lower and upper bounds:        0
                     variables with only upper bounds:        0
Total number of equality constraints.................:        0
Total number of inequality constraints...............:        1
        inequality constraints with only lower bounds:        0
   inequality constraints with lower and upper bounds:        0
        inequality constraints with only upper bounds:        1

iter    objective    inf_pr   inf_du lg(mu)  ||d||  lg(rg) alpha_du alpha_pr  ls
   0 -1.1000000e+01 2.00e+00 1.03e+01  -1.0 0.00e+00    -  0.00e+00 0.00e+00   0
   1 -2.7940943e+00 7.05e-01 3.15e+00  -1.0 5.31e-01    -  1.00e+00 1.00e+00h  1
   2  3.0252074e+00 1.24e-01 1.20e+00  -1.0 2.96e-01    -  1.00e+00 1.00e+00h  1
   3  4.4351082e+00 0.00e+00 1.50e-01  -1.0 5.43e-02    -  1.00e+00 1.00e+00h  1
   4  4.4112067e+00 0.00e+00 2.19e-04  -2.5 8.60e-03    -  1.00e+00 1.00e+00h  1
   5  4.4092612e+00 0.00e+00 2.49e-07  -3.8 1.69e-04    -  1.00e+00 1.00e+00f  1
   6  4.4091126e+00 0.00e+00 1.24e-09  -5.7 1.28e-05    -  1.00e+00 1.00e+00h  1
   7  4.4091108e+00 0.00e+00 1.95e-13  -8.6 1.59e-07    -  1.00e+00 1.00e+00h  1

Number of Iterations....: 7

                                   (scaled)                 (unscaled)
Objective...............:   4.4091107643665541e+00    4.4091107643665541e+00
Dual infeasibility......:   1.9539925233402755e-13    1.9539925233402755e-13
Constraint violation....:   0.0000000000000000e+00    0.0000000000000000e+00
Complementarity.........:   2.5060365853569629e-09    2.5060365853569629e-09
Overall NLP error.......:   2.5060365853569629e-09    2.5060365853569629e-09


Number of objective function evaluations             = 8
Number of objective gradient evaluations             = 8
Number of equality constraint evaluations            = 0
Number of inequality constraint evaluations          = 8
Number of equality constraint Jacobian evaluations   = 0
Number of inequality constraint Jacobian evaluations = 8
Number of Lagrangian Hessian evaluations             = 7
Total CPU secs in IPOPT (w/o function evaluations)   =      3.349
Total CPU secs in NLP function evaluations           =      2.192

EXIT: Optimal Solution Found.

Optimal objective function value = 4.409110764366554
Optimal solution = [0.49239864764413793, -0.4918893479728137]
```
<br>
<br>


### 7.3.2 Using NLopt package  
Here, we want to use [NLopt package](https://nlopt.readthedocs.io/en/latest/) to solve same problem.  
```julia
using JuMP, NLopt
m = Model(NLopt.Optimizer)
set_optimizer_attribute(m, "algorithm", :LD_SLSQP)

@variable(m, x[1:2])
@NLobjective(m, Min, (x[1]-3)^3 + (x[2]-4)^2)
@NLconstraint(m, (x[1]-1)^2 + (x[2]+1)^3 + exp(-x[1]) <= 1)

JuMP.optimize!(m)

println("Optimal objective function value = ", getobjectivevalue(m))
println("Optimal solution = ", JuMP.value.(x))
```
<br>

In this package, we can specify the algorithm to solve. LD_SLSQP which we just used is a sequential quadratic programming (SQP) algorithm for non-linearly constrained gradient-based optimization.  
<br>

```julia
Optimal objective function value = 4.409110147457113
Optimal solution = [0.49239867641633484, -0.4918892188875157]
```
<br>

- Note  
   Ipopt package only provides interior point line search filter method. Compared to Ipopt package's result, the objective function value is almost same.  

<br>
<br>
<br>



## 7.4 Non-convex Nonlinear Optimization  
JuMP package also used to model general non-convex non-linear optimization problems. As an example, consider a bi-level optimization problem of [following form](https://scrapbox.io/kklab-ise-ag/Chapter_7)  

The last constraints are called complementarity conditions, which originate from Karush-Kuhn-Tucker optimality conditions of the original lower-level problem.  
<br>

We will use JuMP, Ipopt, and [Juniper package](https://lanl-ansi.github.io/Juniper.jl/stable/). Juniper package is a solver for Mixed Integer Non-Linear Programs.  

```julia
using JuMP, Ipopt, Juniper
```
<br>

We first specify the optimizer and solver.  
```julia
optimizer = Juniper.Optimizer
nl_solver = optimizer_with_attributes(Ipopt.Optimizer, "print_level" => 0)
```
```[optimizer_with_attributes](https://jump.dev/JuMP.jl/v0.21.1/solvers/#JuMP.optimizer_with_attributes)``` groups an optimizer constructor with the list of attributes attrs.  
<br>

Construct a model, and add variables, objective, and constraints.  
```julia
m = Model(optimizer_with_attributes(optimizer, "nl_solver" => nl_solver))

@variable(m, x >= 0)
@variable(m, y[1:2])
@variable(m, s[1:5] >= 0)
@variable(m, l[1:5] >= 0)

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
```
<br>

Optimize it, and print the results.  
```julia
optimize!(m)

println("x value: ", JuMP.value.(x))
println("Objective value: ", JuMP.objective_value(m))
println("Status: ", JuMP.termination_status(m))

println("Optimal y = ", JuMP.value.(y))
println("Optimal s = ", JuMP.value.(s))
println("Optimal l = ", JuMP.value.(l))
```
<br>

The results will be,  
```julia
nl_solver         : MathOptInterface.OptimizerWithAttributes(Ipopt.Optimizer, Pair{MathOptInterface.AbstractOptimizerAttribute, Any}[MathOptInterface.RawParameter("print_level") => 0])
feasibility_pump  : false
log_levels        : [:Options, :Table, :Info]

#Variables: 13
#IntBinVar: 0 
Obj Sense: Min


******************************************************************************
This program contains Ipopt, a library for large-scale nonlinear optimization.
 Ipopt is released as open source code under the Eclipse Public License (EPL).
         For more information visit https://github.com/coin-or/Ipopt
******************************************************************************

Start values are not feasible.
Status of relaxation: LOCALLY_SOLVED
Time for relaxation: 39.18899989128113
Relaxation Obj: -13.0
Obj: -13.0
x value: 5.0
Objective value: -13.0
Status: LOCALLY_SOLVED
Optimal y = [4.0, 2.0]
Optimal s = [14.000000000000002, 3.124559263812904e-40, 0.0, 4.0, 3.674756895796766e-40]
Optimal l = [3.6734198463196485e-40, 0.18181828966247998, 0.12121219310831999, 0.0, 0.3333329379042401]
```
<br>
<br>
<br>



## 7.5 Mixed Integer Nonlinear Programming  
Let all variables in the previous section to integer variables, and solve again.  

Juniper package recommends to specify a MIP solver. If we use it, the feasibility pump is used to find a feasible solution before the branch and bound part starts. This is highly effective.  
- Note  
   The feasibility pump is a heuristic that finds an initial feasible solution even in hard mixed integer programming problems.  

   Actually, I could not get the optimal solution without specifying MIP solver.  
<br>

```julia
using JuMP, Ipopt, Juniper
```
<br>

We create a model after setting the optimizer, non-linear solver, and MIP solver.  
```julia
using Cbc
optimizer = Juniper.Optimizer
nl_solver= optimizer_with_attributes(Ipopt.Optimizer, "print_level" => 0)
mip_solver = optimizer_with_attributes(Cbc.Optimizer, "logLevel" => 0)
m = Model(optimizer_with_attributes(optimizer, "nl_solver" => nl_solver, "mip_solver" => mip_solver))
```
[Cbc package](https://juliahub.com/docs/Cbc/ARPfV/0.6.7/) is an interface to the COIN-OR Branch and Cut solver.  
<br>

Set the variables.  
```julia
@variable(m, x >= 0, Int)
@variable(m, y[1:2], Int)
@variable(m, s[1:5] >= 0, Int)
@variable(m, l[1:5] >= 0, Int)
```
In JuMP package, we can add the condition such as Integer and binary in the arguments.  
<br>

Then, we set objective and constraints.  
```julia
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
```
<br>

Optimize and print the results.  
```julia
optimize!(m)

println("x value: ", JuMP.value.(x))
println("Objective value: ", JuMP.objective_value(m))
println("Status: ", JuMP.termination_status(m))

println("Optimal y = ", JuMP.value.(y))
println("Optimal s = ", JuMP.value.(s))
println("Optimal l = ", JuMP.value.(l))
```
```
nl_solver   : MathOptInterface.OptimizerWithAttributes(Ipopt.Optimizer, Pair{MathOptInterface.AbstractOptimizerAttribute, Any}[MathOptInterface.RawParameter("print_level") => 0])
mip_solver  : MathOptInterface.OptimizerWithAttributes(Cbc.Optimizer, Pair{MathOptInterface.AbstractOptimizerAttribute, Any}[MathOptInterface.RawParameter("logLevel") => 0])
log_levels  : [:Options, :Table, :Info]

#Variables: 13
#IntBinVar: 13
Obj Sense: Min


******************************************************************************
This program contains Ipopt, a library for large-scale nonlinear optimization.
 Ipopt is released as open source code under the Eclipse Public License (EPL).
         For more information visit https://github.com/coin-or/Ipopt
******************************************************************************

Start values are not feasible.
Status of relaxation: LOCALLY_SOLVED
Time for relaxation: 45.48099994659424
Relaxation Obj: -13.0

       MIPobj              NLPobj       Time
=============================================
       0.9697               0.0         25.0 

FP: 25.983999967575073 s
FP: 1 round
FP: Obj: -13.0
Obj: -13.0
x value: 5.0
Objective value: -13.0
Status: LOCALLY_SOLVED
Optimal y = [4.0, 2.0]
Optimal s = [14.0, 0.0, 0.0, 4.0, 0.0]
Optimal l = [0.0, 0.0, 0.0, 0.0, 1.0]
```