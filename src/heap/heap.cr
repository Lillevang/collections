module Collections
  # Should it be another module? Maybe...
  abstract class Heap(T)
    getter elements : Array(T)

    def initialize
      @elements = [] of T
    end

    def add(element : T | Array(T) | Heap(T))
      case element
      when Array(T)
        element.each do |arr_el|
          @elements << arr_el
          swim_up(@elements.size - 1)
        end
      when Heap(T)
        # Prevent self-references or cyclic additions
        if element == self
          raise ArgumentError.new("Cannot add a heap to itself.")
        end

        element.elements.each do |heap_el|
          @elements << heap_el
          swim_up(@elements.size - 1)
        end
      else
        @elements << element
        swim_up(@elements.size - 1)
      end
    end

    private abstract def swim_up(index : Int32)
    private abstract def swim_down(index : Int32)

    def size
      @elements.size
    end

    def sort : Array(T)
      # Create Temporary copy of the heap
      tmp_heap = self.class.new
      tmp_heap.add(@elements)

      # Extract elements in sorted order
      result = [] of T
      until tmp_heap.size == 0
        result.push tmp_heap.extract_root!
      end
      result
    end

    def extract_root
      @elements[0]
    end

    def extract_root!
      swap(0, size - 1)
      el = @elements.pop
      swim_down(0)
      el
    end

    def swap(index1 : Int32, index2 : Int32)
      temp = @elements[index1]
      @elements[index1] = @elements[index2]
      @elements[index2] = temp
    end
  end
end
