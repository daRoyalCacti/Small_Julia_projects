#import Pkg
#Pkg.add("ForwardDiff")
#Pkg.add("Calculus")
#Pkg.add("QuadGK")
using ForwardDiff, Calculus, QuadGK

#numerically calculcates df/dx for f = f(x,y)
#https://stackoverflow.com/questions/65694368/using-forwarddiff-jl-for-a-function-of-many-variables-and-parameters-julia
function dfx_n(f, x, y)
 return ForwardDiff.derivative(x -> f(x,y), x)
end

#analytically  calculates df/dx. f must be a string
#https://github.com/JuliaMath/Calculus.jl
function dfx_s(f)
	return simplify(differentiate(f, :x)) 	#differentiating then simplifying
end

#computes the int_a^b f(x,y) dx for a fixed y
#https://github.com/JuliaMath/QuadGK.jl
function Ifx_n(f, y, a, b)
	tol = 1e-8
	int, err = quadgk(x -> f(x,y), a, b, rtol=tol)
	return int
end


f(x,y) = sin(x)^2 + cos(y)^2
f_s = "sin(x)^2+cos(y)"

println(dfx_s(f_s))
println(dfx_n(f, 1,2))
println(Ifx_n(f, 2, 0, 1))

#print(f(1,1))
