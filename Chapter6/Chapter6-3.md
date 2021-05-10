## 6.3 The Shortest Path Problem  
We first read the CSV file and set the data.  
```julia
using DelimitedFiles

network_data = readdlm("simple_network.csv", ',')

start_node = round.(Int64,network_data[2:end, 1])
end_node = round.(Int64, network_data[2:end, 2])
c = network_data[2:end, 3]

origin = 1
destination = 5
```

This time, we specify the Type, Int64. ```round.``` let as round the data.  
```julia
julia> start_node = network_data[2:end, 1]
8-element Vector{Any}:
 1
 1
 2
 3
 3
 4
 4
 5
```
```julia
julia> start_node = round.(Int64, network_data[2:end, 1])
8-element Vector{Int64}:
 1
 1
 2
 3
 3
 4
 4
 5
```
- Note  
  ```round.``` can round vectors. If you want to use ```round```, the following code is equivalent.  
  ```julia
  julia> for i = 1:7
           start_node[i] = round(Int64, network_data[i+1, 1])
         end
  
  julia> start_node
   8-element Vector{Int64}:
   1
   1
   2
   3
   3
   4
   4
   5
  ```
<br>

Then, we want to know the number of nodes and links(edges). We take the same way as 6.1.  
```julia
no_node = max(maximum(start_node), maximum(end_node))
no_link = length(start_node)
```
<br>

Now we use LightGraphs Package. This package implements Dijkstra’s algorithm.  
```julia
using LightGraph
```
First, we create a graph and add the links by using ```Graph``` method of the package.  
```julia
graph = Graph(no_node)
distmx = Inf * ones(no_node, no_node)

for i = 1:no_link
  add_edge!(graph, start_node[i], end_node[i])
  distmx[start_node[i], end_node[i]] = c[i]
end
```
```distmx``` is default weight.  
```julia
julia> graph
{5, 8} undirected simple Int64 graph

julia> distmx
5×5 Matrix{Float64}:
 Inf    2.0   5.0  Inf   Inf
 Inf   Inf    3.0  Inf   Inf
 Inf   Inf   Inf    1.0   2.0
  0.0  Inf   Inf   Inf    2.0
 Inf    4.0  Inf   Inf   Inf
```
<br>

Then, we apply the algorism to the graph.  
```julia
state = dijkstra_shortest_paths(graph, origin, distmx)
```
```julia
julia> state
LightGraphs.DijkstraState{Float64, Int64}([0, 1, 1, 3, 3], [0.0, 2.0, 5.0, 6.0, 7.0], [Int64[], Int64[], Int64[], Int64[], Int64[]], [1.0, 1.0, 2.0, 2.0, 2.0], Int64[])
```
<br>

We want to get the results, the shortest path as an ordered list of nodes and x vector which explains what links are used. The shortest path can get by using ```emurate_paths``` method in the package.  
```julia
path = enumerate_paths(state, destination)
```
However, we need to set a new method to get the x vector.  
```julia
function getShortestX(state, start_node, end_node, origin, destination)
  _x = zeros(Int, length(start_node))
  _path = enumerate_paths(state, destination)

  for i=1:length(_path)-1
    _start = _path[i]
    _end = _path[i+1]

    for j=1:length(start_node)
      if start_node[j]==_start && end_node[j]==_end
        _x[j] = 1
        break
      end
    end

  end
  _x
end
```
```julia
x = getShortestX(state, start_node, end_node, origin, destination)
```
<br>

We can get the cost from the state, but we also can calculate the cost by c' * x.  
```julia
println("Cost is $(state.dists[destination])")
println("Cost is $(c' * x)")
```
<br>

The result will be like following.  
```julia
The shortest path is [1, 3, 5]
x vector is [0, 1, 0, 0, 1, 0, 0, 0]
Cost is 7.0
Cost is 7
```
