function f(x)
  return (2x[1] - 3)^4 + (3x[1] - x[2])^2
end

using Optim
opt = optimize(f, [1.0, 3.0])
println("optimal x = ", opt.minimizer)
println("optimal f = ", opt.minimum)
println("Summary: ", Optim.summary(opt))