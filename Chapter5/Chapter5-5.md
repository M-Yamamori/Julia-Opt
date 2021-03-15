## 5.5 Implementing the Simplex Method  
In this section, we implement the Simplex Method. We will try to mimic the pivoting in tableau form.  

In outline, we start from deciding a initial BFS, then make the tableau from the BFS. While the tableau show the optimal solution, we repeat pivoting and renew the tableau.  

First, we create a custom [datatype](https://docs.julialang.org/en/v1/devdocs/reflection/#DataType-fields) which stores information of the tableau. we can define the datatype by [struct](https://docs.julialang.org/en/v1/base/base/#struct) or [mutable struct](https://docs.julialang.org/en/v1/base/base/#mutable%20struct). By ```struct```, we cannot change the value of the member variables, and ```mutable struct``` can.
```julia
mutable struct SimplexTableau
  z_c     ::Array{Float64}
  Y       ::Array{Float64}
  x_B     ::Array{Float64}
  obj     ::Float64
  b_idx   ::Array{Int64}
end
```

```julia
julia> fieldnames(SimplexTableau)
(:z_c, :Y, :x_B, :obj, :b_idx)
```

```julia
z_c = [3 2 1 5 0 0 0]
Y = [7 3 4 1 1 0 0 ;
     2 1 1 5 0 1 0 ;
     1 4 5 2 0 0 1 ]
x_B = [7; 3; 8]
obj = 0
b_idx = [5, 6, 7]
tableau = SimplexTableau(z_c, Y, x_B, obj, b_idx)
```

```julia
julia> typeof(tableau)
SimplexTableau

julia> tableau.b_idx
3-element Array{Int64,1}:
 5
 6
 7
```

1. initialize(c, A, b)  
    - initial_BFS(A, b)  
    - is_nonnegative(x)  
    - print_tableau(t)  

2. isOptimal(tableau)  
    - is_nonpositive(c)  

3. pivoting!(tableau)  
    - print_tableau(t)  

