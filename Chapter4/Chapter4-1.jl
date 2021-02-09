using LsqFit #Package of Levenberg-Marquardt algorithm
using PyPlot

xdata = [ 15.2; 19.9;  2.2; 11.8; 12.1; 18.1; 11.8; 13.4; 11.5;  0.5; 18.0; 10.2; 10.6; 13.8;  4.6;  3.8; 15.1; 15.1; 11.7;  4.2 ]
ydata = [ 0.73; 0.19; 1.54; 2.08; 0.84; 0.42; 1.77; 0.86; 1.95; 0.27; 0.39; 1.39; 1.25; 0.76; 1.99; 1.53; 0.86; 0.52; 1.54; 1.05 ]

model(x, beta) = beta[1] * ((x/beta[2]).^(beta[3]-1)) .* (exp.( - (x/beta[2]).^beta[3] ))

#Curve fitting algorithm
fit = curve_fit(model, xdata, ydata, [3.0, 8.0, 3.0]) #LsqFit
println(fit)

#Results
beta_fit = fit.param
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