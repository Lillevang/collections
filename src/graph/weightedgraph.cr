require "../util/node"
require "./graph"

module Collections
    class WeightedGraph(T) < Graph(T)
        @weights : Hash(Tuple(Node(T), Node(T)), Int32)

        def initialize
            super()
            @weights = Hash(Tuple(Node(T), Node(T)), Int32).new
        end

        def add_weighted_edge(val_1 : T, val_2 : T, weight : Int32)
            node_1 = find_or_create_node(val_1)
            node_2 = find_or_create_node(val_2)
            @adjacency_list[node_1] << node_2 unless @adjacency_list[node_1].includes?(node_2)
            @adjacency_list[node_2] << node_1 unless @adjacency_list[node_2].includes?(node_1)
            @weights[{node_1, node_2}] = weight
            @weights[{node_2, node_1}] = weight
        end

        def get_weight(val_1 : T, val_2 : T) : Int32 | Nil
            node_1 = find_node(val_1)
            node_2 = find_node(val_2)
            return nil unless node_1 && node_2
            @weights[{node_1, node_2}]
        end
    end
end