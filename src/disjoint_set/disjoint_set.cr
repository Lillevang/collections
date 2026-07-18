module Collections
  # A disjoint-set (union-find) structure over arbitrary hashable values, with
  # path compression and union by rank so `find`/`union` run in near-constant
  # amortized time.
  #
  # Values are added lazily: `find`, `union` and `connected?` all register any
  # value they are handed that has not been seen before.
  #
  # ```
  # ds = Collections::DisjointSet(Int32).new
  # ds.union(1, 2)
  # ds.union(2, 3)
  # ds.connected?(1, 3) # => true
  # ds.connected?(1, 4) # => false
  # ds.count            # => 2  (the set {1, 2, 3} and the singleton {4})
  # ```
  class DisjointSet(T)
    def initialize
      @parent = {} of T => T
      @rank = {} of T => Int32
      @count = 0
    end

    # Registers *value* as its own singleton set if it is not already present.
    # Returns `self`.
    def add(value : T) : self
      unless @parent.has_key?(value)
        @parent[value] = value
        @rank[value] = 0
        @count += 1
      end
      self
    end

    # Returns the representative of *value*'s set, compressing the path to the
    # root along the way. Registers *value* first if it is unseen.
    def find(value : T) : T
      add(value)

      root = value
      while @parent[root] != root
        root = @parent[root]
      end

      # Path compression: point every node on the way to the root directly at it.
      while @parent[value] != root
        parent = @parent[value]
        @parent[value] = root
        value = parent
      end

      root
    end

    # Merges the sets containing *a* and *b*. Returns `true` if they were in
    # different sets (and are now merged), or `false` if they were already
    # together.
    def union(a : T, b : T) : Bool
      root_a = find(a)
      root_b = find(b)
      return false if root_a == root_b

      # Attach the shorter tree under the taller one (union by rank).
      root_a, root_b = root_b, root_a if @rank[root_a] < @rank[root_b]
      @parent[root_b] = root_a
      @rank[root_a] += 1 if @rank[root_a] == @rank[root_b]
      @count -= 1
      true
    end

    # Returns whether *a* and *b* belong to the same set.
    def connected?(a : T, b : T) : Bool
      find(a) == find(b)
    end

    # Returns whether *value* has been registered.
    def includes?(value : T) : Bool
      @parent.has_key?(value)
    end

    # Returns the number of disjoint sets.
    def count : Int32
      @count
    end

    # Returns the number of registered elements.
    def size : Int32
      @parent.size
    end

    def empty? : Bool
      @parent.empty?
    end

    # Returns the members of each disjoint set, one array per set.
    def subsets : Array(Array(T))
      groups = {} of T => Array(T)
      @parent.each_key do |value|
        (groups[find(value)] ||= [] of T) << value
      end
      groups.values
    end
  end
end
