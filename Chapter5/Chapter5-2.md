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
[BitArray](https://docs.julialang.org/en/v1/base/arrays/#Base.BitArray)

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

```rank(A)``` of LinearAlgebra package can return the rank of the matrix, so after ```m, n = size(A)```, ```@assert rank(A) == m``` tests the number of array of A and the rank.
```julia
julia> rank(A)
3
```
- Note  
[@assert](https://docs.julialang.org/en/v1/base/base/#Base.@assert)
```julia
julia> m = 3
3

julia> n = 2
2

julia> @assert m == n
ERROR: AssertionError: m == n
Stacktrace:
 [1] top-level scope at REPL[3]:1

julia> @assert m == n "m not equals to n"
ERROR: AssertionError: m not equals to n
Stacktrace:
 [1] top-level scope at REPL[8]:1

julia> n = 3
3

julia> @assert m == n
```

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
- Note  
inv(B) is from LinearAlgebra package.

```julia
julia> A = [7 3 4 1 1 0 0 ;
           2 1 1 5 0 1 0 ;
           1 4 5 2 0 0 1 ]
3×7 Array{Int64,2}:
 7  3  4  1  1  0  0
 2  1  1  5  0  1  0
 1  4  5  2  0  0  1

julia> b_idx = [2, 5, 6]
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

Now, we need to see if the current basis can lead to a feasible solution. It means we need to check current ***x_B*** is nonnegative. We can use isnonnegative function here.

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
<br>

Suppose we have following ***c***, ***A***, and ***b***.   
```
c = [-3; -2; -1; -5; 0; 0; 0]
A = [7 3 4 1 1 0 0 ;
     2 1 1 5 0 1 0 ;
     1 4 5 2 0 0 1 ]
b = [7; 3; 8]
```
Then, the result of ```search_BFS(c, A, b)``` is
```
Basis:[1, 2, 3]
         x_B = [0.2500000000000001, 4.75, -2.25]
         nonnegative? false
Basis:[1, 2, 4]
         x_B = [0.1724137931034483, 1.8793103448275859, 0.15517241379310343]
         nonnegative? true
         obj = -5.051724137931034
Basis:[1, 2, 5]
         x_B = [0.5714285714285714, 1.857142857142857, -2.571428571428572]  
         nonnegative? false
Basis:[1, 2, 6]
         x_B = [0.16000000000000003, 1.9599999999999997, 0.7200000000000002]
         nonnegative? true
         obj = -4.3999999999999995
Basis:[1, 2, 7]
         x_B = [-1.9999999999999982, 6.999999999999998, -18.0]
         nonnegative? false
Basis:[1, 3, 4]
         x_B = [0.12162162162162149, 1.4729729729729728, 0.2567567567567568]
         nonnegative? true
         obj = -3.121621621621621
Basis:[1, 3, 5]
         x_B = [0.7777777777777779, 1.4444444444444444, -4.222222222222222]
         nonnegative? false
Basis:[1, 3, 6]
         x_B = [0.09677419354838701, 1.5806451612903225, 1.225806451612903]
         nonnegative? true
         obj = -1.8709677419354835
Basis:[1, 3, 7]
         x_B = [5.000000000000002, -7.0000000000000036, 38.000000000000014]
         nonnegative? false
Basis:[1, 4, 5]
         x_B = [34.000000000000014, -13.000000000000005, -218.00000000000009]
         nonnegative? false
Basis:[1, 4, 6]
         x_B = [0.46153846153846145, 3.769230769230769, -16.769230769230766]
         nonnegative? false
Basis:[1, 4, 7]
         x_B = [0.9696969696969696, 0.2121212121212121, 6.6060606060606055]
         nonnegative? true
         obj = -3.9696969696969693
Basis:[1, 5, 6]
         x_B = [8.0, -49.0, -13.0]
         nonnegative? false
Basis:[1, 5, 7]
         x_B = [1.5, -3.5, 6.5]
         nonnegative? false
Basis:[1, 6, 7]
         x_B = [1.0, 1.0, 7.0]
         nonnegative? true
         obj = -3.0
Basis:[2, 3, 4]
         x_B = [-4.5, 5.0, 0.5]
         nonnegative? false
Basis:[2, 3, 5]
         x_B = [7.0, -4.0, 2.0]
         nonnegative? false
Basis:[2, 3, 6]
         x_B = [-3.0, 4.0, 2.0]
         nonnegative? false
Basis:[2, 3, 7]
         x_B = [5.0, -2.0, -2.0]
         nonnegative? false
Basis:[2, 4, 5]
         x_B = [1.888888888888889, 0.2222222222222222, 1.1111111111111107]
         nonnegative? true
         obj = -4.888888888888889
Basis:[2, 4, 6]
         x_B = [3.0, -2.0, 10.0]
         nonnegative? false
Basis:[2, 4, 7]
         x_B = [2.2857142857142856, 0.14285714285714285, -1.4285714285714297]
         nonnegative? false
Basis:[2, 5, 6]
         x_B = [2.0, 1.0, 1.0]
         nonnegative? true
         obj = -4.0
Basis:[2, 5, 7]
         x_B = [3.0, -2.0, -4.0]
         nonnegative? false
Basis:[2, 6, 7]
         x_B = [2.333333333333333, 0.666666666666667, -1.3333333333333321]
         nonnegative? false
Basis:[3, 4, 5]
         x_B = [1.4782608695652175, 0.3043478260869565, 0.7826086956521738]
         nonnegative? true
         obj = -3.0
Basis:[3, 4, 6]
         x_B = [1.9999999999999996, -1.0, 5.999999999999993]
         nonnegative? false
Basis:[3, 4, 7]
         x_B = [1.6842105263157896, 0.26315789473684215, -0.9473684210526301]
         nonnegative? false
Basis:[3, 5, 6]
         x_B = [1.6, 0.5999999999999996, 1.4]
         nonnegative? true
         obj = -1.6
Basis:[3, 5, 7]
         x_B = [3.0, -5.0, -7.0]
         nonnegative? false
Basis:[3, 6, 7]
         x_B = [1.75, 1.25, -0.75]
         nonnegative? false
Basis:[4, 5, 6]
         x_B = [4.0, 3.0, -17.0]
         nonnegative? false
Basis:[4, 5, 7]
         x_B = [0.6000000000000001, 6.4, 6.8]
         nonnegative? true
         obj = -3.0000000000000004
Basis:[4, 6, 7]
         x_B = [7.0, -32.0, -6.0]
         nonnegative? false
Basis:[5, 6, 7]
         x_B = [7.0, 3.0, 8.0]
         nonnegative? true
         obj = 0.0
([0.1724137931034483, 1.8793103448275859, 0.0, 0.15517241379310343, 0.0, 0.0, 0.0], -5.051724137931034)
```