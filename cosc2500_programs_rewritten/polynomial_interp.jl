using Polynomials
using Plots

has_gui = 0;	#1 if want the gui

if has_gui == 1
	pyplot()
	Plots.PyPlotBackend()
end

#plotly()
#Plots.PlotlyBackend()

x = [ 0; 0.1341; 0.2693; 0.4034; 0.5386; 0.6727; 0.8079; 0.9421; 1.0767; 1.2114; 1.3460; 1.4801; 1.6153; 1.7495; 1.8847; 2.0199; 2.1540; 2.2886; 2.4233; 2.5579; 2.6921; 2.8273; 2.9614; 3.0966; 3.2307; 3.3659; 3.5000 ]::Array{Float64}
y = [ 0, 0.0310, 0.1588, 0.3767, 0.6452, 0.8780, 0.9719, 1.0000, 0.9918, 0.9329, 0.8198, 0.7707, 0.8024, 0.7674, 0.6876, 0.5937, 0.5778, 0.4755, 0.3990, 0.3733, 0.2870, 0.2156, 0.2239, 0.1314, 0.1180, 0.0707, 0.0259 ]::Array{Float64}

no_points = size(x, 1)
min_val = typemax(Float64)	#a very large value
order = 0



println("Finding correct order")
for ii in 1:trunc(Int, no_points/2)	#recommended for the order of the polynomial to stay below half of the number of points
	#creating polynomial of degree ii
	poly = fit(x,y,ii)
	func_vals = [poly(xd) for xd in x]
	Measure::Float64 = abs(sum( (y-func_vals).^2) / (no_points - 2*ii))
	if (Measure < min_val)
		global min_val = Measure
		global order = ii
	end
end

println("Order of polynomial : ", order)


println("Plotting raw data")
f = scatter(x, y, markerstrokewidth=0, label="data", xlabel = "x", ylabel = "y", title = "polynomial fit to data");
println("Plotting polynomial")
plot!(fit(x, y, order), extrema(x)..., label="fit")

if has_gui == 1
	gui()
end

println("Saving figure")
png("/home/jacob/Documents/Projects/General-Julia/cosc2500_programs_rewritten/polynomial_interp")

if has_gui == 1
	s = readline()	#paussing to view the plot
end
