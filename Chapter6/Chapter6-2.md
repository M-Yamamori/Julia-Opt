First, we read the CSV file.  
```julia
using CSV, DataFrames
data1 = CSV.read("transportation_1.csv", DataFrame; header = 0)
data2 = CSV.read("transportation_2.csv", DataFrame; header = 0)
```
```julia
julia> data1
2×3 DataFrame
 Row │ Column1  Column2  Column3 
     │ Int64    Int64    Int64   
─────┼───────────────────────────
   1 │      10        7        9
   2 │       4        9        8

julia> data2
5×2 DataFrame
 Row │ Column1  Column2 
     │ String   Int64   
─────┼──────────────────
   1 │ Austin        15
   2 │ Buffalo       25
   3 │ Chicago       15
   4 │ Denver        12
   5 │ Erie          13
```

Then, we want to arrange the data from DataFrame to array except for c.  
```julia
s_node_name = data2[1:2, 1]
s = data2[1:2, 2]

d_node_name = data2[3:5, 1]
d = data2[3:5, 2]

c = data1[:, :]
```
- Note  
   If you take a row from the DataFrame, it will not be an array object but ```DataFrameRow```.
   ```julia
   julia> d = data1[1, 2:4]
   DataFrameRow
    Row │ Column2  Column3  Column4 
        │ Int64    Int64    Int64   
   ─────┼───────────────────────────
      1 │      15       12       13
   ```
<br>

We create the dictionaries by using JuMP package.  
```julia
s_dict = Dict(s_node_name .=> s)
d_dict = Dict(d_node_name .=> d)
c_dict = Dict((s_node_name[i], d_node_name[j]) => c[i,j] for i in 1:length(s_node_name), j in 1:length(d_node_name))
```
We also prepare the optimizer model and variables, objective, and constraints by using JuMP and GLPK.  
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
   - How to deal with the data file with String and Int generally.


https://dataframes.juliadata.org/v0.18/lib/types.html