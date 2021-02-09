# 4 Selected Topics in Numerical Methods  
In this chapter, curve fitting, numerical differentiation, and numerical integration are briefly explained.  
<br>

## 4.1 Curve Fitting  
Suppose we have discrete data sets. We often want to represent the relationship as an analytical expression, such as a linear functionor or an exponential function. **Curve fitting** aims to find the values of parameters of the functions.  
  
The most popular definition of the best match or best fit is based on the **least-squares**. This is a nonlinear optimization problem in general. In Julia, the [LsqFit package](https://github.com/JuliaNLSolvers/LsqFit.jl) implements the Levenberg-Marquardt algorithm.  
<br>

- [Function form](https://scrapbox.io/kklab-ise-ag/Chapter_4)  
[$ f(x) = \beta_1(\frac{x}{\beta_2})^{\beta_3-1}exp(-(\frac{x}{\beta_2})^{\beta_3})]  
<br>

- Code  
```julia
using LsqFit
using PyPlot

xdata = [ 15.2; 19.9;  2.2; 11.8; 12.1; 18.1; 11.8; 13.4; 11.5;  0.5; 18.0; 10.2; 10.6; 13.8;  4.6;  3.8; 15.1; 15.1; 11.7;  4.2 ]
ydata = [ 0.73; 0.19; 1.54; 2.08; 0.84; 0.42; 1.77; 0.86; 1.95; 0.27; 0.39; 1.39; 1.25; 0.76; 1.99; 1.53; 0.86; 0.52; 1.54; 1.05 ]

model(x, beta) = beta[1] * ((x/beta[2]).^(beta[3]-1)) .* (exp.( - (x/beta[2]).^beta[3] )) #Note 1

#Curve fitting algorithm
fit = curve_fit(model, xdata, ydata, [3.0, 8.0, 3.0]) #LsqFit #Note 2

#Results
beta_fit = fit.param #Note 3
errors = margin_error(fit) #LsqFit
println("beta_fit: ", beta_fit)
println("errors: ", errors)

#Plot
xfit = 0 : 0.1 : 20
yfit = model(xfit, fit.param)

fig = figure() #PyPlot

plot(xdata, ydata, color = "black", linewidth = 2.0, marker = "o", linestyle = "None")
plot(xfit, yfit, color = "red", linewidth = 2.0)

xlabel("x", fontsize="xx-large")
ylabel("y", fontsize="xx-large")

#Save the figure PDF
savefig("fit_plot.pdf")
```
```
beta_fit: [4.459414325767291, 10.254403821563614, 1.8911376587773219]
errors: [1.2405974791377639, 1.410107749203087, 0.40157516056225456] 
```
<br>

- Note  
1. ```model(x, p)``` will accept the full data set as the first argument `x`.
    ```julia
    julia> model(x, beta) = beta[1] * ((x/beta[2]).^(beta[3]-1)) .* (exp.( - (x/beta[2]).^beta[3] )) 
    ```
    ```
    model (generic function with 1 method)
    ```

2. [3.0, 8.0, 3.0] --> initial point of beta  
    ```fit``` is a composite type (LsqFitResult)  
    ```
    LsqFit.LsqFitResult{Array{Float64,1},Array{Float64,1},Array{Float64,2},Array{Float64,1}}([4.459414325739468, 10.254403821589335, 1.8911376587662427], [0.04161413386011037, 0.05221091863859073, -0.46866129811863844, -0.7083121787863045, 0.4765373986997933, -0.024386779602917685, -0.3983121787863044, 0.21771927819488834, -0.5237022566251304, 0.03110900166434749, 0.01586650853748489, 0.2591937666305997, 0.3338590107858692, 0.24620338748550252, -0.23748009950604576, 0.04993492123876897, -0.07261618564362982, 0.26738381435637015, -0.15003460113143152, 0.623123393632806], [0.17303037517644 0.2324956738793641 -0.33559542609373644; 0.05431451328554104 0.13546244655765333 -0.40208226134245884; … ; 0.31169236525653793 0.20815989726988657 -0.05192522251708009; 0.37518904309453943 -0.08835397600592586 -1.217362278281968], true, Float64[])
    ```

3. Obtained parameter values.  
    fit.resid: residuals = vector of residuals  
<br>

## 4.2 Numerical Differentiation  
Given a function f(x), we often need to compute its derivative without actually differentiating the function. The process of **numerical differentiation** is usually done by **finite difference approximations**. In Julia, the [Calculus package](https://github.com/JuliaMath/Calculus.jl) is available for numerical differentiation.  

```julia
using Calculus
f(x) = x^3 * exp(x) + sin(x)
der = derivative(f, 1.0)
secDer = second_derivative(f, 1.0)
println("Derivative: ", der)
println("Second derivative: ", secDer)
```
The result will be  
```
Derivative: 11.413429620197812
Second derivatrive: 34.49618758929225
```
If the function has multiple variables, we can compute the gradient and hessian.  
```julia
g(x) = (x[1])^2 * sin(3x[2]) + exp(-2x[3])
Calculus.gradient(g, [3.0, 1.0, 2.0]) #At [3.0,1.0,2.0]
hessian(g, [3.0, 1.0, 2.0]) #At the same point
```
<br>

- Note  
```gradient()``` --> ```Calculus.gradient()```  
<br>

## 4.3 Numerical Integration  
The most obvious way of approximating Riemann integral is using the Riemann sum. However, left Riemann sum underestimates the integral, and the right Riemann sum overestimates. The average of two would be a good approximation. It is called the **trapezoidal sum**. In julia, [QuadGK package](https://github.com/JuliaMath/QuadGK.jl) provides the approximation.  
```julia
f(x) = - cos(3x) + x^2 * exp(-x)
println(quadgk(f, 0.0, 1.0)) #QuadGK
```
The result is ```(0.11356279145616598,2.123301534595612e-14)```  
<br>

## 4.4 Automatic Differentiation
While numerical differentiation based on finite differences has been popularly used, there are errors from finite differencing. A new paradigm, **automatic differentiation (AD)** on differentiation using computers has risen. AD computes the derivatives without significant computational efforts. There is [ForwardDiff package](https://github.com/JuliaDiff/ForwardDiff.jl) to see how we can use AD in Julia.  
```julia
using ForwardDiff
f(x) = (x-1) * (x+3) / x
g = x -> ForwardDiff.derivative(f, x)
println(g(2))
```
The result is ```1.75```  

If a vector function is given, we can do as follows.  
```julia
using ForwardDiff
f(x) = (x[1]-2) * exp(x[2]) - sin(x[3])
g = x -> ForwardDiff.gradient(f, x)
h = x -> ForwardDiff.hessian(f, x)
```
```julia
g([3.0, 2.0, 1.0])
```
```
  7.38905609893065
  7.38905609893065
 -0.5403023058681398
```
```julia
h([3.0, 2.0, 1.0])
```
```
 0.0      7.38906  0.0
 7.38906  7.38906  0.0
 0.0      0.0      0.841471
```
<br>

- Note  
```g = x -> ForwardDiff.derivative(f, x)```