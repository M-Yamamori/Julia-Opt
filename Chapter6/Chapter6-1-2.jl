using CSV, DataFrames, JuMP, GLPK

#Data preparations
network_data = CSV.read("simple_network.csv", DataFrame)
network_data2 = CSV.read("simple_network_2.csv", DataFrame)

start_node = network_data[:, 1]
end_node = network_data[:, 2]
c = network_data[:, 3]
u = network_data[:, 4]

b = network_data2[:, 2]

#Assignments of number of nodes and number of links
no_node = max(maximum(start_node), maximum(end_node))
no_link = length(start_node)

#Creat a graph
nodes = 1:no_node
links = Tuple((start_node[i], end_node[i]) for i in 1:no_link)
c_dict = Dict(links .=> c)
u_dict = Dict(links .=> u)

#Prepare an optimization model
mcnf = Model(GLPK.Optimizer)

#Define decision the variables and the objective
@variable(mcnf, 0<= x[link in links] <= u_dict[link])
@objective(mcnf, Min, sum( c_dict[link] * x[link] for link in links))

#Add the information of flow into the constraints
for i in nodes
  @constraint(mcnf, sum(x[(ii,j)] for (ii,j) in links if ii==i) - sum(x[(j,ii)] for (j,ii) in links if ii==i) == b[i])
end

#Solve
println(mcnf)
JuMP.optimize!(mcnf)
obj = JuMP.objective_value(mcnf)
x_star = JuMP.value.(x)

println("The optimal objective function value is = $obj")
println("x_star is $(x_star.data)")