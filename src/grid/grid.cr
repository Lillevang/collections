module Collections
  class Grid(T)
    struct Point
      property x : Int32
      property y : Int32

      def initialize(x : Int32, y : Int32)
        @x = x
        @y = y
      end

      def hash
        {@x, @y}.hash
      end

      def ==(other : Point)
        @x == other.x && @y == other.y
      end
    end

    getter rows : Int32
    getter cols : Int32

    @cells : Hash(Point, T)
    @default_value : T

    # Initialize the grid with the given dimensions
    def initialize(rows : Int32, cols : Int32, default_value : T)
      @rows = rows
      @cols = cols
      @default_value = default_value
      @cells = Hash(Point, T).new
    end

    # Builds a grid from a multi-line string, mapping each character to a cell
    # value via the block. Each line becomes a row (x), each column a `y`; the
    # grid width is the length of the longest line, and shorter rows are left at
    # *default_value*.
    #
    # ```
    # grid = Collections::Grid(Int32).from_string("12\n34", 0) { |char, _x, _y| char.to_i }
    # grid.get(1, 1) # => 4
    # ```
    def self.from_string(text : String, default_value : T, & : Char, Int32, Int32 -> T) : Grid(T)
      lines = text.lines
      cols = lines.max_of?(&.size) || 0
      grid = new(lines.size, cols, default_value)

      lines.each_with_index do |line, x|
        line.each_char_with_index do |char, y|
          grid.set(x, y, yield(char, x, y))
        end
      end

      grid
    end

    # Builds a `Grid(Char)` from a multi-line string, one character per cell.
    # *default_value* is the value returned for cells outside a ragged row.
    #
    # ```
    # grid = Collections::Grid(Char).from_string("#..\n.#.")
    # grid.get(1, 1) # => '#'
    # ```
    def self.from_string(text : String, default_value : Char = '.') : Grid(Char)
      Grid(Char).from_string(text, default_value) { |char, _x, _y| char }
    end

    def set(x : Int32, y : Int32, value : T)
      raise ArgumentError.new("Invalid coordinates") if out_of_bounds?(x, y)
      @cells[Point.new(x, y)] = value
    end

    def get(x : Int32, y : Int32) : T
      raise ArgumentError.new("Invalid coordinates") if out_of_bounds?(x, y)
      @cells.fetch(Point.new(x, y), @default_value)
    end

    def blocked?(x : Int32, y : Int32) : Bool
      get(x, y) != @default_value
    end

    # Get valid neighbors for the given cell. Orthogonal (up/down/left/right)
    # by default; pass `diagonal: true` to also include the four diagonal cells.
    def neighbors(x : Int32, y : Int32, filter_blocked : Bool = true, diagonal : Bool = false) : Array(Point)
      raise ArgumentError.new("Invalid coordinates") if out_of_bounds?(x, y)

      directions = [
        {-1, 0}, # Up
        {1, 0},  # Down
        {0, -1}, # Left
        {0, 1},  # Right
      ]

      if diagonal
        directions.concat([
          {-1, -1}, # Up-left
          {-1, 1},  # Up-right
          {1, -1},  # Down-left
          {1, 1},   # Down-right
        ])
      end

      directions.compact_map do |dir_x, dir_y|
        nx, ny = x + dir_x, y + dir_y
        Point.new(nx, ny) unless out_of_bounds?(nx, ny) || (filter_blocked && blocked?(nx, ny))
      end
    end

    # Helper check if the coordinates are out of bounds
    private def out_of_bounds?(x : Int32, y : Int32) : Bool
      x < 0 || x >= @rows || y < 0 || y >= @cols
    end

    # Find the shortest path between two points using BFS
    def shortest_path(
      start : Tuple(Int32, Int32) | Array(Int32) | Point,
      goal : Tuple(Int32, Int32) | Array(Int32) | Point,
      filter_blocked : Bool = true,
    ) : Tuple(Int32, Array(Point))?
      start = start.is_a?(Point) ? start : Point.new(start[0], start[1])
      goal = goal.is_a?(Point) ? goal : Point.new(goal[0], goal[1])

      # Early exit if start or goal is invalid
      return if blocked?(start.x, start.y) || blocked?(goal.x, goal.y)

      directions = [
        {-1, 0}, # Up
        {1, 0},  # Down
        {0, -1}, # Left
        {0, 1},  # Right
      ]

      # BFS. We mark cells visited on enqueue (so each cell is queued at most
      # once) and reconstruct the path from a came_from map at the end, rather
      # than carrying a full path copy on every queue entry.
      queue = Deque(Point){start}
      visited = Set(Point){start}
      came_from = {} of Point => Point

      until queue.empty?
        point = queue.shift
        return reconstruct_path(came_from, start, goal) if point == goal

        directions.each do |dir_x, dir_y|
          nx, ny = point.x + dir_x, point.y + dir_y
          next if out_of_bounds?(nx, ny) || (filter_blocked && blocked?(nx, ny))

          neighbor = Point.new(nx, ny)
          next unless visited.add?(neighbor)
          came_from[neighbor] = point
          queue << neighbor
        end
      end

      nil # No path found
    end

    # Walk the came_from chain back from goal to start, returning
    # {number_of_steps, path} with the path ordered start -> goal (inclusive).
    private def reconstruct_path(came_from : Hash(Point, Point), start : Point, goal : Point) : Tuple(Int32, Array(Point))
      path = [goal]
      current = goal
      while current != start
        current = came_from[current]
        path << current
      end
      path.reverse!
      {path.size - 1, path}
    end

    def print_grid(path : Array(Point) = [] of Point)
      path_set = Set(Point).new(path) # Convert path to a set for quick lookup

      (0...@rows).each do |x|
        row = (0...@cols).map do |y|
          point = Point.new(x, y)
          if path_set.includes?(point)
            "o" # Part of the path
          elsif blocked?(x, y)
            "#" # Blocked cell
          else
            "." # Free cell
          end
        end.join
        puts row
      end
    end
  end
end
