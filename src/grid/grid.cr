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

    # Get valid neighbors for the given cell
    def neighbors(x : Int32, y : Int32, filter_blocked : Bool = true) : Array(Point)
      raise ArgumentError.new("Invalid coordinates") if out_of_bounds?(x, y)

      directions = [
        {-1, 0}, # Up
        {1, 0},  # Down
        {0, -1}, # Left
        {0, 1},  # Right
      ]

      directions.map do |dx, dy|
        nx, ny = x + dx, y + dy
        Point.new(nx, ny) unless out_of_bounds?(nx, ny) || (filter_blocked && blocked?(nx, ny))
      end.compact
    end

    # Helper check if the coordinates are out of bounds
    private def out_of_bounds?(x : Int32, y : Int32) : Bool
      x < 0 || x >= @rows || y < 0 || y >= @cols
    end

    # Find the shortest path between two points using BFS
    def shortest_path(
      start : Tuple(Int32, Int32) | Array(Int32) | Point,
      goal : Tuple(Int32, Int32) | Array(Int32) | Point,
      filter_blocked : Bool = true
    ) : Tuple(Int32, Array(Point)) | Nil
      # Early exit if start or goal is invalid
      return nil if blocked?(start.x, start.y) || blocked?(goal.x, goal.y)

      directions = [
        {-1, 0}, # Up
        {1, 0},  # Down
        {0, -1}, # Left
        {0, 1},  # Right
      ]

      queue = [] of Tuple(Int32, Point, Array(Point)) # (distance, point, path)
      queue << {0, start, [start]}
      visited = Set(Point).new

      while queue.any?
        distance, point, path = queue.shift

        # Goal reached
        return {distance, path} if point == goal

        # Skip if already visited
        next unless visited.add?(point)

        # Explore neighbors
        directions.each do |dx, dy|
          nx, ny = point.x + dx, point.y + dy
          neighbor = Point.new(nx, ny)
          if !out_of_bounds?(nx, ny) && (!filter_blocked || !blocked?(nx, ny))
            queue << {distance + 1, neighbor, path + [neighbor]}
          end
        end
      end

      nil # No path found
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
