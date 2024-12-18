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
  end
end
