require "../src/priority_queue/priority_queue"
require "./spec_helper"

describe Collections::PriorityQueue do
  describe "#initialize" do
    it "creates an empty queue" do
      pq = Collections::PriorityQueue(String, Int32).new
      pq.empty?.should be_true
      pq.size.should eq(0)
    end
  end

  describe "#push and #pop" do
    it "pops values lowest-priority first" do
      pq = Collections::PriorityQueue(String, Int32).new
      pq.push("low", 5)
      pq.push("high", 1)
      pq.push("mid", 3)

      pq.pop.should eq("high")
      pq.pop.should eq("mid")
      pq.pop.should eq("low")
      pq.empty?.should be_true
    end

    it "chains pushes" do
      pq = Collections::PriorityQueue(Int32, Int32).new
      pq.push(10, 2).push(20, 1)
      pq.size.should eq(2)
      pq.pop.should eq(20)
    end

    it "works with float priorities" do
      pq = Collections::PriorityQueue(Symbol, Float64).new
      pq.push(:a, 2.5)
      pq.push(:b, 0.1)
      pq.pop.should eq(:b)
    end
  end

  describe "#pop_entry" do
    it "returns the value together with its priority" do
      pq = Collections::PriorityQueue(String, Int32).new
      pq.push("a", 7)
      pq.pop_entry.should eq({"a", 7})
    end
  end

  describe "#peek" do
    it "returns the lowest-priority value without removing it" do
      pq = Collections::PriorityQueue(String, Int32).new
      pq.push("a", 3)
      pq.push("b", 1)

      pq.peek.should eq("b")
      pq.size.should eq(2)
      pq.peek_entry.should eq({"b", 1})
    end
  end

  describe "nil-returning variants" do
    it "return nil on an empty queue" do
      pq = Collections::PriorityQueue(String, Int32).new
      pq.pop?.should be_nil
      pq.peek?.should be_nil
      pq.pop_entry?.should be_nil
      pq.peek_entry?.should be_nil
    end
  end

  describe "raising variants" do
    it "raise IndexError on an empty queue" do
      pq = Collections::PriorityQueue(String, Int32).new
      expect_raises(IndexError, "priority queue is empty") { pq.pop }
      expect_raises(IndexError, "priority queue is empty") { pq.peek }
    end
  end
end
