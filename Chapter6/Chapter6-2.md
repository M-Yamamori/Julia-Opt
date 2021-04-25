## 6.2 The Transportation Problem  

First, we read the CSV file.  
```julia
using DelimitedFiles

data = readdlm("transportation.csv", ',')
```
```julia
julia> data
4×5 Matrix{Any}:
   ""  ""         15           12          13
   ""  ""           "Chicago"    "Denver"    "Erie"
 15    "Austin"   10            7           9
 25    "Buffalo"   4            9           8
```
[DelimitFiles package](https://docs.julialang.org/en/v1/stdlib/DelimitedFiles/) allows us to read the CSV file type Any matrix.  

Then, we want to arrange the data from Any matrix to Array except for c.  
```julia
s_node_name = data[3:4, 2]
s = data[3:4, 1]

d_node_name = data[2, 3:5]
d = data[1, 3:5]

c = data[3:4, 3:5]
```
<br>

We create the dictionaries  
```julia
s_dict = Dict(s_node_name .=> s)
d_dict = Dict(d_node_name .=> d)
c_dict = Dict((s_node_name[i], d_node_name[j]) => c[i,j] for i in 1:length(s_node_name), j in 1:length(d_node_name))
```
We also prepare the optimizer model, variables, objective, and constraints by using JuMP and GLPK.  
```julia
tp = Model(GLPK.Optimizer)

@variable(tp, x[s_node_name, d_node_name] >= 0)
@objective(tp, Min, sum(c_dict[i,j]*x[i,j] for i in s_node_name, j in d_node_name))
for i in s_node_name
  @constraint(tp, sum(x[i,j] for j in d_node_name) == s_dict[i])
end
for j in d_node_name
  @constraint(tp, sum(x[i,j] for i in s_node_name) == d_dict[j])
end
```
<br>

All that is left is to solve the problem.  
```julia
print(tp)
JuMP.optimize!(tp)
obj = JuMP.objective_value(tp)
x_star = JuMP.value.(x)

for s in s_node_name, d in d_node_name
  println("from $s to $d: ", x_star[s, d])
end
```
<br>

The result will be following.
```julia
Min 10 x[Austin,Chicago] + 7 x[Austin,Denver] + 9 x[Austin,Erie] + 4 x[Buffalo,Chicago] + 9 x[Buffalo,Denver] + 8 x[Buffalo,Erie]
Subject to
 x[Austin,Chicago] + x[Austin,Denver] + x[Austin,Erie] == 15.0
 x[Buffalo,Chicago] + x[Buffalo,Denver] + x[Buffalo,Erie] == 25.0
 x[Austin,Chicago] + x[Buffalo,Chicago] == 15.0
 x[Austin,Denver] + x[Buffalo,Denver] == 12.0
 x[Austin,Erie] + x[Buffalo,Erie] == 13.0
 x[Austin,Chicago] >= 0.0
 x[Buffalo,Chicago] >= 0.0
 x[Austin,Denver] >= 0.0
 x[Buffalo,Denver] >= 0.0
 x[Austin,Erie] >= 0.0
 x[Buffalo,Erie] >= 0.0
from Austin to Chicago: 0.0
from Austin to Denver: 12.0
from Austin to Erie: 3.0
from Buffalo to Chicago: 15.0
from Buffalo to Denver: 0.0
from Buffalo to Erie: 10.0
```
<br>

- Note  
   - What is in the JuMP package.  
