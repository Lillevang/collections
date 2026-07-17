require "../priority_queue/priority_queue"

module Collections
  # A graph whose edges carry weights, with Dijkstra shortest-path search built
  # on `PriorityQueue`. `T` is the node/value type (any hashable value) and `W`
  # is the weight type (a non-negative numeric type such as `Int32` or
  # `Float64`).
  #
  # Edges are undirected by default; pass `directed: true` to add a one-way edge.
  #
  # ```
  # graph = Collections::WeightedGraph(String, Int32).new
  # graph.add_edge("a", "b", 1)
  # graph.add_edge("b", "c", 2)
  # graph.shortest_path("a", "c") # => {3, ["a", "b", "c"]}
  # ```
  #
  # NOTE: Dijkstra assumes non-negative weights; negative edges are not
  # supported.
  class WeightedGraph(T, W)
    getter adjacency : Hash(T, Hash(T, W))

    def initialize
      @adjacency = Hash(T, Hash(T, W)).new
    end

    # Registers *value* as a node if it is not already present, and returns its
    # (possibly newly created) outgoing-edge map.
    def add_node(value : T) : Hash(T, W)
      @adjacency[value] ||= {} of T => W
    end

    # Adds an edge from *from* to *to* with the given *weight*. Undirected by
    # default (the reverse edge is added too); pass `directed: true` for a
    # one-way edge. Re-adding an existing edge overwrites its weight.
    def add_edge(from : T, to : T, weight : W, directed : Bool = false) : Nil
      add_node(from)
      add_node(to)
      @adjacency[from][to] = weight
      @adjacency[to][from] = weight unless directed
    end

    # Returns the outgoing edges of *value* as a `{neighbor => weight}` map, or
    # an empty map if the node is absent.
    def neighbors(value : T) : Hash(T, W)
      @adjacency[value]? || {} of T => W
    end

    # Returns the weight of the edge from *from* to *to*, or `nil` if there is
    # no such edge.
    def weight(from : T, to : T) : W?
      @adjacency[from]?.try &.[to]?
    end

    def nodes : Array(T)
      @adjacency.keys
    end

    def size : Int32
      @adjacency.size
    end

    def empty? : Bool
      @adjacency.empty?
    end

    # Runs Dijkstra from *source*, returning the shortest distance to every
    # reachable node (including *source* itself at distance zero). Unreachable
    # nodes are simply absent from the result.
    def dijkstra(source : T) : Hash(T, W)
      distances = {} of T => W
      return distances unless @adjacency.has_key?(source)

      distances[source] = W.zero
      queue = PriorityQueue(T, W).new
      queue.push(source, W.zero)

      until queue.empty?
        node, distance = queue.pop_entry
        # Skip stale queue entries superseded by a shorter path.
        next if distance > distances[node]

        neighbors(node).each do |neighbor, edge_weight|
          candidate = distance + edge_weight
          if !distances.has_key?(neighbor) || candidate < distances[neighbor]
            distances[neighbor] = candidate
            queue.push(neighbor, candidate)
          end
        end
      end

      distances
    end

    # Returns the shortest path from *source* to *target* as
    # `{total_distance, [source, ..., target]}`, or `nil` if *target* is
    # unreachable (or either node is absent).
    def shortest_path(source : T, target : T) : {W, Array(T)}?
      return unless @adjacency.has_key?(source) && @adjacency.has_key?(target)

      distances = {} of T => W
      previous = {} of T => T
      distances[source] = W.zero
      queue = PriorityQueue(T, W).new
      queue.push(source, W.zero)

      until queue.empty?
        node, distance = queue.pop_entry
        next if distance > distances[node]
        break if node == target # its distance is now final

        neighbors(node).each do |neighbor, edge_weight|
          candidate = distance + edge_weight
          if !distances.has_key?(neighbor) || candidate < distances[neighbor]
            distances[neighbor] = candidate
            previous[neighbor] = node
            queue.push(neighbor, candidate)
          end
        end
      end

      return unless distances.has_key?(target)
      {distances[target], reconstruct_path(previous, source, target)}
    end

    # Walks the `previous` chain back from target to source, returning the path
    # ordered source -> target (inclusive).
    private def reconstruct_path(previous : Hash(T, T), source : T, target : T) : Array(T)
      path = [target]
      current = target
      while current != source
        current = previous[current]
        path << current
      end
      path.reverse!
    end
  end
end
