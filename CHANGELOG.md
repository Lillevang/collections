# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.3.0] - 2026-07-18

Grows `Collections` from a heap/graph/grid toolkit into a broader set of
puzzle-ready data structures, and hardens the existing ones. All new code ships
with specs, and runnable examples live in `examples/`.

### Added

- `Counter(T)` — a Python-`Counter`-style multiset/tally. Missing keys read as
  `0`, reads never mutate, plus `most_common`, `total`, `elements`, and `+`/`-`.
  Counts are stored as `Int64` so large accumulations do not overflow.
- `DisjointSet(T)` — union-find with path compression and union by rank. Lazy
  registration, `union`/`connected?`, and `count`/`subsets`.
- `PriorityQueue(T, P)` — a min-priority queue built on `BinaryHeap`; the value
  and priority are independent types (the value need not be comparable).
- `WeightedGraph(T, W)` — weighted edges (directed or undirected) with Dijkstra
  `shortest_path` and full-distance `dijkstra`.
- `Grid.from_string` — build a grid from a multi-line string; `Grid(Char)` out of
  the box, or map each character to any type via a block.
- `Grid#neighbors` gains `diagonal:` (include the four diagonal cells) and
  `toroidal:` (wrap across edges) options.
- `Grid#wrap` — normalise a coordinate onto the grid (wrap-around indexing).
- `Grid#flood_fill` — paint-bucket fill of a connected same-value region.
- `Grid#region` — the connected region as points, without mutating the grid.
- `examples/` folder with six runnable, Advent-of-Code-flavoured programs.
- README rewritten to cover every structure with usage snippets.

### Changed

- **Minimum Crystal is now 1.21.0** (was 1.14.0).
- `Graph` node lookup is now O(1) (indexed by value) instead of scanning the
  adjacency list on every `find`/`add_edge`/`neighbors`.
- `Grid#shortest_path` BFS rewritten to use a `Deque`, mark cells visited on
  enqueue, and reconstruct the path from a `came_from` map — no more per-entry
  path copies or unbounded queue growth.
- `Heap#extract_root` / `#extract_root!` raise a clear error when the heap is
  empty.
- `ameba` is pinned to `master` so linting builds on Crystal 1.21.

### Fixed

- Removed dead, mistyped code in `Graph#largest_clique`.
- Synced the internal `VERSION` constant with `shard.yml`.

[Unreleased]: https://github.com/Lillevang/collections/compare/v0.3.0...HEAD
[0.3.0]: https://github.com/Lillevang/collections/releases/tag/v0.3.0
