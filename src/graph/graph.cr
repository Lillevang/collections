require "../util/node"

module Collections
  class Graph(T)
    property adjacency_list : Hash(Node(T), Array(Node(T)))

    def initialize
      @adjacency_list = {} of Node(T) => Array(Node(T))
    end

    def add_node(value : T)
      node = Node.new(value)
      @adjacency_list[node] ||= [] of Node(T)
      node
    end

    def add_edge(value_1 : T, value_2 : T)
      node_1 = find_or_create_node(value_1)
      node_2 = find_or_create_node(value_2)
      @adjacency_list[node_1] << node_2 unless @adjacency_list[node_1].includes?(node_2)
      @adjacency_list[node_2] << node_1 unless @adjacency_list[node_2].includes?(node_1)
    end

    def remove_edge(value_1 : T, value_2 : T)
      node_1 = find_node(value_1)
      node_2 = find_node(value_2)
      return unless node_1 && node_2
      @adjacency_list[node_1].delete(node_2)
      @adjacency_list[node_2].delete(node_1)
    end

    def neighbors(value : T) : Array(Node(T))
      node = find_node(value)
      node ? @adjacency_list[node] : [] of Node(T)
    end

    def size : Int32
      @adjacency_list.size
    end

    def empty? : Bool
      @adjacency_list.empty?
    end

    def fully_connected?(nodes : Array(T)) : Bool
      return true if nodes.empty?
      nodes.each_with_index do |node1, i|
        ((i + 1)...nodes.size).each do |j|
          node2 = nodes[j]
          neighbors = neighbors(node1).map(&.value)
          return false unless neighbors.includes?(node2)
        end
      end
      true
    end

    def find_subgraphs(size : Int32) : Array(Array(T))
      nodes = @adjacency_list.keys.map(&.value)
      subgraphs = [] of Array(T)

      nodes.combinations(size).each do |combination|
        subgraphs << combination if fully_connected?(combination)
      end
      subgraphs
    end

    def largest_clique : Array(T)
      nodes = @adjacency_list.keys.map(&.value)                           # Get all node values
      nodes = nodes.sort_by { |node| -(neighbors(node) || [] of T).size } # Sort by degree (descending)
      max_clique = [] of T

      backtrack_clique([] of T, nodes, max_clique) # Call the backtracking function
      max_clique.sort
    end

    private def backtrack_clique(current_clique : Array(T), candidates : Array(T), max_clique : Array(T))
      if candidates.empty?
        if current_clique.size > max_clique.size
          max_clique.clear
          max_clique.concat(current_clique)
        end
        return
      end

      candidates.each_with_index do |candidate, i|
        # Extend the current clique
        new_clique = current_clique + [candidate]
        # Filter candidates to keep only neighbors of the current candidate
        node = find_node(candidate)
        next unless node

        new_candidates = candidates[(i + 1)..-1].select do |other|
          neighbor_values = neighbors(candidate).map(&.value)
          neighbor_values.includes?(other)
        end
        # Recurse
        backtrack_clique(new_clique, new_candidates, max_clique)
      end
    end

    private def find_or_create_node(value : T) : Node(T)
      find_node(value) || add_node(value)
    end

    private def find_node(value : T) : Node(T)?
      @adjacency_list.keys.find { |node| node.value == value }
    end
  end
end
