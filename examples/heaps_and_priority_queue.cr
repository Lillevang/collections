# Heaps and a priority queue.
#
# `BinaryHeapMin` / `BinaryHeapMax` give you heapsort and cheap access to the
# smallest/largest element. `PriorityQueue` wraps a min-heap so you can pop
# values in priority order without the value type needing to be comparable.
#
# Run with: crystal run examples/heaps_and_priority_queue.cr
require "../src/collections"

numbers = [5, 2, 9, 1, 7, 3]

min_heap = Collections::BinaryHeapMin(Int32).new
min_heap.add(numbers)
puts "Sorted ascending:  #{min_heap.sort}"

max_heap = Collections::BinaryHeapMax(Int32).new
max_heap.add(numbers)
puts "Sorted descending: #{max_heap.sort}"

puts
puts "Processing tasks by urgency (lower number = more urgent):"

# The value ("task name") is a String; the priority is a separate Int32.
queue = Collections::PriorityQueue(String, Int32).new
queue.push("send weekly email", 5)
queue.push("production outage", 1)
queue.push("daily standup", 3)

until queue.empty?
  task, priority = queue.pop_entry
  puts "  [#{priority}] #{task}"
end
