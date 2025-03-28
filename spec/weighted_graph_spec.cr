require "../src/graph/weightedgraph"
require "./spec_helper"

describe Collections::WeightedGraph do
    describe "initialize" do
        it "creates an empty graph" do
            graph = Collections::WeightedGraph(Int32).new
            graph.empty?.should be_true
            graph.size.should eq(0)
        end
    end

    describe "add_weighted_edge" do
        it "adds a weighted edge between two nodes" do
            graph = Collections::WeightedGraph(Int32).new
            graph.add_weighted_edge(1, 2, 10)
            graph.get_weight(1, 2).should eq(10)
        end
    end

    describe "add_weighted_edge_string" do
        it "adds a weighted edge between two nodes" do
            graph = Collections::WeightedGraph(String).new
            graph.add_weighted_edge("city_a", "city_b", 1000)
            graph.get_weight("city_a", "city_b").should eq(1000)
        end
    end
end