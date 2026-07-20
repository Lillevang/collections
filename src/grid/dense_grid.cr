module Collections
  # A dense, fixed-size 2D grid backed by a flat buffer.
  #
  # Where `Grid` is about *traversal* (neighbours, flood fill, shortest
  # paths), `DenseGrid` is a mutable numeric canvas: O(1) cell access,
  # rectangle updates, and whole-grid reductions. The right tool for
  # "apply operations to regions, then tally the cells" puzzles.
  #
  # Follows the same `(row, col)` convention as `Grid`. Includes
  # `Enumerable(T)`, so `sum`, `count`, `min`/`max`, `tally`, etc. are
  # all available.
  class DenseGrid(T)
    include Enumerable(T)

    getter rows : Int32
    getter cols : Int32

    def initialize(@rows : Int32, @cols : Int32, fill : T)
      unless @rows > 0 && @cols > 0
        raise ArgumentError.new("dimensions must be positive (got #{@rows}x#{@cols})")
      end
      @cells = Slice(T).new(@rows * @cols, fill)
    end

    private def index(row : Int32, col : Int32) : Int32
      unless row.in?(0...@rows) && col.in?(0...@cols)
        raise IndexError.new("(#{row}, #{col}) out of bounds")
      end
      row * @cols + col
    end

    def [](row : Int32, col : Int32) : T
      @cells[index(row, col)]
    end

    def []=(row : Int32, col : Int32, value : T) : T
      @cells[index(row, col)] = value
    end

    # Apply *block* to every cell in the inclusive rectangle, replacing
    # each with the block's return value. Corners may be given in any order.
    def update_rect(row1 : Int32, col1 : Int32, row2 : Int32, col2 : Int32, & : T -> T) : Nil
      row1, row2 = row2, row1 if row1 > row2
      col1, col2 = col2, col1 if col1 > col2
      unless row1.in?(0...@rows) && row2.in?(0...@rows) && col1.in?(0...@cols) && col2.in?(0...@cols)
        raise IndexError.new("rectangle out of bounds")
      end
      (row1..row2).each do |row|
        base = row * @cols
        (col1..col2).each { |col| i = base + col; @cells[i] = yield @cells[i] }
      end
    end

    # Set every cell in the inclusive rectangle to *value*.
    def fill_rect(row1 : Int32, col1 : Int32, row2 : Int32, col2 : Int32, value : T) : Nil
      update_rect(row1, col1, row2, col2) { value }
    end

    def each(& : T ->) : Nil
      @cells.each { |cell| yield cell }
    end

    # Yield every cell together with its coordinates, in row-major order.
    def each_with_coords(& : T, Int32, Int32 ->) : Nil
      @cells.each_with_index do |cell, i|
        yield cell, i // @cols, i % @cols
      end
    end
  end
end
