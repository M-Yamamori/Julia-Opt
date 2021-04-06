using CSV, DataFrames

network_data = CSV.read("simple_network.csv", DataFrame)
network_data2 = CSV.read("simple_network_2.csv", DataFrame)

start_node = network_data[:, 1]
end_node = network_data[:, 2]
c = network_data[:, 3]
u = network_data[:, 4]

b = network_data2[:, 2]

no_node = max(maximum(start_node), maximum(end_node))
no_link = length(start_node)

nodes = 1:no_node
links = Tuple((start_node[i], end_node[i]) for i in 1:no_link)
c_dict = Dict(links .=> c)
u_dict = Dict(links .=> u)

include("mcnf.jl")
using Main.MCNF
x_star, obj = MCNF.minimal_cost_network_flow(nodes, links, c_dict, u_dict, b)

println("min_cost = $obj")
println("x_star = $(x_star.data)")