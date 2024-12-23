module Collections
  class Node(T)
    property value : T
    property neighbors : Array(Node(T))

    def initialize(@value : T)
      @neighbors = [] of Node(T)
    end

    def ==(other : Node(T))
      value == other.value
    end

    def hash()
      value.hash
    end
  end
end