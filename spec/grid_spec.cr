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
    grid.blocked?(1, 1).should eq(true)
    grid.blocked?(2, 2).should eq(true)
    grid.blocked?(3, 3).should eq(true)
    grid.blocked?(4, 4).should eq(false)
    grid.set(4, 4, true) # mark as blocked
    grid.blocked?(4, 4).should eq(true)
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
end
