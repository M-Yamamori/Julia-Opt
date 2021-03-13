## 5.5 Implementing the Simplex Method  
In this section, we implement the Simplex Method. We will try to mimic the pivoting in tableau form.  

In outline, we start from deciding a initial BFS, then make the tableau from the BFS. While the tableau show the optimal solution, we repeat pivoting and renew the tableau.  

First, we create a custom datatype which stores information of the tableau. we can define the datatype by [struct](https://docs.julialang.org/en/v1/base/base/#struct) or [mutable struct](https://docs.julialang.org/en/v1/base/base/#mutable%20struct). By ```struct```, we cannot change the value of the member variables, and ```mutable struct``` can.
```julia
mutable struct SimplexTableau
  z_c     ::Array{Float64}
  Y       ::Array{Float64}
  x_B     ::Array{Float64}
  obj     ::Float64
  b_idx   ::Array{Int64}
end
```
