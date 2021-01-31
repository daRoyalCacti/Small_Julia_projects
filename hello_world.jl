println("Hello World!")

hello_array = ["Hello", "world", "!"]

for i in 1:3
	print("\t", hello_array[i], "\n")
end

squares = [i^2 for i in 0:10]

for s in squares
	print(" ", s)
end

println()
print(sqrt.(squares))
println()

