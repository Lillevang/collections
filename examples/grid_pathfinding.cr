# Grid pathfinding: parse a maze from a string block, find the shortest route
# from the top-left to the bottom-right, and print it.
#
# Run with: crystal run examples/grid_pathfinding.cr
require "../src/collections"

# '#' cells differ from the default '.', so they are treated as walls by
# `shortest_path` (which skips blocked cells).
maze = <<-MAZE
  .........
  .#######.
  .#.....#.
  .#.###.#.
  .#...#.#.
  .###.#.#.
  ...#.#.#.
  .#.#.#.#.
  .#...#...
  MAZE

grid = Collections::Grid(Char).from_string(maze)

start = Collections::Grid::Point.new(0, 0)
goal = Collections::Grid::Point.new(grid.rows - 1, grid.cols - 1)

if result = grid.shortest_path(start, goal)
  steps, path = result
  puts "Shortest path is #{steps} steps:"
  grid.print_grid(path)
else
  puts "No path found."
end
