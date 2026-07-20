# Collections

`Collections` is a Crystal shard providing generic, dependency-free data
structures that come up again and again in puzzles and algorithm work:

- `BinaryHeapMin` / `BinaryHeapMax` — binary heaps (with heapsort)
- `PriorityQueue` — pop values in priority order
- `Counter` — a multiset / tally, inspired by Python's `collections.Counter`
- `DisjointSet` — union-find with path compression and union by rank
- `Graph` — an undirected graph with clique detection
- `WeightedGraph` — a weighted graph with Dijkstra shortest paths
- `Grid` — a 2D grid with neighbours, flood fill, regions and BFS pathfinding

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  collections:
    github: Lillevang/collections
    version: ~> 0.3.1
```

Run `shards install`

## Usage

```crystal
require "collections"
```

### Heaps

```crystal
heap = Collections::BinaryHeapMin(Int32).new
heap.add([10, 20, 5])
heap.sort           # => [5, 10, 20]  (non-destructive)
heap.extract_root!  # => 5

Collections::BinaryHeapMax(Int32).new.tap(&.add([10, 20, 5])).extract_root! # => 20
```

### PriorityQueue

The value and the priority are independent types — the value need not be
comparable.

```crystal
pq = Collections::PriorityQueue(String, Int32).new
pq.push("low", 5)
pq.push("high", 1)
pq.pop # => "high"
```

### Counter

Counts are stored as `Int64`, so large tallies do not overflow. Missing keys
read as `0`.

```crystal
counter = Collections::Counter(Char).new("mississippi".chars)
counter['s']           # => 4
counter['z']           # => 0
counter.most_common(2) # => [{'i', 4}, {'s', 4}]
```

### DisjointSet (union-find)

```crystal
ds = Collections::DisjointSet(Int32).new
ds.union(1, 2)
ds.union(2, 3)
ds.connected?(1, 3) # => true
ds.count            # => 1  (number of disjoint sets)
```

### Graph

```crystal
graph = Collections::Graph(Int32).new
graph.add_edge(1, 2)
graph.add_edge(1, 3)
graph.neighbors(1).map(&.value) # => [2, 3]
```

### WeightedGraph + Dijkstra

```crystal
graph = Collections::WeightedGraph(String, Int32).new
graph.add_edge("a", "b", 1)
graph.add_edge("b", "c", 2)
graph.shortest_path("a", "c") # => {3, ["a", "b", "c"]}
graph.dijkstra("a")           # => {"a" => 0, "b" => 1, "c" => 3}
```

### Grid

```crystal
grid = Collections::Grid(Char).from_string("...\n.#.\n...")
grid.neighbors(0, 0)          # orthogonal, in-bounds, unblocked cells
grid.neighbors(1, 1, diagonal: true)

if result = grid.shortest_path({0, 0}, {2, 2})
  distance, path = result
  puts distance
  grid.print_grid(path)
end
```

## Examples

Runnable, Advent-of-Code-flavoured programs live in [`examples/`](examples).
Run any of them with `crystal run`:

```sh
crystal run examples/lanternfish.cr
```

| Example                        | Shows                                          |
| ------------------------------ | ---------------------------------------------- |
| `grid_pathfinding.cr`          | Parse a maze from text and BFS the shortest path |
| `lanternfish.cr`               | `Counter` as a fast-growing `Int64` tally      |
| `connected_components.cr`      | `DisjointSet` clustering                        |
| `dijkstra_routes.cr`           | `WeightedGraph` + Dijkstra shortest paths       |
| `heaps_and_priority_queue.cr`  | Heapsort and a priority queue                   |
| `graph_cliques.cr`             | `Graph` clique detection                        |

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
