# Chapter 6 Network Optimization Problems  
In this chapter, we will find some common network optimization problems and learn how we can code them in Julia.  
<br>

## 6.1 The Minimal-Cost Network-Flow Problem  
First, we read and arrange the CSV files with the data of nodes, "simple_network.csv" and "simple_network_2.csv". We use CSV package and DataFrames package.  
```julia
using CSV, DataFrames
network_data = CSV.read("simple_network.csv", DataFrame)
network_data2 = CSV.read("simple_network_2.csv", DataFrame)
```
We can read CSV files by using ```CSV.read("path", DataFrame)```. You may need to specify all the path to the CSV file.  
```
8×4 DataFrame
 Row │ start node i  end node j  c_ij   u_ij    
     │ Int64         Int64       Int64  Float64 
─────┼──────────────────────────────────────────
   1 │            1           2      2    Inf
   2 │            1           3      5    Inf
   3 │            2           3      3    Inf
   4 │            3           4      1    Inf
   5 │            3           5      2      1.0
   6 │            4           1      0    Inf
   7 │            4           5      2    Inf
   8 │            5           2      4    Inf
```
```
5×2 DataFrame
 Row │ node i  b_i   
     │ Int64   Int64 
─────┼───────────────
   1 │      1     -5
   2 │      2     10
   3 │      3      0
   4 │      4     -2
   5 │      5     -3
```
In [DataFrame package](https://dataframes.juliadata.org/stable/), there are tools for working with tabular data.   
<br>

Then we assign each vectors by the data.  
```julia
start_node = network_data[:, 1]
end_node = network_data[:, 2]
c = network_data[:, 3]
u = network_data[:, 4]
b = network_data2[:, 2]
```
<br>

We want to know the number of nodes and links(edges). When the numbering starts from 1st node and all positive integers are used without missing any number in the middle, we know that the biggest integer used in start_node and end_node is equal, and it is equal to the number of all nodes in the graph. We can count the number of links easily. It is simply the number of elements in start_node, or end_node, and they should be same.  
```julia
no_node = max(maximum(start_node), maximum(end_node))
no_link = length(start_node)
```
- Note  
  ```max``` is used to compare two different numbers and ```maximum``` is used to identify the biggest number among all elements in a vector.  
<br>

Then we want to create array objects of the set of nodes N and links A.  
```julia
nodes = 1:no_node
links = Tuple((start_node[i], end_node[i]) for i in 1:no_link)
```
```Tuple``` returns tuple.  
```
julia> links
8-element Array{Tuple{Int64,Int64},1}:
 (1,2)
 (1,3)
 (2,3)
 (3,4)
 (3,5)
 (4,1)
 (4,5)
 (5,2)
```

- Note  
  - Array  
    An array is an ordered collection of elements. We can create arrays that is full or empty and that had different types value or specific type value. ***Arrays are mutable***.  
  - Tuple  
    A tuple is an ordered sequence of elements. In julia Tuple is better to use for small fixed-length collections. ***Tuples are immutable.***  
<br>

We use this ```links``` array to make a model of the minimal-cost network-flow problem. We prepare dictionaries of c and u.  
```julia
c_dict = Dict(links .=> c)
u_dict = Dict(links .=> u)
```
[Dict](https://docs.julialang.org/en/v1/base/collections/#Base.Dict) will make a hash table.  
- Note  
  Hash table is a data structure that implements an associative array with abstract data type.  

```julia
julia> c_dict
Dict{Tuple{Int64,Int64},Int64} with 8 entries:
  (3, 5) => 2
  (4, 5) => 2
  (1, 2) => 2
  (2, 3) => 3
  (5, 2) => 4
  (4, 1) => 0
  (1, 3) => 5
  (3, 4) => 1

julia> u_dict
Dict{Tuple{Int64,Int64},Float64} with 8 entries:
  (3, 5) => 1.0
  (4, 5) => Inf
  (1, 2) => Inf
  (2, 3) => Inf
  (5, 2) => Inf
  (4, 1) => Inf
  (1, 3) => Inf
  (3, 4) => Inf
```
<br>


Now we are ready to write the minimal-cost network-flow problem by using [JuMP Package](https://jump.dev/JuMP.jl/v0.21.1/quickstart/#Quick-Start-Guide-1) and [GLPK Package](https://juliapackages.com/p/glpk).  
<br>

First, we create an optimization model.  
```julia
mcnf = Model(GLPK.Optimizer)
```
This [Model](https://jump.dev/JuMP.jl/v0.21.1/solvers/#JuMP.Model-Tuple{Any}) is a part of JuMP package. It return a new JuMP model with the provided optimizer. ```GLPK.Optimizer``` can create a new optimizer object.  
```julia
julia> mcnf
A JuMP Model
Feasibility problem with:
Variables: 0
Model mode: AUTOMATIC
CachingOptimizer state: EMPTY_OPTIMIZER
Solver name: GLPK
```

There are still no variables and an objective, so we define and add the decision variables and the objective.  
```julia
@variable(mcnf, 0 <= x[link in links] <= u_dict[link])
@objective(mcnf, Min, sum(c_dict[link] * x[link] for link in links))
```
[JuMP variables](https://jump.dev/JuMP.jl/v0.21.1/variables/#Variables-1) can have an [extension to add lower and upper bounds](https://jump.dev/JuMP.jl/v0.21.1/variables/#Variable-bounds-1) to each optimization variable. We can set the objective by ```@objective(model::Model, sense, func)```.  
<br>

Now, we move on to an important point, we add the flow conservation constraints.
```julia
for i in nodes
  @constraint(mcnf, sum(x[(ii,j)] for (ii,j) in links if ii == i) - sum(x[(j,ii)] for (j,ii) in links if ii == i) == b[i])
end
```
where ii is a dummy index for i. We can set the constraints by ```@constraint```, and arguments are model and constraints.  
- Note  
   - Dummy index means summation. -> Commonly used in programming? 
   - [More details of ```@constraint```](https://jump.dev/JuMP.jl/v0.21.1/constraints/#The-@constraint-macro-1)  
<br>

Then, what we have to do is to solve the problem by using JuMP.  
```julia
JuMP.optimize!(mcnf)
obj = JuMP.objective_value(mcnf)
x_star = JuMP.value.(x)
```
```JuMP.optimize!(Model::model)``` is a function to solve the given model. We can see the optimization result by ```JuMP.objective_value(mcnf)```. The primal solution can be obtained by calling ```JuMP.value.```. For the dual solution, the function is ```JuMP.dual.```.  
- Note  
  optimize! has !, so the mcnf is updated.  
<br>


The result of Chapter6-1-1.jl
```
min_cost = 45.0
x_star = [0.0, 0.0, 10.0, 9.0, 1.0, 5.0, 2.0, 0.0]
```
<br>

The result of Chapter6-1-2.jl
```
Min 2 x[(1, 2)] + 5 x[(1, 3)] + 3 x[(2, 3)] + x[(3, 4)] + 2 x[(3, 5)] + 2 x[(4,
5)] + 4 x[(5, 2)]
Subject to
 x[(1, 2)] + x[(1, 3)] - x[(4, 1)] == -5.0
 -x[(1, 2)] + x[(2, 3)] - x[(5, 2)] == 10.0
 -x[(1, 3)] - x[(2, 3)] + x[(3, 4)] + x[(3, 5)] == 0.0
 -x[(3, 4)] + x[(4, 1)] + x[(4, 5)] == -2.0
 -x[(3, 5)] - x[(4, 5)] + x[(5, 2)] == -3.0
 x[(1, 2)] >= 0.0
 x[(1, 3)] >= 0.0
 x[(2, 3)] >= 0.0
 x[(3, 4)] >= 0.0
 x[(3, 5)] >= 0.0
 x[(4, 1)] >= 0.0
 x[(4, 5)] >= 0.0
 x[(5, 2)] >= 0.0
 x[(1, 2)] <= Inf
 x[(1, 3)] <= Inf
 x[(2, 3)] <= Inf
 x[(3, 4)] <= Inf
 x[(3, 5)] <= 1.0
 x[(4, 1)] <= Inf
 x[(4, 5)] <= Inf
 x[(5, 2)] <= Inf
The optimal objective function value is = 45.0
x_star is [0.0, 0.0, 10.0, 9.0, 1.0, 5.0, 2.0, 0.0]
```
