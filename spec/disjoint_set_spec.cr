require "../src/disjoint_set/disjoint_set"
require "./spec_helper"

describe Collections::DisjointSet do
  describe "#initialize" do
    it "creates an empty structure" do
      ds = Collections::DisjointSet(Int32).new
      ds.empty?.should be_true
      ds.size.should eq(0)
      ds.count.should eq(0)
    end
  end

  describe "#add" do
    it "registers a value as its own singleton set" do
      ds = Collections::DisjointSet(Int32).new
      ds.add(1)
      ds.includes?(1).should be_true
      ds.size.should eq(1)
      ds.count.should eq(1)
    end

    it "is idempotent" do
      ds = Collections::DisjointSet(Int32).new
      ds.add(1)
      ds.add(1)
      ds.size.should eq(1)
      ds.count.should eq(1)
    end
  end

  describe "#find" do
    it "auto-registers an unseen value" do
      ds = Collections::DisjointSet(String).new
      ds.find("x").should eq("x")
      ds.includes?("x").should be_true
    end
  end

  describe "#union" do
    it "merges two sets and reports the merge" do
      ds = Collections::DisjointSet(Int32).new
      ds.union(1, 2).should be_true
      ds.connected?(1, 2).should be_true
      ds.count.should eq(1)
    end

    it "returns false when the values are already connected" do
      ds = Collections::DisjointSet(Int32).new
      ds.union(1, 2)
      ds.union(1, 2).should be_false
      ds.count.should eq(1)
    end

    it "connects values transitively through a chain of unions" do
      ds = Collections::DisjointSet(Int32).new
      ds.union(1, 2)
      ds.union(2, 3)
      ds.union(3, 4)
      ds.connected?(1, 4).should be_true
      ds.count.should eq(1)
      ds.size.should eq(4)
    end
  end

  describe "#connected?" do
    it "returns false for values in different sets" do
      ds = Collections::DisjointSet(Int32).new
      ds.union(1, 2)
      ds.connected?(1, 3).should be_false
    end
  end

  describe "#subsets" do
    it "groups every element by its set" do
      ds = Collections::DisjointSet(Int32).new
      ds.union(1, 2)
      ds.union(3, 4)
      ds.add(5)

      subsets = ds.subsets.map(&.sort).sort_by!(&.first)
      subsets.should eq([[1, 2], [3, 4], [5]])
      ds.count.should eq(3)
    end
  end
end
