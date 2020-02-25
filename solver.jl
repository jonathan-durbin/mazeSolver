using FileIO
using Images
using Logging

if length(ARGS) > 0
    if "-debug" in ARGS
        global_logger(SimpleLogger(stdout, Logging.Debug))
    end
end

# Translated from: https://github.com/Azideon/mazeSolver


"""
Find the entry and exit points of a maze.

TODO: write this function better.

Assumptions:
1. The entry point is somewhere on the top or left side,
2. The exit is somewhere on the bottom or right side.
3. There is only one entry and exit.

Returns entryY, entryX, exitY, exitX
"""
function findPoints(m::Array{RGB{N0f8},2}, white::RGB{N0f8})
    start =  [1, 1]
    finish = [size(m)...]
    for (i, val) in enumerate(m[1, :])  # top row
        val == white && (start[2] = i; break)
    end
    for (i, val) in enumerate(m[:, 1])  # left side
        val == white && (start[1] = i; break)
    end
    for (i, val) in Iterators.reverse(enumerate(m[end, :]))  # bottom row
        val == white && (finish[2] = i; break)
    end
    for (i, val) in Iterators.reverse(enumerate(m[:, end]))  # right side
        val == white && (finish[1] = i; break)
    end
    return start, finish
end

"""
Given an entry point to a maze, find the exit.

Returns:
    - solution (if solved)
    - false (if not)
"""
function solve(maze::Array{RGB{N0f8},2}, start::Array{Int}, finish::Array{Int}, white::RGB{N0f8})
    @info "Started solving..."
    solution = []
    washere = []
    start[1] == 1 ? (y = 1+start[1]) : (y = start[1])
    start[2] == 1 ? (x = 1+start[2]) : (x = start[2])
    while [y, x] != finish
        push!(washere, [y, x])
        push!(solution, [y, x])
        if maze[y - 1, x] == white && [y - 1, x] != start && !([y - 1, x] in washere)
            @debug "Up"
            possibleSteps = [y - 1, x]
        elseif maze[y, x + 1] == white && [y - 1, x] != start && !([y, x + 1] in washere)
            @debug "Right"
            possibleSteps = [y, x + 1]
        elseif maze[y + 1, x] == white && !([y + 1, x] in washere)
            @debug "Down"
            possibleSteps = [y + 1, x]
        elseif maze[y, x - 1] == white && !([y, x - 1] in washere)
            @debug "Left"
            possibleSteps = [y, x - 1]
        else
            @debug "Stuck" position=[y, x]
            pop!(solution)
            possibleSteps = [solution[end][1], solution[end][2]]
            pop!(solution)
        end
        y = possibleSteps[1]
        x = possibleSteps[2]
    end
    push!(solution, finish)

    return solution
end


function main()
    maze = load("mazeSmall.png")
    black = RGB(0, 0, 0)
    white = RGB(1, 1, 1)
    start, finish = findPoints(maze, white)
    println("Image size:, $(size(maze))")
    println("Entry: $start")
    println("Exit: $finish")
    starttime = time()
    solution = solve(maze, start, finish, white)

    println("Time taken: $(round(time() - starttime, digits=4))")

    return solution
end

main()