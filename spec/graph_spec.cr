require "../src/graph/graph"
require "./spec_helper"

describe Collections::Graph do
  describe "initialize" do
    it "creates an empty graph" do
      graph = Collections::Graph(Int32).new
      graph.empty?.should be_true
      graph.size.should eq(0)
    end
  end

  describe "add_node" do
    it "adds a node to the graph" do
      graph = Collections::Graph(Int32).new
      node = graph.add_node(1)
      graph.size.should eq(1)
      node.value.should eq(1)
    end
  end

  describe "add_edge" do
    it "adds an edge between two nodes" do
      graph = Collections::Graph(Int32).new
      graph.add_edge(1, 2)
      graph.neighbors(1).size.should eq(1)
      graph.neighbors(2).size.should eq(1)
    end

    it "does not add duplicate edges" do
      graph = Collections::Graph(Int32).new
      graph.add_edge(1, 2)
      graph.add_edge(1, 2)
      graph.neighbors(1).size.should eq(1)
    end
  end

  describe "remove_edge" do
    it "removes an edge between two nodes" do
      graph = Collections::Graph(Int32).new
      graph.add_edge(1, 2)
      graph.remove_edge(1, 2)
      graph.neighbors(1).should be_empty
      graph.neighbors(2).should be_empty
    end
  end

  describe "neighbors" do
    it "returns empty array for non-existent node" do
      graph = Collections::Graph(Int32).new
      graph.neighbors(1).should be_empty
    end

    it "returns adjacent nodes" do
      graph = Collections::Graph(Int32).new
      graph.add_edge(1, 2)
      graph.add_edge(1, 3)
      graph.neighbors(1).size.should eq(2)
    end
  end
end
describe "fully_connected?" do
  it "returns true for empty array" do
    graph = Collections::Graph(Int32).new
    graph.fully_connected?([] of Int32).should be_true
  end

  it "returns true for single node" do
    graph = Collections::Graph(Int32).new
    graph.add_node(1)
    graph.fully_connected?([1]).should be_true
  end

  it "returns true for two connected nodes" do
    graph = Collections::Graph(Int32).new
    graph.add_edge(1, 2)
    graph.fully_connected?([1, 2]).should be_true
  end

  it "returns true for three fully connected nodes" do
    graph = Collections::Graph(Int32).new
    graph.add_edge(1, 2)
    graph.add_edge(2, 3)
    graph.add_edge(1, 3)
    graph.fully_connected?([1, 2, 3]).should be_true
  end

  it "returns false for three partially connected nodes" do
    graph = Collections::Graph(Int32).new
    graph.add_edge(1, 2)
    graph.add_edge(2, 3)
    #Missing edge between 1 and 3
    graph.fully_connected?([1, 2, 3]).should be_false
  end
end

describe "find_subgraphs" do
  it "finds all connected pairs" do
    graph = Collections::Graph(Int32).new
    graph.add_edge(1, 2)
    graph.add_edge(2, 3)
    graph.add_edge(1, 3)
    subgraphs = graph.find_subgraphs(2)
    subgraphs.size.should eq(3)
    subgraphs.should contain([1, 2])
    subgraphs.should contain([2, 3])
    subgraphs.should contain([1, 3])
  end

  it "finds triangle subgraphs" do
    graph = Collections::Graph(Int32).new
    graph.add_edge(1, 2)
    graph.add_edge(2, 3)
    graph.add_edge(1, 3)
    subgraphs = graph.find_subgraphs(3)
    subgraphs.size.should eq(1)
    subgraphs.first.should eq([1, 2, 3])
  end

  it "returns empty array for impossible size" do
    graph = Collections::Graph(Int32).new
    graph.add_edge(1, 2)
    graph.find_subgraphs(3).should be_empty
  end
end

describe "largest_clique" do
  it "returns empty array for empty graph" do
    graph = Collections::Graph(Int32).new
    graph.largest_clique.should be_empty
  end

  it "returns single node for isolated node" do
    graph = Collections::Graph(Int32).new
    graph.add_node(1)
    graph.largest_clique.should eq([1])
  end

  it "finds clique in triangle" do
    graph = Collections::Graph(Int32).new
    graph.add_edge(1, 2)
    graph.add_edge(2, 3)
    graph.add_edge(1, 3)
    graph.largest_clique.should eq([1, 2, 3])
  end

  it "finds largest clique in complex graph" do
    graph = Collections::Graph(Int32).new
    # Create a graph with a 4-clique and a triangle
    graph.add_edge(1, 2)
    graph.add_edge(1, 3)
    graph.add_edge(1, 4)
    graph.add_edge(2, 3)
    graph.add_edge(2, 4)
    graph.add_edge(3, 4)
    graph.add_edge(5, 6)
    graph.add_edge(6, 7)
    graph.add_edge(5, 7)
    graph.largest_clique.should eq([1, 2, 3, 4])
  end
end
