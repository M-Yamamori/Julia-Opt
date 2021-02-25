## 5.2 Searching All Basic Feasible Solutions  
In this chapter, we try to search all BFS.  
<br>
First, I want to think about isnonnegative function.  
<br>

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


```julia
function search_BFS(c, A, b)
    m, n = size(A)
    @assert rank(A) == m

    opt_x = zeros(n) #n-zero vector
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
- Note  
[@assert](https://docs.julialang.org/en/v1/base/base/#Base.@assert)
