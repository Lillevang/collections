require "./spec_helper"

describe Collections do
  it "Can create a heap" do
    heap = TestHeap(Int32).new
    heap.elements.should eq(Array(Int32).new)
  end
end
