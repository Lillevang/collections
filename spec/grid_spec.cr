require "../src/grid/grid"
require "./spec_helper"

describe Collections::Grid do
  it "Initializes the grid" do
    grid = Collections::Grid.new(3, 3, 0)
    grid.rows.should eq(3)
    grid.cols.should eq(3)
  end

  it "Initializes a 70x70 grid" do
    grid = Collections::Grid.new(70, 70, false)
    grid.rows.should eq(70)
    grid.cols.should eq(70)
  end

  it "can block regions" do
    grid = Collections::Grid.new(70, 70, false)
    # Block some cells
    blocked_regions = [{1, 1}, {2, 2}, {3, 3}]
    blocked_regions.each do |region|
      grid.set(region[0], region[1], true)
    end

    grid.rows.should eq(70)
    grid.cols.should eq(70)
    grid.blocked?(1, 1).should be_true
    grid.blocked?(2, 2).should be_true
    grid.blocked?(3, 3).should be_true
    grid.blocked?(4, 4).should be_false
    grid.set(4, 4, true) # mark as blocked
    grid.blocked?(4, 4).should be_true
  end

  it "returns valid neighbors" do
    grid = Collections::Grid.new(5, 5, false)

    # Block some cells
    grid.set(2, 2, true)
    grid.set(2, 3, true)

    # Neighbors of (2, 2)
    neighbors = grid.neighbors(2, 2)
    neighbors.should eq([Collections::Grid::Point.new(1, 2), Collections::Grid::Point.new(3, 2), Collections::Grid::Point.new(2, 1)])

    # Include blocked neighbors
    neighbors_with_blocked = grid.neighbors(2, 2, false)
    neighbors_with_blocked.should eq([
      Collections::Grid::Point.new(1, 2),
      Collections::Grid::Point.new(3, 2),
      Collections::Grid::Point.new(2, 1),
      Collections::Grid::Point.new(2, 3),
    ])
  end

  it "returns diagonal neighbors when requested" do
    grid = Collections::Grid.new(5, 5, false)

    neighbors = grid.neighbors(2, 2, diagonal: true)
    neighbors.should eq([
      Collections::Grid::Point.new(1, 2), # Up
      Collections::Grid::Point.new(3, 2), # Down
      Collections::Grid::Point.new(2, 1), # Left
      Collections::Grid::Point.new(2, 3), # Right
      Collections::Grid::Point.new(1, 1), # Up-left
      Collections::Grid::Point.new(1, 3), # Up-right
      Collections::Grid::Point.new(3, 1), # Down-left
      Collections::Grid::Point.new(3, 3), # Down-right
    ])
  end

  it "clips diagonal neighbors at the grid edge" do
    grid = Collections::Grid.new(5, 5, false)

    # Corner (0, 0): only in-bounds cells remain.
    neighbors = grid.neighbors(0, 0, diagonal: true)
    neighbors.should eq([
      Collections::Grid::Point.new(1, 0), # Down
      Collections::Grid::Point.new(0, 1), # Right
      Collections::Grid::Point.new(1, 1), # Down-right
    ])
  end

  it "finds the shortest path in an empty grid" do
    grid = Collections::Grid.new(5, 5, false)
    start = Collections::Grid::Point.new(0, 0)
    goal = Collections::Grid::Point.new(4, 4)
    distance = grid.shortest_path(start, goal)
    distance[0].should eq(8) if distance
  end

  it "returns a contiguous path including start and goal" do
    grid = Collections::Grid.new(5, 5, false)
    start = Collections::Grid::Point.new(0, 0)
    goal = Collections::Grid::Point.new(4, 4)

    result = grid.shortest_path(start, goal)
    result.should_not be_nil
    if result
      steps, path = result
      path.first.should eq(start)
      path.last.should eq(goal)
      path.size.should eq(steps + 1)
      # every consecutive pair differs by exactly one orthogonal step
      path.each_cons(2) do |(a, b)|
        ((a.x - b.x).abs + (a.y - b.y).abs).should eq(1)
      end
    end
  end

  it "finds no path if the goal is blocked" do
    grid = Collections::Grid.new(5, 5, false)
    start = Collections::Grid::Point.new(0, 0)
    goal = Collections::Grid::Point.new(4, 4)
    grid.set(4, 4, true) # Block the goal
    distance = grid.shortest_path(start, goal)
    distance.should be_nil # No path exists
  end

  it "finds the shortest path in a partially blocked grid" do
    grid = Collections::Grid.new(5, 5, false)
    start = Collections::Grid::Point.new(0, 0)
    goal = Collections::Grid::Point.new(4, 4)

    # Block some cells
    grid.set(1, 0, true)
    grid.set(1, 1, true)
    grid.set(1, 2, true)

    distance = grid.shortest_path(start, goal)
    # grid.print_grid(distance[1]) if distance
    distance[0].should eq(8) if distance
  end

  it "returns nil if the start is blocked" do
    grid = Collections::Grid.new(5, 5, false)
    start = Collections::Grid::Point.new(0, 0)
    goal = Collections::Grid::Point.new(4, 4)

    grid.set(0, 0, true) # Block the start

    distance = grid.shortest_path(start, goal)
    distance.should be_nil # No path exists
  end

  it "returns nil if the start and goal are disconnected" do
    grid = Collections::Grid.new(5, 5, false)
    start = Collections::Grid::Point.new(0, 0)
    goal = Collections::Grid::Point.new(4, 4)

    # Block a wall separating start and goal
    (0...5).each { |i| grid.set(2, i, true) }

    distance = grid.shortest_path(start, goal)
    distance.should be_nil # No path exists
  end

  describe "#flood_fill" do
    it "fills a connected region and returns the filled points" do
      grid = Collections::Grid.new(3, 3, 0)
      # A 2x2 block of 1s in the top-left, the rest 0.
      grid.set(0, 0, 1)
      grid.set(0, 1, 1)
      grid.set(1, 0, 1)
      grid.set(1, 1, 1)

      filled = grid.flood_fill(0, 0, 9)
      filled.map { |point| {point.x, point.y} }.sort!.should eq([{0, 0}, {0, 1}, {1, 0}, {1, 1}])
      grid.get(0, 0).should eq(9)
      grid.get(1, 1).should eq(9)
      # An untouched cell keeps its value.
      grid.get(2, 2).should eq(0)
    end

    it "does not cross a region boundary of a different value" do
      grid = Collections::Grid.new(1, 3, 0)
      grid.set(0, 0, 1)
      grid.set(0, 1, 2) # wall of a different value
      grid.set(0, 2, 1)

      filled = grid.flood_fill(0, 0, 9)
      filled.map { |point| {point.x, point.y} }.should eq([{0, 0}])
      grid.get(0, 2).should eq(1) # unreached
    end

    it "spreads across diagonals when requested" do
      grid = Collections::Grid.new(3, 3, 0)
      grid.set(0, 0, 1)
      grid.set(1, 1, 1) # only diagonally adjacent to (0, 0)

      orthogonal = Collections::Grid.new(3, 3, 0)
      orthogonal.set(0, 0, 1)
      orthogonal.set(1, 1, 1)
      orthogonal.flood_fill(0, 0, 9).size.should eq(1) # (1,1) not reached

      grid.flood_fill(0, 0, 9, diagonal: true).size.should eq(2) # (1,1) reached
    end

    it "terminates when the new value equals the target value" do
      grid = Collections::Grid.new(2, 2, 5)
      filled = grid.flood_fill(0, 0, 5)
      filled.size.should eq(4)
    end
  end

  describe "#region" do
    it "returns the connected region without modifying the grid" do
      grid = Collections::Grid.new(3, 3, 0)
      grid.set(0, 0, 1)
      grid.set(0, 1, 1)
      grid.set(1, 0, 1)

      region = grid.region(0, 0)
      region.map { |point| {point.x, point.y} }.sort!.should eq([{0, 0}, {0, 1}, {1, 0}])
      # The grid is untouched.
      grid.get(0, 0).should eq(1)
      grid.get(0, 1).should eq(1)
      grid.get(1, 0).should eq(1)
    end

    it "stops at cells of a different value" do
      grid = Collections::Grid.new(1, 3, 0)
      grid.set(0, 0, 1)
      grid.set(0, 1, 2)
      grid.set(0, 2, 1)

      grid.region(0, 0).map { |point| {point.x, point.y} }.should eq([{0, 0}])
    end

    it "spreads across diagonals when requested" do
      grid = Collections::Grid.new(3, 3, 0)
      grid.set(0, 0, 1)
      grid.set(1, 1, 1) # only diagonally adjacent to (0, 0)

      grid.region(0, 0).size.should eq(1)
      grid.region(0, 0, diagonal: true).size.should eq(2)
    end
  end
end
