# Collections

`Collections` is a Crystal shard that provides generic data structures like heaps, including:

- `BinaryHeapMin`: A min-heap implementation
- `BinaryHeapMax`: A max-heap implementation

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  collections:
    github: Lillevang/collections
    version: ~> 0.2.5
```

Run `shards install`

## Usage

```crystal
require "collections"

# Min-Heap Example
heap = Collections::BinaryHeapMin(Int32).new
heap.add([10, 20, 5])
puts heap.extract_root! # => 5

# Max-Heap Example
heap = Collections::BinaryHeapMax(Int32).new
heap.add([10, 20, 5])
puts heap.extract_root! # => 20

# Graph Example
graph = Collections::Graph(Int32).new
graph.add_edge(1, 2)
graph.add_edge(1, 3)
puts graph.neighbors(1).map(&.value) # => [2, 3]

# Grid Example
grid = Collections::Grid(Int32).new(3, 3, 0)
grid.set(1, 1, 1) # block a cell
if result = grid.shortest_path({0, 0}, {2, 2})
  distance, path = result
  puts distance                     # => 4
  grid.print_grid(path)
end
```

## Development

Write code, good code preferred!

Run tests with: `crystal spec`

## Contributing

1. Fork it (<https://github.com/Lillevang/collections/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

Released under the MIT License. See LICENSE for details.

## Contributors

- [Lillevang](https://github.com/Lillevang) - creator and maintainer
