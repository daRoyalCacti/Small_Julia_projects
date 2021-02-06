using Plots
using QuadGK	#using standard integration, https://juliapackages.com/p/quadgk


function f(x) 
	return sin(x^2) + 1
end

const xmin = 0
const xmax = 10


analyt = 10.58367089992962334;
println("analytic integral : ", analyt)
int, err = quadgk(f, xmin, xmax)
println("in built integrator : ", int)
println("    esitmated error : ", err)

h = trunc.(Int, 10 .^(range(1, 4, length=1000)) );	#can't find logspace function
trap_error = zeros(length(h), 1)
simp_error = zeros(length(h), 1)
s = zeros(length(h), 1)

for ii in 1:length(h)
	if (mod(h[ii], 2) == 0)
		h[ii] = h[ii] - 1
	end
	x = range(0, 10, length=h[ii])
	s[ii] = x[2] - x[1]

	#trapezoid method
	trap_integ = s[ii]/2 * ( f(x[1]) + sum(2*f.(x[2:(end-1)]) )  + f(x[end]) )
	trap_error[ii] = abs(analyt - trap_integ)

	Simp_integ = s[ii]/3 * (f(x[1]) + sum(4* f.( x[2:2:(end-1)] ))  +  sum(2* f.( x[3:2:(end-2)] )) + f(x[end]) )
	simp_error[ii] = abs(analyt - Simp_integ)
end




plot(s, trap_error, label = "trap", xaxis=:log, yaxis=:log, xlabel = "step size", ylabel = "error", title = "error for integration methods")
plot!(s, simp_error, label = "simp")

png("/home/jacob/Documents/Projects/General-Julia/cosc2500_programs_rewritten/integration")

