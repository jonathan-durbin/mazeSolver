using FileIO
using Images
# from timeit import default_timer as timer
# import pygame
# import pygame.gfxdraw

# Translated from: https://github.com/Azideon/mazeSolver


# """
# Create a maze object.

# Likely not needed. We'll see.
# """
# function mazeCreator(m)
#     maze = map(i -> i == RGB{N0f8}(0,0,0) ? "B" : "W", m)
# end


"""
Find the entry and exit points of the maze.

TODO: write this function better.

Assumptions:
1. The entry point is somewhere on the top or left side,
2. The exit is somewhere on the bottom or right side.
3. There is only one entry and exit.

Returns entryY, entryX, exitY, exitX
"""
function findPoints(m, white)
    start =  [1, 1]
    finish = [1, 1]
    for (i, val) in enumerate(m[1, :])  # top row
        val == white && (start[2] = i; break)
    end
    for (i, val) in enumerate(m[:, 1])  # left side
        val == white && (start[1] = i; break)
    end
    for (i, val) in enumerate(m[end, :])  # bottom row
        val == white && (finish[2] = i; break)
    end
    for (i, val) in enumerate(m[:, end])  # right side
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
function solve(maze, start, finish, white)
    solution = []
    washere = []
    y, x = start
    while [y, x] != finish
        push!(washere, [y, x])
        push!(solution, [y, x])
        if maze[y - 1, x] == white && !([y - 1, x] in washere)
            @debug "Up"
            possibleSteps = [y - 1, x]
        elseif maze[y, x + 1] == white && !([y, x + 1] in washere)
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
            # visualiseSolver(x, y, (255, 255, 255))
        end
        y = possibleSteps[1]
        x = possibleSteps[2]
    end
    push!(solution, finish)
    # visualiseSolver(finish[1], finish[2], (255, 0, 0))
    # print("Solution:", solution)
    return solution
end

# def printImage():
#     for x in solution:
#         pix[x[1], x[0]] = (255, 0, 0)
#     mazeImage.save("mazeSol.png")
# def visualise():
#     pygame.init()
#     windowSize = 1920, 1080
#     screen = pygame.display.set_mode(windowSize, pygame.FULLSCREEN | pygame.DOUBLEBUF)
#     screen.set_alpha(None)
#     pygame.display.set_caption('Maze Solver')
#     screen.fill((255, 255, 255))
#     return screen
# def visualiseMaze():
#     for y in range(0, len(maze)):
#         for x in range(0, len(maze[y])):
#             if maze[y][x] == "B":
#                 rect = pygame.Rect((x * scaleFactor) + offset, (y * scaleFactor) + offset, scaleFactor, scaleFactor)
#                 pygame.draw.rect(screen, (0, 0, 0), rect)
#                 pygame.event.pump()
#     pygame.display.flip()
# def visualiseSolver(x, y, color):
#     rect = pygame.Rect((x * scaleFactor) + offset, (y * scaleFactor) + offset, scaleFactor, scaleFactor)
#     pygame.draw.rect(screen, color, rect)
#     pygame.display.update(rect)
#     pygame.event.pump()


function main()
    maze = load("mazeSmall.png")
    black = RGB{N0f8}(0, 0, 0)
    white = RGB{N0f8}(0.0, 0.0, 0.0)
    # scaleFactor = 4
    # offset = 2
    start, finish = findPoints(maze, white)
    println("Entry:, $start")
    println("Exit:, $finish")
    # screen = visualise()
    # visualiseMaze()
    # visualiseSolver(entryX, entryY, (0, 255, 0))
    # visualiseSolver(exitX, exitY, (0, 255, 0))
    starttime = time()
    solution = solve(maze, start, finish, white)
    # printImage()

    println("Time taken: $(round(time() - starttime, digits=4))")

    # running = True

    # while running:
    #     pygame.display.flip()
    #     for event in pygame.event.get():
    #         if event.type == pygame.QUIT:
    #             running = False
    return solution
end

main()