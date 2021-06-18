using Optim

f(x) = (2x[1] - 3)^4 + (3x[1] - x[2])^2

lower = [2.0, 6.0]
upper = [5.0, 10.0]
initial_x = [3.0, 7.0]
inner_optimizer = GradientDescent()
results = optimize(f, lower, upper, initial_x, Fminbox(inner_optimizer))

print(results)