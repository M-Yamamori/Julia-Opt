# 2.2 Alternative Ways of Writing LP Problems

- Model  
Max [$ \sum_{i=0}^3 c_ix_i]  
[$ \bm{c} = \begin{bmatrix} 1\\ 2\\ 5\\ \end{bmatrix}]  
Subject to  
[$ \bm{Ax} \leq \bm{b}]  
[$ \bm{A} = \begin{bmatrix} -1 1 3\\ 1 3 7\\ \end{bmatrix}]  
[$ \bm{b} = \begin{bmatrix} -5\\ 10\\ \end{bmatrix}]
[$ 0.0 \leq x_1 \leq 10.0]  
[$ x_2 \geq 0.0]  
[$ x_3 \geq 0.0]  
(https://scrapbox.io/kklab-ise-ag/Chapter2-2)
<br>

- Code
```julia
using JuMP, GLPK

m = Model(GLPK.Optimizer)

c = [ 1; 2; 5]
A = [-1  1  3; 1  3 -7]
b = [-5; 10]

@variable(m, x[1:3] >= 0)
@objective(m, Max, sum( c[i] * x[i] for i in 1:3) )

@constraint(m, constraint[j in 1:2], sum( A[j,i] * x[i] for i in 1:3 ) <= b[j] )
@constraint(m, bound, x[1] <= 10)

JuMP.optimize!(m)

println("Optimal Solutions:")
for i in 1:3
  println("x[$i] = ", JuMP.value(x[i]))
end

println("Dual Variables:")
for j in 1:2
  println("dual[$j] = ", JuMP.shadow_price(constraint[j]))
end
```
<br>

- Result  
Optimal Solutions:  
[$ x_1 = 10.0]  
[$ x_2 = 2.1875]  
[$ x_3 = 0.9375]  
Dual Variables:  
[$ dual_1 = 1.8125]  
[$ dual_2 = 0.06250000000000003]  
(https://scrapbox.io/kklab-ise-ag/Chapter2-2)
<br>

- Note  
```julia:2.1_LinearProgrammingPloblems.jl
for i in 1:3
  println("x[$i] = ", JuMP.value(x[i]))
end
```

"x[$i] = "

