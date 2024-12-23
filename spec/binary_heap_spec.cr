require "./spec_helper"
require "../src/heap/binary_heap"

describe Collections::BinaryHeapMin do
  it "Maintains the min-heap property" do
    heap = Collections::BinaryHeapMin(Int32).new
    heap.add([10, 20, 5])

    # The smallest element should always be extracted first
    heap.extract_root!.should eq(5)
    heap.extract_root!.should eq(10)
    heap.extract_root!.should eq(20)
  end

  it "maintains the min-heap property with a large dataset" do
    heap = Collections::BinaryHeapMin(Int32).new

    # Generate a dataset of 10,000 random numbers
    dataset = Array.new(10_000) { rand(1..1_000_000) }
    heap.add(dataset)

    # Extract all elements from the heap
    sorted = [] of Int32
    while heap.size > 0
      sorted << heap.extract_root!
    end

    # The extracted elements should be in ascending order
    sorted.should eq(dataset.sort)
  end
end

describe Collections::BinaryHeapMax do
  it "Maintains the max-heap property" do
    heap = Collections::BinaryHeapMax(Int32).new
    heap.add([10, 20, 5])

    # The largest element should always be extracted first
    heap.extract_root!.should eq(20)
    heap.extract_root!.should eq(10)
    heap.extract_root!.should eq(5)
  end

  it "maintains the max-heap property with a large dataset" do
    heap = Collections::BinaryHeapMax(Int32).new

    # Generate a dataset of 10,000 random numbers
    dataset = Array.new(10_000) { rand(1..1_000_000) }
    heap.add(dataset)

    # Extract all elements from the heap
    sorted = [] of Int32
    while heap.size > 0
      sorted << heap.extract_root!
    end

    # The extracted elements should be in descending order
    sorted.should eq(dataset.sort.reverse!)
  end
end
