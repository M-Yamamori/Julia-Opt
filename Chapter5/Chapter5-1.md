## 5.2 Searching All Basic Feasible Solutions  
In this chapter, we try to search all BFS.  
<br>
First, I want to think about ```isnonnegative function```.  
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
[About BitArray](https://docs.julialang.org/en/v1/base/arrays/#Base.BitArray-Tuple{UndefInitializer,Vararg{Integer,N}%20where%20N}
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

Therefore, the ```isnonnegative function``` can judge whether the given vector is nonnegative or not.
```julia
function isnonnegative(x::Array{Float64, 1})
  return length( x[ x .< 0] ) == 0
end
```

<br>

