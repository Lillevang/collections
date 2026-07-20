module Collections
  # A dense, fixed-size 2D grid backed by a flat buffer.
  #
  # Where `Grid` is about *traversal* (neighbours, flood fill, shortest
  # paths), `DenseGrid` is a mutable numeric canvas: O(1) cell access,
  # rectangle updates, and whole-grid reductions. The right tool for
  # "apply operations to regions, then tally the cells" puzzles.
  class DenseGrid(T)
    getter width : Int32
    getter height : Int32

    def initialize(@width : Int32, @height : Int32, fill : T)
      @cells = Slice(T).new(@width * @height, fill)
    end

    private def index(x : Int32, y : Int32) : Int32
      unless x.in?(0...@width) && y.in?(0...@height)
        raise IndexError.new("(#{x}, #{y}) out of bounds")
      end
      y * @width + x
    end

    def [](x : Int32, y : Int32) : T
      @cells[index(x, y)]
    end

    def []=(x : Int32, y : Int32, value : T) : T
      @cells[index(x, y)] = value
    end

    # Apply *block* to every cell in the inclusive rectangle, replacing
    # each with the block's return value. Corners may be given in any order.
    def update_rect(x1 : Int32, y1 : Int32, x2 : Int32, y2 : Int32, & : T -> T) : Nil
      x1, x2 = x2, x1 if x1 > x2
      y1, y2 = y2, y1 if y1 > y2
      unless x1.in?(0...@width) && x2.in?(0...@width) && y1.in?(0...@height) && y2.in?(0...@height)
        raise IndexError.new("rectangle out of bounds")
      end
      (y1..y2).each do |y|
        base = y * @width
        (x1..x2).each { |x| i = base + x; @cells[i] = yield @cells[i] }
      end
    end

    # Set every cell in the inclusive rectangle to *value*.
    def fill_rect(x1, y1, x2, y2, value : T) : Nil
      update_rect(x1, y1, x2, y2) { value }
    end

    def sum
      @cells.sum
    end

    def count(& : T -> Bool) : Int32
      @cells.count { |c| yield c }
    end

    def each(& : T ->) : Nil
      @cells.each { |c| yield c }
    end
  end
end
