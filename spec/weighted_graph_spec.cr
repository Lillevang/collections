require "../src/weighted_graph/weighted_graph"
require "./spec_helper"

describe Collections::WeightedGraph do
  describe "#initialize" do
    it "creates an empty graph" do
      graph = Collections::WeightedGraph(String, Int32).new
      graph.empty?.should be_true
      graph.size.should eq(0)
    end
  end

  describe "#add_edge" do
    it "adds undirected edges by default" do
      graph = Collections::WeightedGraph(String, Int32).new
      graph.add_edge("a", "b", 4)

      graph.weight("a", "b").should eq(4)
      graph.weight("b", "a").should eq(4)
      graph.nodes.sort.should eq(["a", "b"])
    end

    it "adds a one-way edge when directed" do
      graph = Collections::WeightedGraph(String, Int32).new
      graph.add_edge("a", "b", 4, directed: true)

      graph.weight("a", "b").should eq(4)
      graph.weight("b", "a").should be_nil
    end

    it "overwrites the weight when re-adding an edge" do
      graph = Collections::WeightedGraph(String, Int32).new
      graph.add_edge("a", "b", 4)
      graph.add_edge("a", "b", 1)
      graph.weight("a", "b").should eq(1)
    end
  end

  describe "#neighbors" do
    it "returns the neighbor-to-weight map" do
      graph = Collections::WeightedGraph(String, Int32).new
      graph.add_edge("a", "b", 1)
      graph.add_edge("a", "c", 2)
      graph.neighbors("a").should eq({"b" => 1, "c" => 2})
    end

    it "returns an empty map for an absent node" do
      graph = Collections::WeightedGraph(String, Int32).new
      graph.neighbors("missing").should be_empty
    end
  end

  describe "#dijkstra" do
    it "returns shortest distances to all reachable nodes" do
      graph = Collections::WeightedGraph(String, Int32).new
      graph.add_edge("a", "b", 1)
      graph.add_edge("b", "c", 1)
      graph.add_edge("a", "c", 5)

      distances = graph.dijkstra("a")
      distances.should eq({"a" => 0, "b" => 1, "c" => 2})
    end

    it "omits unreachable nodes" do
      graph = Collections::WeightedGraph(String, Int32).new
      graph.add_edge("a", "b", 1)
      graph.add_node("island")

      distances = graph.dijkstra("a")
      distances.has_key?("island").should be_false
    end
  end

  describe "#shortest_path" do
    it "prefers a cheaper multi-hop path over an expensive direct edge" do
      graph = Collections::WeightedGraph(String, Int32).new
      graph.add_edge("a", "b", 1)
      graph.add_edge("b", "c", 1)
      graph.add_edge("a", "c", 5)

      graph.shortest_path("a", "c").should eq({2, ["a", "b", "c"]})
    end

    it "returns a zero-length path from a node to itself" do
      graph = Collections::WeightedGraph(String, Int32).new
      graph.add_node("a")
      graph.shortest_path("a", "a").should eq({0, ["a"]})
    end

    it "returns nil when the target is unreachable" do
      graph = Collections::WeightedGraph(String, Int32).new
      graph.add_edge("a", "b", 1)
      graph.add_node("c")
      graph.shortest_path("a", "c").should be_nil
    end

    it "respects edge direction" do
      graph = Collections::WeightedGraph(String, Int32).new
      graph.add_edge("a", "b", 1, directed: true)
      graph.shortest_path("a", "b").should eq({1, ["a", "b"]})
      graph.shortest_path("b", "a").should be_nil
    end

    it "works with float weights" do
      graph = Collections::WeightedGraph(Symbol, Float64).new
      graph.add_edge(:a, :b, 1.5)
      graph.add_edge(:b, :c, 2.0)
      graph.shortest_path(:a, :c).should eq({3.5, [:a, :b, :c]})
    end
  end
end
