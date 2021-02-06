using Plots
using ForwardDiff

f(x) = x.^4 - 2*x.^3
fdash(x) = 4*x.^3 - 6*x.^2

const no_points = 1000
h = 10 .^(range(-15, -2, length=no_points))
xs = [0, 1, 1.5, 2]

for x in xs
	exact_d = fdash(x)
	numerical = ForwardDiff.derivative(f, x)
	println("exact derivative for x = ", x, " : ", exact_d)
	println("         in-built derivative : ", numerical)
	println("                       error : ", abs(exact_d - numerical))

	forward_d = (f.(x .+ h) .- f(x)) ./ h;
	backward_d = (f(x) .- f.(x .- h)) ./ h;
	centre_d = 0.5*( f.(x .+ h) - f(x .- h) ) ./h

	fde = abs.(exact_d .- forward_d)
	bde = abs.(exact_d .- backward_d)
	cde = abs.(exact_d .- centre_d)

	#because plotting log log, any value that is zero gets blown up to infinity
	fde = 0.0000000001*(fde.==0).+fde
	bde = 0.0000000001*(bde.==0).+bde
	cde = 0.0000000001*(cde.==0).+cde

	plot(h, fde, label = "forward", xaxis=:log, yaxis=:log, xlabel = "step size", ylabel = "error", title = "Numerical derivative error, x = " * string(x))
	plot!(h, bde)
	plot!(h, cde)

	png("/home/jacob/Documents/Projects/General-Julia/cosc2500_programs_rewritten/derivative_"*string(x))
end
