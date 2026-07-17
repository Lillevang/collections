module Collections
  # A multiset / tally that counts occurrences of values, inspired by Python's
  # `collections.Counter`. Missing keys read as `0`, and reading a key never
  # creates an entry.
  #
  # ```
  # counter = Collections::Counter(Char).new("mississippi".chars)
  # counter['s']           # => 4
  # counter['z']           # => 0
  # counter.most_common(2) # => [{'i', 4}, {'s', 4}]
  # ```
  class Counter(T)
    include Enumerable({T, Int64})

    def initialize
      @counts = {} of T => Int64
    end

    # Builds a counter by tallying the occurrences of each element.
    def initialize(elements : Enumerable(T))
      @counts = {} of T => Int64
      elements.each { |element| increment(element) }
    end

    # Returns the count for *key*, or `0` if it is absent.
    def [](key : T) : Int64
      @counts.fetch(key, 0_i64)
    end

    # Sets the count for *key* explicitly. Zero and negative counts are allowed.
    def []=(key : T, count : Int) : Int64
      @counts[key] = count.to_i64
    end

    # Adds *by* (default `1`) to *key*'s count and returns the new count. Counts
    # are stored as `Int64`, so large accumulated totals do not overflow.
    def increment(key : T, by : Int = 1) : Int64
      @counts[key] = self[key] + by.to_i64
    end

    # Increments *key* by one. Returns `self` so calls can be chained.
    def <<(key : T) : self
      increment(key)
      self
    end

    # Removes *key* entirely, returning its previous count (or `nil` if absent).
    def delete(key : T) : Int64?
      @counts.delete(key)
    end

    # Returns the sum of all counts.
    def total : Int64
      total = 0_i64
      @counts.each_value { |count| total += count }
      total
    end

    def size : Int32
      @counts.size
    end

    def empty? : Bool
      @counts.empty?
    end

    def keys : Array(T)
      @counts.keys
    end

    def values : Array(Int64)
      @counts.values
    end

    def to_h : Hash(T, Int64)
      @counts.dup
    end

    def each(& : {T, Int64} ->)
      @counts.each { |key, count| yield({key, count}) }
    end

    # Returns the *n* highest-count entries as `{key, count}` pairs, most common
    # first. With no argument, returns every entry sorted by count descending.
    # Ties between equal counts are returned in an unspecified order.
    def most_common(n : Int32? = nil) : Array({T, Int64})
      sorted = @counts.to_a.sort_by! { |(_, count)| -count }
      n ? sorted.first(n) : sorted
    end

    # Returns each key repeated by its count. Keys with a count of `0` or less
    # are skipped.
    def elements : Array(T)
      result = [] of T
      @counts.each do |key, count|
        count.times { result << key }
      end
      result
    end

    # Returns a new counter with the counts of both summed. Only keys with a
    # positive total are kept, matching Python's `Counter + Counter`.
    def +(other : Counter(T)) : Counter(T)
      merged = Counter(T).new
      each { |(key, count)| merged.increment(key, count) }
      other.each { |(key, count)| merged.increment(key, count) }
      merged.keep_positive!
    end

    # Returns a new counter with *other*'s counts subtracted. Only keys with a
    # positive result are kept, matching Python's `Counter - Counter`.
    def -(other : Counter(T)) : Counter(T)
      result = Counter(T).new
      each { |(key, count)| result.increment(key, count) }
      other.each { |(key, count)| result.increment(key, -count) }
      result.keep_positive!
    end

    # Compares the stored counts exactly. Note that an explicit zero count is
    # *not* treated as an absent key here.
    def ==(other : Counter(T)) : Bool
      @counts == other.to_h
    end

    protected def keep_positive! : self
      @counts.reject! { |_, count| count <= 0 }
      self
    end
  end
end
