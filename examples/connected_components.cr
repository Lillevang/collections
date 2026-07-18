# DisjointSet (union-find): group items into connected clusters and count them.
#
# A common Advent of Code shape: you're given a list of pairwise connections and
# need to know how many separate groups form, or whether two items are linked.
#
# Run with: crystal run examples/connected_components.cr
require "../src/collections"

friendships = [
  {"alice", "bob"},
  {"bob", "carol"},
  {"dave", "erin"},
]

ds = Collections::DisjointSet(String).new
friendships.each { |(a, b)| ds.union(a, b) }
ds.add("grace") # someone with no connections yet

puts "There are #{ds.count} clusters:"
ds.subsets.each do |group|
  puts "  - #{group.sort.join(", ")}"
end

puts
puts "alice & carol connected? #{ds.connected?("alice", "carol")}"
puts "alice & dave  connected? #{ds.connected?("alice", "dave")}"
