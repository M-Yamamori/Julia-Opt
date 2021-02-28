## 5.2 Searching All Basic Feasible Solutions  
In this chapter, we try to search all BFS.  
<br>

First, we want to think about isnonnegative function.  

```x[x.<0]``` will return the elements of vector x that is less than 0, since ```x.<0``` is an element-wise comparison with 0.  

```julia
julia> x = [-1; 2; -2]
3-element Array{Int64,1}:
 -1
  2
 -2

julia> x.<0
3-element BitArray{1}:
 1
 0
 1

julia> x[x.<0]
2-element Array{Int64,1}:
 -1
 -2
```
- Note  
About [BitArray](https://docs.julialang.org/en/v1/base/arrays/#Base.BitArray-Tuple{UndefInitializer,Vararg{Integer,N}%20where%20N}
)

```length(x[x.<0])``` will return the number of the negative elements. 
```julia
julia> length(x[x.<0])
2
```

If the length is zero, then there is no negative element in x, which means vector x is nonnegative.
```julia
length(x[x.<0]) == 0
false
```

The case of given vector is nonnegative.
```julia
julia> x = [2; 1; 0]
3-element Array{Int64,1}:
 2
 1
 0

julia> x[x.<0]
0-element Array{Int64,1}

julia> length(x[x.<0]) == 0
true
```

Therefore, the isnonnegative function can judge whether the given vector is nonnegative or not.
```julia
function isnonnegative(x::Array{Float64, 1})
  return length( x[ x .< 0] ) == 0
end
```
<br>

Now, we want to think about search_BFS function.  
<br>

```size(A)``` will return the tuple of the array size.
```julia
julia> A = [7 3 4 1 1 0 0 ;
            2 1 1 5 0 1 0 ;
            1 4 5 2 0 0 1 ]
3×7 Array{Int64,2}:
 7  3  4  1  1  0  0
 2  1  1  5  0  1  0
 1  4  5  2  0  0  1

julia> size(A)
(3, 7)
```

```rank(A)``` of LinearAlgebra package can return the rank of the matrix, so ```@assert rank(A) == m``` tests the number of array of A and the rank.
```julia
julia> rank(A)
3
```
- Note  
[@assert](https://docs.julialang.org/en/v1/base/base/#Base.@assert)

To examine all combinations of the basis, we use Combinatorics package. This is an example of when we have n = 7 and m = 3.
```julia
julia> combinations(1:7, 3)
Base.Generator{Combinatorics.Combinations,Combinatorics.var"#reorder#10"{UnitRange{Int64}}}(Combinatorics.var"#reorder#10"{UnitRange{Int64}}(1:7), Combinatorics.Combinations(7, 3))

julia> collect( combinations(1:7, 3) )
35-element Array{Array{Int64,1},1}:
 [1, 2, 3]
 [1, 2, 4]
 [1, 2, 5]
 [1, 2, 6]
 [1, 2, 7]
 ⋮
 [3, 6, 7]
 [4, 5, 6]
 [4, 5, 7]
 [4, 6, 7]
 [5, 6, 7]
```
```combinations(1:n, m)``` generates an iterator object, and for which we can get the value by using ```collect``` function. Each above combination represents indices of columns in A.
- Note  
[collect function](https://docs.julialang.org/en/v1/base/collections/#Base.collect-Tuple{Any}) returns an array of all items in the iterator.

Then, we construct a for-loop to get basis matrix for each index, b_idx.
```julia
for b_idx in combinations(1:n, m)
  #Check whether the combination is BFS or not.
end
```

At this time, we can represent matrix ***B***, vector ***c_B*** and ***x_B*** as follows.
```
B = A[:, b_idx]
c_B = c[b_idx]
x_B = inv(B) * b
```

```julia
julia> A = [7 3 4 1 1 0 0 ;
           2 1 1 5 0 1 0 ;
           1 4 5 2 0 0 1 ]
3×7 Array{Int64,2}:
 7  3  4  1  1  0  0
 2  1  1  5  0  1  0
 1  4  5  2  0  0  1

julia> b_idx = [2,5,6]
3-element Array{Int64,1}:
 2
 5
 6

julia> A[:, b_idx]
3×3 Array{Int64,2}:
 3  1  0
 1  0  1
 4  0  0

julia> c = [-3; -2; -1; -5; 0; 0; 0]
7-element Array{Int64,1}:
 -3
 -2
 -1
 -5
  0
  0
  0

julia> c[b_idx]
3-element Array{Int64,1}:
 -2
  0
  0
```

Now, we need to see if the current basis implies a feasible solution. It means we need to check current ***x_B*** is nonnegative. We can use isnonnegative function here.

If we can see ***x_B*** is nonnegative, then we compare its objective function value with the smallest objective function value that is stored in obj.
```julia
z = dot(c_B, x_B)
    if z < obj
        obj = z
        opt_x = zeros(n)
        opt_x[b_idx] = x_B
    end
```
- Note  
```dot(c_B, x_B)``` of LinearAlgebra computes the inner product of ***c_B*** and ***x_B***.  
<br>

To sum up, we can get following codes.

```julia
function search_BFS(c, A, b)
    m, n = size(A)
    @assert rank(A) == m

    opt_x = zeros(n)
    obj = Inf

    for b_idx in combinations(1:n, m)
        B = A[:, b_idx]
        c_B = c[b_idx]
        x_B = inv(B) * b

        if is_nonnegative(x_B)
            z = dot(c_B, x_B)
            if z < obj
                obj = z
                opt_x = zeros(n)
                opt_x[b_idx] = x_B
            end
        end

        println("Basis:", b_idx)
        println("\t x_B = ", x_B)
        println("\t nonnegative? ", is_nonnegative(x_B))

        if is_nonnegative(x_B)
            println("\t obj = ", dot(c_B, x_B))
        end

    end

    return opt_x, obj
end
```

