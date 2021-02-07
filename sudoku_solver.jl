#originally written in c++
#https://github.com/daRoyalCacti/Small_Cpp_Projects/tree/master/Sudoku-Solver
#
#c++ can solve the sudoku in 1.6s
#julia takes 18s
#JULIA IS SIGNIFICANTLY SLOWER!!!

const rows = 9
const cols = 9
const size = 81

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
]


function print_board(board) 
	for j in 1:(cols*4)
		print("-")
	end
	println()

	for i in 0:(rows-1)
		for j in 0:(cols-1)
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
		if (i+1 != rows && i%3 != 2)
			for j in 1:(ceil(rows/3)+1)
				print("|           ")
			end
		end
		println()

		if (i%3 == 2)
			for j in 1:(cols*4)
				print("-")
			end
			println()
		end

	end

end

function isValid(board, posx, posy, hor_box, vert_box)
#is bad - checks for cases where there is no data
	#checking cols
	for i in 1:(posy-1)
		if (board[posx][i] == board[posx][posy])
			return false
		end
	end

	for i in (posy+1):cols
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

	for i in (posx+1):cols
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
	for i in 0:(rows-1)
		hor_box[i+1] = trunc(UInt16, i/rows *3) *3
	end

	for i in 0:(cols-1)
		vert_box[i+1] = trunc(UInt16, i/cols*3) *3
	end
end

function boardValid(board)
	hor_box = zeros(rows, 1)
	vert_box = zeros(cols, 1)

	generateBox(hor_box, vert_box)

	for i = 1:rows
		for j = 1:cols
			if (board[i][j] != 0)
				if (!isValid(board, i, j, hor_box[i], vert_box[j]))
					return false
				end
			end
		end
	end
	
	return true
end


function toSolve(board, solveArrayx, solveArrayy)
	counter = 1

	for i in 1:rows
		for j in 1:cols
			if (board[i][j] == 0)
				solveArrayx[counter] = i
				solveArrayy[counter] = j
				counter +=1
			end
		end
	end

	solveArrayx[counter] = size+10
	solveArrayy[counter] = size+10
end


function solve(board)
	solveArrayx = zeros(size+1, 1)
	solveArrayy = zeros(size+1, 1)
	toSolve(board, solveArrayx, solveArrayy)

	solveArrayx = trunc.(UInt16, solveArrayx)
	solveArrayy = trunc.(UInt16, solveArrayy)

	hor_box = zeros(rows, 1)
	vert_box = zeros(cols, 1)
	generateBox(hor_box, vert_box)

	xindex, yindex = 1, 1

	while (solveArrayy[yindex] <= cols + 1)
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
