using DelimitedFiles

#Prepare the data
network_data = readdlm("simple_network.csv", ',')

start_node = round.(Int64,network_data[2:end, 1])
end_node = round.(network_data[2:end, 2])
c = network_data[2:end, 3]

origin = 1
destination = 5

#Count the number of nodes and Links
no_node = max(maximum(start_node), maximum(end_node))
no_link = length(start_node)


using LightGraphs

#A function of getting x vector from the state
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

#Create a graph
graph = Graph(no_node)
distmx = Inf * ones(no_node, no_node)

#Add links to the graph above
for i = 1:no_link
  add_edge!(graph, start_node[i], end_node[i])
  distmx[start_node[i], end_node[i]] = c[i]
end

#Apply Dijkstra algorism by using the package
state = dijkstra_shortest_paths(graph, origin, distmx)

#Get the shortest path
path = enumerate_paths(state, destination)
println("The shortest path is ", path)

#Get the x vector
x = getShortestX(state, start_node, end_node, origin, destination)
println("x vector is ", x)

#Print the cost
#From state
println("Cost is $(state.dists[destination])")
#From Computing c' * x
println("Cost is $(c' * x)")