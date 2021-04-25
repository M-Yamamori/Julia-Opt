## 6.4 Implementing Dijkstra’s Algorithm  

In this section, we will implement Dijkstra’s algorithm by ourself.  
<br>

We prepare the data in the same way as 6.3.  
```julia
using DelimitedFiles

network_data = readdlm("simple_network.csv", ',')

start_node = round.(Int64,network_data[2:end, 1])
end_node = round.(Int64, network_data[2:end, 2])
c = network_data[2:end, 3]

origin = 1
destination = 5

no_node = max(maximum(start_node), maximum(end_node))
no_link = length(start_node)
```
<br>

Then, we want the sets of nodes and links.  
```julia
N = Set(1:no_node)
```
[```Set()```](https://docs.julialang.org/en/v1/base/collections/#Base.Set) will construct a set of the values given, or an empty set.  
```julia
links = Tuple((start_node[i], end_node[i]) for i in 1:no_link)
A = Set(links)
```
Here, the set of links is a set of tuples.  
```julia
julia> N
Set{Int64} with 5 elements:
  5
  4
  2
  3
  1
```
```julia
julia> A
Set{Tuple{Int64, Int64}} with 8 elements:
  (4, 5)
  (1, 2)
  (5, 2)
  (1, 3)
  (4, 1)
  (3, 4)
  (2, 3)
  (3, 5)
```
<br>

We also want to make a dictionary of A and c.  
```julia
c_dict = Dict(links .=> c)
```
```julia
julia> c_dict
Dict{Tuple{Int64, Int64}, Int64} with 8 entries:
  (4, 5) => 2
  (1, 2) => 2
  (5, 2) => 4
  (1, 3) => 5
  (4, 1) => 0
  (3, 4) => 1
  (2, 3) => 3
  (3, 5) => 2
```
<br>

In our function of Dijkstra’s algorithm, we first get the weight, w from N, A, c_dict. We prepare the Array with the default value first, and add the each weight later.  
```julia
w = Array{Float64}(undef, no_node)
```
<br>

Start with step 0. The weight of origin node is 0. We prepare arrays X to store confirmed nodes and Xbar to store not confirmed nodes.  
```julia
w[origin] = 0
X = Set{Int}([origin])
Xbar = setdiff(N, X)
```

For the iterations in Steps 1 to 4, we want to  use a while-loop like follows.  
```julia
while !isempty(Xbar)
  #Step 1 Find links between X and Xbar
  #Step 2 Find a link which weight + cost is minimal
  #Step 3 Update the weight of nodes
  #Step 4 Update Xbar
end
```
<br>

In step 0, we find the set of nodes, named XX.  
```julia
XX = Set{Tuple{Int,Int}}()
  for i in X, j in Xbar
    if (i,j) in A #A is the set of links
      push!(XX, (i,j))
    end
  end
```
```push!()``` will push the second argument to the set of first argument.  

In step 2, we want to find the minimal weight + cost along XX.  
```julia
min_value = Inf
q = 0
for (i,j) in XX
  if w[i] + c_dict[(i,j)] < min_value
    min_value = w[i] + c_dict[(i,j)]
    q = j
  end
end
```
```q``` is the node number which has minimal value so far. We first set default value as min_value and q. In the for loop, if we find smaller value, we update it.  

After we finish to search the minimal value, in the step 3, we update the weight and X.  
```julia
w[q] = min_value
push!(X, q)
```

Then, we need to update Xbar, too.  
```julia
Xbar = setdiff(N, X)
```

The while-loop will evaluate if Xbar is empty or not again to determine to continue or stop. When the loop stops, we will get ```w[destination]``` as the length of the shortest path from origin to destination.  
<br>
<br>

When we apply this function to the data, the result will be following.  
```julia
w = my_dijkstra(N, A, c_dict)
println("The length of node $origin to node $destination is: ", w[destination])
```
```julia
The length of node 1 to node 5 is: 7.0
```