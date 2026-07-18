# WeightedGraph + Dijkstra: find the cheapest route through a weighted network.
#
# Edges are undirected here (roads work both ways). `shortest_path` returns the
# total cost and the route; `dijkstra` returns the cost to every reachable node.
#
# Run with: crystal run examples/dijkstra_routes.cr
require "../src/collections"

graph = Collections::WeightedGraph(String, Int32).new
graph.add_edge("A", "B", 7)
graph.add_edge("A", "C", 9)
graph.add_edge("B", "C", 10)
graph.add_edge("B", "D", 15)
graph.add_edge("C", "D", 11)
graph.add_edge("C", "F", 2)
graph.add_edge("D", "E", 6)
graph.add_edge("F", "E", 9)

if result = graph.shortest_path("A", "E")
  distance, route = result
  puts "Cheapest A -> E costs #{distance}: #{route.join(" -> ")}"
end

puts
puts "Cheapest cost from A to every city:"
graph.dijkstra("A").to_a.sort_by(&.first).each do |city, cost|
  puts "  #{city}: #{cost}"
end
