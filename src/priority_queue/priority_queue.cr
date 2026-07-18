require "../heap/heap"
require "../heap/binary_heap"

module Collections
  # A min-priority queue: values are popped lowest-priority-first. Built as a
  # thin wrapper over `BinaryHeapMin`, so pushes and pops are `O(log n)`.
  #
  # The value type `T` and the priority type `P` are independent — `T` need not
  # be comparable, only `P` (any type whose `<=>` yields a non-nil `Int32`, such
  # as `Int32`, `Int64` or `Float64`).
  #
  # ```
  # pq = Collections::PriorityQueue(String, Int32).new
  # pq.push("low", 5)
  # pq.push("high", 1)
  # pq.pop # => "high"
  # ```
  class PriorityQueue(T, P)
    # Pairs a value with its priority and orders solely by priority, so the
    # value itself does not need to be comparable.
    private struct Entry(T, P)
      include Comparable(Entry(T, P))

      getter value : T
      getter priority : P

      def initialize(@value : T, @priority : P)
      end

      def <=>(other : Entry(T, P)) : Int32
        result = priority <=> other.priority
        raise ArgumentError.new("priorities are not comparable") if result.nil?
        result
      end
    end

    def initialize
      @heap = BinaryHeapMin(Entry(T, P)).new
    end

    # Adds *value* with the given *priority*. Returns `self` for chaining.
    def push(value : T, priority : P) : self
      @heap.add(Entry(T, P).new(value, priority))
      self
    end

    # Removes and returns the lowest-priority value. Raises `IndexError` when
    # the queue is empty.
    def pop : T
      pop_entry[0]
    end

    # Like `#pop`, but returns `nil` when the queue is empty.
    def pop? : T?
      pop_entry?.try(&.[0])
    end

    # Removes and returns the lowest-priority `{value, priority}` pair. Raises
    # `IndexError` when the queue is empty.
    def pop_entry : {T, P}
      raise IndexError.new("priority queue is empty") if empty?
      entry = @heap.extract_root!
      {entry.value, entry.priority}
    end

    # Like `#pop_entry`, but returns `nil` when the queue is empty.
    def pop_entry? : {T, P}?
      empty? ? nil : pop_entry
    end

    # Returns the lowest-priority value without removing it. Raises `IndexError`
    # when the queue is empty.
    def peek : T
      peek_entry[0]
    end

    # Like `#peek`, but returns `nil` when the queue is empty.
    def peek? : T?
      peek_entry?.try(&.[0])
    end

    # Returns the lowest-priority `{value, priority}` pair without removing it.
    # Raises `IndexError` when the queue is empty.
    def peek_entry : {T, P}
      raise IndexError.new("priority queue is empty") if empty?
      entry = @heap.extract_root
      {entry.value, entry.priority}
    end

    # Like `#peek_entry`, but returns `nil` when the queue is empty.
    def peek_entry? : {T, P}?
      empty? ? nil : peek_entry
    end

    def size : Int32
      @heap.size
    end

    def empty? : Bool
      @heap.size == 0
    end
  end
end
