require "../src/heap/heap"
require "./spec_helper"

describe Collections::Heap do
    it "Initializes the heap" do
        heap = TestHeap(Int32).new
        heap.elements.should eq(Array(Int32).new)
    end

    it "Adds elements to the heap" do
        heap = TestHeap(Int32).new
        heap.add(10)
        heap.add([20, 5])
        
        other_heap = TestHeap(Int32).new
        other_heap.add([30, 40])
        
        heap.add(other_heap)
        heap.size.should eq(5)
        heap.elements.should eq([5, 20, 10, 30, 40])
    end

    it "Extracts the root element" do
        heap = TestHeap(Int32).new
        heap.add([10, 20, 5])
        heap.extract_root.should eq(5)
    end

    it "Sorts the heap" do
        heap = TestHeap(Int32).new
        heap.add([10, 20, 5])
        sorted = heap.sort
        sorted.should eq([5, 10, 20])
        heap.size.should eq(3)
    end

    it "Swaps elements correctly" do
        heap = TestHeap(Int32).new
        heap.add([10, 20])
        heap.swap(0, 1)
        heap.elements.should eq([20, 10])
    end
end