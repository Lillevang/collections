require "../util/node"

module Collections
  class Graph(T)
    @adjacency_list : Hash(Node(T), Array(Node(T)))

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

    private def find_or_create_node(value : T) : Node(T)
      find_node(value) || add_node(value)
    end

    private def find_node(value : T) : Node(T)?
      @adjacency_list.keys.find { |n| n.value == value }
    end
  end
end