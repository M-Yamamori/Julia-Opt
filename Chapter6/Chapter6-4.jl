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

#Prepare the sets of nodes and links and variables
N = Set(1:no_node)
links = Tuple((start_node[i], end_node[i]) for i in 1:no_link)
A = Set(links)
c_dict = Dict(links .=> c)

function my_dijkstra(N, A, c_dict)
    #Prepare an array
    w = Array{Float64}(undef, no_node)

    #Step 0
    w[origin] = 0
    X = Set{Int}([origin])
    Xbar = setdiff(N, X)

    #Iterations for Dijkstra's algorithm
    while !isempty(Xbar)
      #Step 1
      XX = Set{Tuple{Int,Int}}()
      for i in X, j in Xbar
        if (i,j) in A
          push!(XX, (i,j))
        end
      end

      #Step 2
      min_value = Inf
      q = 0
      for (i,j) in XX
        if w[i] + c_dict[(i,j)] < min_value
          min_value = w[i] + c_dict[(i,j)]
          q = j
        end
      end

      #Step 3
      w[q] = min_value
      push!(X, q)

      #Step 4
      Xbar = setdiff(N, X)
    end

    return w
end

#Apply the Dijkstra function
w = my_dijkstra(N, A, c_dict)

#Print the result
println("The length of node $origin to node $destination is: ", w[destination])