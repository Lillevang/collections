require "../src/graph/graph"
require "./spec_helper"

describe Collections::Graph do
  describe "#initialize" do
    it "creates an empty graph" do
      graph = Collections::Graph(Int32).new
      graph.empty?.should be_true
      graph.size.should eq(0)
    end
  end

  describe "#add_node" do
    it "adds a node to the graph" do
      graph = Collections::Graph(Int32).new
      node = graph.add_node(1)
      graph.size.should eq(1)
      node.value.should eq(1)
    end
  end

  describe "#add_edge" do
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

  describe "#remove_edge" do
    it "removes an edge between two nodes" do
      graph = Collections::Graph(Int32).new
      graph.add_edge(1, 2)
      graph.remove_edge(1, 2)
      graph.neighbors(1).should be_empty
      graph.neighbors(2).should be_empty
    end
  end

  describe "#neighbors" do
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
