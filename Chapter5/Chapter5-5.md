## 5.5 Implementing the Simplex Method  
In this section, we implement the Simplex Method. We will try to mimic the pivoting in tableau form.  

In outline,  
1)we start from deciding a initial BFS,  
2)then make the tableau from the BFS.  
3)While the tableau shows the optimal solution, we repeat pivoting and renew the tableau.  

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
<br>


Then we want to make a function like follows.
```julia
function simplex_method(c, A, b)
  tableau = initialize(c, A, b)

  while !isOptimal(tableau)
    pivoting!(tableau)
  end

  #compute opt_x (x*) from tableau

  opt_x = zeros(length(c))
  opt_x[tableau.b_idx] = tableau.x_B

  return opt_x, tableau.obj
end
```
```initialize``` will find an initial BFS and create the tableau from the BFS. ```isOptimal``` checks whether the current tableau is optimal or not. If the tableau is not optimal, then we move on to ```pivoting!```. If the tableau is optimal, we terminate the while loop and return the optimal solution.  
<br>

### 5.5.1 initialize function  
The first thing to do in this function is to make it sure that all inputs c, A, and b are arrays of Float64.  
```julia
c = Array{Float64}(c)
A = Array{Float64}(A)
b = Array{Float64}(b)
```

To find an initial BFS, we create new function ```initial_BFS```.  
```julia
function initial_BFS(A, b)
  m, n = size(A)

  comb = collect(combinations(1:n, m)) # m-vectors
  for i in length(comb):-1:1
    b_idx = comb[i]
    B = A[:, b_idx]
    x_B = inv(B) * b
    if isnonnegative(x_B)
      return b_idx, x_B, B
    end
  end

  error("Infeasible")
end
```
In this function, we just search for a possible combination of basis until we find a BFS. [error](https://docs.julialang.org/en/v1/base/base/#Base.error) will give the message, when an ErrorException rises.  

- Note  
  ```-1``` in ```for i in length(comb):-1:1``` means count down.
  ```julia
  julia> for i in 5:-1:1
             println(i)
         end
  5
  4
  3
  2
  1
  ```

```isnonnegative``` function is same as Chapter5.2.  
```julia
function is_nonnegative(x::Vector)
  return length(x[x .< 0]) == 0
end
```
<br>

Once we obtain b_idx, x_B, and B from initial_BFS, we compute all necessary values.  
```julia
Y = inv(B) * A
c_B = c[b_idx]
obj = dot(c_B, x_B)

z_c = zeros(1,n)
n_idx = setdiff(1:n, b_idx)
z_c[n_idx] = c_B' * inv(B) * A[:, n_idx] - c[n_idx]'
```
In the above code, ```b_idx``` represents the current set of indices for basic variables, and ```n_idx``` represents the set of indices for non-basic variables. [setdiff](https://docs.julialang.org/en/v1/base/collections/#Base.setdiff) function will construct the set of elements in the array of the first argument but not in the array of second argument.  
```julia
julia> setdiff([1,2,3,4], [0,2,4,6])
2-element Vector{Int64}:
 1
 3
```
<br>

Finally, create an object of SimplexTableau type from the BFS, and return it.  
```julia
return SimplexTableau(z_c, Y, x_B, obj, b_idx)
```
<br>

To sum up, the complete initialize function is shown below.  
```julia
function initialize(c, A, b)
  c = Array{Float64}(c)
  A = Array{Float64}(A)
  b = Array{Float64}(b)

  m, n = size(A)

  b_idx, x_B, B = initial_BFS(A,b)

  Y = inv(B) * A
  c_B = c[b_idx]
  obj = dot(c_B, x_B)

  z_c = zeros(1,n)
  n_idx = setdiff(1:n, b_idx)
  z_c[n_idx] = c_B' * inv(B) * A[:,n_idx] - c[n_idx]'

  return SimplexTableau(z_c, Y, x_B, obj, b_idx)
end
```
<br>


### 5.5.2 isOptimal function  
Checking the current tableau is optimal is simple. We examine the z_c field of tableau has any positive element.  
```julia
function isOptimal(t::SimplexTableau)
  return nonpositive(tableau.z_c)
end

function is_nonpositive(z::Array)
     return length(z[ z .> 0]) == 0
end
```
<br>


### 5.5.3 pivoting! function  
The exclamation mark implies that the function changes the content of the argument. Pivoting will change the values in the current tableau by row operations. We first determine the entering and exiting variable using the pivot_point function.  
```julia
function pivot_point(t::SimplexTableau)
  # Find the entering variable index
  entering = ...

  # Do min ratio test and find the exiting variable index
  exiting = ...

  return entering, exiting
end
```
<br>

Finding the entering variable is easily done by searching zj − cj > 0.  
```julia
entering = findfirst(t.z_c .>0)
```
```findfirst``` returns the first element of the array which satisfies the condition shown in the bracket, so here, we select the smallest index with zj − cj > 0.  
<br>

Considering mini ratio test, we first find rows with yik > 0.  
```julia
pos_idx = findall(t.Y[:, entering] .> 0)
```
[findall](https://docs.julialang.org/en/v1/base/arrays/#Base.findall-Tuple{Any}) will return a array that satisfies the condition in the bracket. If there are no element of A, it will return an empty array.  
- Note  
  ```entering = findfirst(t.z_c .> 0)[2]```  <-- 2nd element is better?  
<br>

When all elements of t.Y are nonnegative, the problem is unbounded.  
```julia
if length(pos_idx) == 0
  error("Unbounded")
end
```
<br>

Now, we decide the exiting variable.  
```julia
exiting = pos_idx[argmin(t.x_B[pos_idx] ./ t.Y[pos_idx, entering])]
```
[argmin](https://docs.julialang.org/en/v1/base/collections/#Base.argmin) will return the minimal elements. If there are multiple minimal elements, it will return a minimal index.  
<br>

The complete code of pivot_point! is this.  
```julia
function pivot_point(t::SimplexTableau)
  entering = findfirst(t.z_c .> 0)[2]
  if entering == 0
    error("Optimal")
  end

  pos_idx = findall(t.Y[:, entering] .> 0)
  if length(pos_idx) == 0
    error("Unbounded")
  end
  exiting = pos_idx[argmin(t.x_B[pos_idx] ./ t.Y[pos_idx, entering])]

  return entering, exiting
end
```
<br>

We have determined entering and exiting variables, now we make the value of the pivot point equal to 1.  
```julia
coef = t.Y[exiting, entering]
t.Y[exiting, :] /= coef
t.x_B[exiting] /= coef
```
Note that we are changing the contents of the input argument t, and this is why the function name is pivoting!.  
For all other rows in t.Y, we make the values equal to zero by row operations.  
```julia
for i in setdiff(1:m, exiting)
  coef = t.Y[i, entering]
  t.Y[i, :] -= coef * t.Y[exiting, :]
  t.x_B[i] -= coef * t.x_B[exiting]
end
```

We update ith row to make t.Y[i, entering] zero, and we apply row operation to the z_c row and obj.  
```julia
coef = t.z_c[entering]
t.z_c -= coef * t.Y[exiting, :]'
t.obj -= coef * t.x_B[exiting]
```

```'``` is the transpose operator. This is because t.Y[exiting, :] returns a column vector, while we want a row vector.  
<br>

Finally, we update b_idx that represents the indices of basic variables.  
```julia
t.b_idx[find(t.b_idx .== t.b_idx[exiting])] = entering
```
<br>

Complete code of pivoting! is shown below.
```julia
function pivoting!(t::SimplexTableau)
  m, n = size(t.Y)

  entering, exiting = pivot_point(t)
  println("Pivoting: entering = x_$entering, exiting = x_$(t.b_idx[exiting])")

  coef = t.Y[exiting, entering]
  t.Y[exiting, :] /= coef
  t.x_B[exiting] /= coef

  for i in setdiff(1:m, exiting)
    coef = t.Y[i, entering]
    t.Y[i, :] -= coef * t.Y[exiting, :]
    t.x_B[i] -= coef * t.x_B[exiting]
  end

  coef = t.z_c[entering]
  t.z_c -= coef * t.Y[exiting, :]'
  t.obj -= coef * t.x_B[exiting]

  t.b_idx[ findfirst(t.b_idx .== t.b_idx[exiting]) ] = entering
end
```
<br>


### 5.5.4 Creating a Module  
We create a module of this simplex method code. We want only the simplex_method function is accessible from the outside, so we export simplex_method.  
after the module was created and saved in simplex_method.jl, one can use the module as follows.  
```julia
include("simplex_method.jl")
using Main.SimplexMethod

SimplexMethod.simplex_method(c, A, b)
```
<br>


When we think following vectors and matrix,  
```
c = [-3; -2; -1; -5; 0; 0; 0]
A = [7 3 4 1 1 0 0 ;
     2 1 1 5 0 1 0 ;
     1 4 5 2 0 0 1 ]
b = [7; 3; 8]
```
the result will be
```
------+-------------------------------------------------+-------
      |  3.00   2.00   1.00   5.00   0.00   0.00   0.00 |   0.00
------+-------------------------------------------------+-------
x[ 5] |  7.00   3.00   4.00   1.00   1.00   0.00   0.00 |   7.00
x[ 6] |  2.00   1.00   1.00   5.00   0.00   1.00   0.00 |   3.00
x[ 7] |  1.00   4.00   5.00   2.00   0.00   0.00   1.00 |   8.00
------+-------------------------------------------------+-------
Pivoting: entering = x_1, exiting = x_5
------+-------------------------------------------------+-------
      |  0.00   0.71  -0.71   4.57  -0.43   0.00   0.00 |  -3.00
------+-------------------------------------------------+-------
x[ 1] |  1.00   0.43   0.57   0.14   0.14   0.00   0.00 |   1.00
x[ 6] |  0.00   0.14  -0.14   4.71  -0.29   1.00   0.00 |   1.00
x[ 7] |  0.00   3.57   4.43   1.86  -0.14   0.00   1.00 |   7.00
------+-------------------------------------------------+-------
Pivoting: entering = x_2, exiting = x_7
------+-------------------------------------------------+-------
      |  0.00   0.00  -1.60   4.20  -0.40   0.00  -0.20 |  -4.40
------+-------------------------------------------------+-------
x[ 1] |  1.00   0.00   0.04  -0.08   0.16   0.00  -0.12 |   0.16
x[ 6] |  0.00   0.00  -0.32   4.64  -0.28   1.00  -0.04 |   0.72
x[ 2] |  0.00   1.00   1.24   0.52  -0.04   0.00   0.28 |   1.96
------+-------------------------------------------------+-------
Pivoting: entering = x_4, exiting = x_6
------+-------------------------------------------------+-------
      |  0.00   0.00  -1.31   0.00  -0.15  -0.91  -0.16 |  -5.05
------+-------------------------------------------------+-------
x[ 1] |  1.00   0.00   0.03   0.00   0.16   0.02  -0.12 |   0.17
x[ 4] |  0.00   0.00  -0.07   1.00  -0.06   0.22  -0.01 |   0.16
x[ 2] |  0.00   1.00   1.28   0.00  -0.01  -0.11   0.28 |   1.88
------+-------------------------------------------------+-------
```
<br>


- Note  
  [Printf](https://github.com/JuliaLang/julia/blob/master/stdlib/Printf/src/Printf.jl)

