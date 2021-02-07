#originally written in c++
#https://github.com/daRoyalCacti/Small_Cpp_Projects/tree/master/Sudoku-Solver
#
#c++ can solve the sudoku in 1.6s
#unoptimised julia takes 18s
#JULIA IS SIGNIFICANTLY SLOWER!!!


sudoku_board = [
	[0, 0, 0, 8, 0, 1, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 4, 3],
	[5, 0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 7, 0, 8, 0, 0],
	[0, 0, 0, 0, 0, 0, 1, 0, 0],
	[0, 2, 0, 0, 3, 0, 0, 0, 0],
	[6, 0, 0, 0, 0, 0, 0, 7, 5],
	[0, 0, 3, 4, 0, 0, 0, 0, 0],
	[0, 0, 0, 2, 0, 0, 6, 0, 0]
]::Array{Array{Int64, 1},1}


function print_board(board::Array{Array{Int64, 1},1})
	for j in 1:(9*4)
		print("-")
	end
	println()

	for i in 0:8
		for j in 0:8
			if (j%3 == 0)
				print("|  ")
			end
			if (board[i+1][j+1] != 0)	#only print non-zeor entries
				print(board[i+1][j+1], "  ")
			else
				print("   ")
			end
		end
		println("|")
		if (i+1 != 9 && i%3 != 2)
			for j in 1:4
				print("|           ")
			end
		end
		println()

		if (i%3 == 2)
			for j in 1:(9*4)
				print("-")
			end
			println()
		end

	end

	return nothing
end

function isValid(board::Array{Array{Int64, 1},1}, posx, posy, hor_box, vert_box)::Bool
#is bad - checks for cases where there is no data
	#checking cols
	for i in 1:(posy-1)
		if (board[posx][i] == board[posx][posy])
			return false
		end
	end

	for i in (posy+1):9
		if (board[posx][i] == board[posx][posy])
			return false
		end
	end


	#checking rows
	for i in 1:(posx-1)
		if (board[i][posy] == board[posx][posy])
			return false
		end
	end

	for i in (posx+1):9
		if (board[i][posy] == board[posx][posy])
			return false
		end
	end


	#inside current box
	# - is bad (checks some of the cases already checked above)
	for i in trunc.(UInt16, (hor_box+1):(hor_box+3))
		for j in trunc.(UInt16, (vert_box+1):(vert_box+3))
			if (i != posx && j != posy && board[i][j] == board[posx][posy])
				return false
			end
		end
	end

	return true;
end

function generateBox(hor_box, vert_box)
	for i in 0:8
		hor_box[i+1] = trunc(UInt16, i/3) *3
	end

	for i in 0:8
		vert_box[i+1] = trunc(UInt16, i/3) *3
	end

	return nothing
end

function boardValid(board::Array{Array{Int64, 1},1})::Bool
	hor_box::Array{UInt16} = zeros(9, 1)
	vert_box::Array{UInt16} = zeros(9, 1)

	generateBox(hor_box, vert_box)

	for i = 1:9
		for j = 1:9
			if (board[i][j] != 0)
				if (!isValid(board, i, j, hor_box[i], vert_box[j]))
					return false
				end
			end
		end
	end
	
	return true
end


function toSolve(board::Array{Array{Int64, 1},1}, solveArrayx, solveArrayy)
	counter::UInt16 = 1

	for i in 1:9
		for j in 1:9
			if (board[i][j] == 0)
				solveArrayx[counter] = i
				solveArrayy[counter] = j
				counter +=1
			end
		end
	end

	solveArrayx[counter] = 91
	solveArrayy[counter] = 91

	return nothing
end


function solve(board::Array{Array{Int64, 1},1})
	solveArrayx::Array{Int64,2} = zeros(82, 1)
	solveArrayy::Array{Int64,2} = zeros(82, 1)
	toSolve(board, solveArrayx, solveArrayy)

	solveArrayx = trunc.(UInt16, solveArrayx)
	solveArrayy = trunc.(UInt16, solveArrayy)

	hor_box = zeros(9, 1)
	vert_box = zeros(9, 1)
	generateBox(hor_box, vert_box)

	xindex, yindex = 1, 1

	while (solveArrayy[yindex] <= 10)
		board[solveArrayx[xindex]][solveArrayy[yindex]] += 1
		if (board[solveArrayx[xindex]][solveArrayy[yindex]] >= 10)
			board[solveArrayx[xindex]][solveArrayy[yindex]] = 0
			xindex -= 1
			yindex -= 1
		elseif (isValid(board, solveArrayx[xindex], solveArrayy[yindex], hor_box[solveArrayx[xindex]], vert_box[solveArrayy[yindex]]))
			xindex += 1
			yindex += 1
		end
	end

	if (xindex <=0 || yindex <= 0)
		println("Board is not solveable")
	end

	return nothing
end



println("Board to solve")
print_board(sudoku_board)

if (!boardValid(sudoku_board))
	println("Board is not valid")
	return
end

println("Solving...")

@time solve(sudoku_board)

println("solved board")
print_board(sudoku_board)
