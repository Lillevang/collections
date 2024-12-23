require "spec"
require "../src/heap/heap"

class TestHeap(T) < Collections::Heap(T)
  private def swim_up(index : Int32)
    while index > 0
      parent_index = (index - 1) // 2
      if compare(@elements[index], @elements[parent_index]) < 0
        swap(index, parent_index)
      else
        break
      end
      index = parent_index
    end
  end

  private def compare(a : T, b : T) : Int32
    # Use standard comparison
    a <=> b
  end

  private def swim_down(index : Int32)
    size = @elements.size

    loop do
      left_child = 2 * index + 1
      right_child = 2 * index + 2
      target = index

      # Compare with left child
      if left_child < size && compare(@elements[left_child], @elements[target]) < 0
        target = left_child
      end

      # Compare with right child
      if right_child < size && compare(@elements[right_child], @elements[target]) < 0
        target = right_child
      end

      # If no swap is needed, the heap property is satisfied
      break if target == index

      swap(index, target)
      index = target
    end
  end
end
