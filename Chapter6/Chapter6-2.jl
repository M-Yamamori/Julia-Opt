using CSV, DataFrames, JuMP, GLPK

#Read the CSV file
data1 = CSV.read("transportation_1.csv", DataFrame; header = 0)
data2 = CSV.read("transportation_2.csv", DataFrame; header = 0)

#Arrange the data
s_node_name = data2[1:2, 1]
s = data2[1:2, 2]

d_node_name = data2[3:5, 1]
d = data2[3:5, 2]

c = data1[:, :]

#Creat the dictionary by JuMP
s_dict = Dict(s_node_name .=> s)
d_dict = Dict(d_node_name .=> d)
c_dict = Dict((s_node_name[i], d_node_name[j]) => c[i,j] for i in 1:length(s_node_name), j in 1:length(d_node_name))

#Creat the optimization model by JuMP and GLPK
tp = Model(GLPK.Optimizer)

@variable(tp, x[s_node_name, d_node_name] >= 0)
@objective(tp, Min, sum(c_dict[i,j]*x[i,j] for i in s_node_name, j in d_node_name))
for i in s_node_name
  @constraint(tp, sum(x[i,j] for j in d_node_name) == s_dict[i])
end
for j in d_node_name
  @constraint(tp, sum(x[i,j] for i in s_node_name) == d_dict[j])
end

#Print and solve the problem
print(tp)
JuMP.optimize!(tp)
obj = JuMP.objective_value(tp)
x_star = JuMP.value.(x)

#Print the results
for s in s_node_name, d in d_node_name
  println("from $s to $d: ", x_star[s, d])
end