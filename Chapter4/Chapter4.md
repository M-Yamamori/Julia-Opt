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
using LsqFit #Package of Levenberg-Marquardt algorithm
using PyPlot

xdata = [ 15.2; 19.9;  2.2; 11.8; 12.1; 18.1; 11.8; 13.4; 11.5;  0.5; 18.0; 10.2; 10.6; 13.8;  4.6;  3.8; 15.1; 15.1; 11.7;  4.2 ]
ydata = [ 0.73; 0.19; 1.54; 2.08; 0.84; 0.42; 1.77; 0.86; 1.95; 0.27; 0.39; 1.39; 1.25; 0.76; 1.99; 1.53; 0.86; 0.52; 1.54; 1.05 ]

model(x, beta) = beta[1] * ((x/beta[2]).^(beta[3]-1)) .* (exp.( - (x/beta[2]).^beta[3] )) #Note1

#Curve fitting algorithm
fit = curve_fit(model, xdata, ydata, [3.0, 8.0, 3.0]) #LsqFit #Note2

#Results
beta_fit = fit.param #Note3
errors = margin_error(fit) #LsqFit
println("beta_fit: ", beta_fit)
println("errors: ", errors)

xfit = 0 : 0.1 : 20
yfit = model(xfit, fit.param)

fig = figure()

#Plot
plot(xdata, ydata, color = "black", linewidth = 2.0, marker = "o", linestyle = "None")
plot(xfit, yfit, color = "red", linewidth = 2.0)

xlabel("x", fontsize="xx-large")
ylabel("y", fontsize="xx-large")

#Save the figure PDF
savefig("fit_plot.pdf")

close(fig)
```
<br>

- Note  
1. ```model(x, p)``` will accept the full data set as the first argument `x`.
2. [3.0, 8.0, 3.0] --> initial point  
    ```fit``` is a composite type (LsqFitResult)  
3. fit.resid: residuals = vector of residuals  
<br>

## 4.2 Numerical Differentiation  
Given a function f(x), we often need to compute its derivative without actually differentiating the function. The process of **numerical differentiation** is usually done by **finite difference approximations**. In Julia, the [Calculus package](https://github.com/JuliaMath/Calculus.jl) is available for numerical differentiation.  

```julia
using Calculus
f(x) = x^3 * exp(x) + sin(x)
der = derivative(f, 1.0))
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
## 4.4 Automatic Differentiation