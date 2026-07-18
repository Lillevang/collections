# Graph: an undirected graph with clique detection, in the spirit of Advent of
# Code 2024 Day 23 ("LAN party") — find fully-connected groups of computers.
#
# Run with: crystal run examples/graph_cliques.cr
require "../src/collections"

graph = Collections::Graph(String).new

# kh, tc, qp and wh are all mutually connected (a 4-clique); ub-vc are a
# separate pair.
edges = [
  {"kh", "tc"}, {"qp", "kh"}, {"tc", "qp"},
  {"tc", "wh"}, {"wh", "qp"}, {"wh", "kh"},
  {"ub", "vc"},
]
edges.each { |(a, b)| graph.add_edge(a, b) }

puts "Fully-connected triples: #{graph.find_subgraphs(3).size}"
puts "Largest clique: #{graph.largest_clique.join(",")}"
puts "Neighbours of wh: #{graph.neighbors("wh").map(&.value).sort!.join(", ")}"
