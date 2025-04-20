class DisjointSet
    def initialize(n)
      @parent = Array.new(n) { |i| i }
    end
  
    def find(x)
      @parent[x] = find(@parent[x]) if x != @parent[x]
      @parent[x]
    end
  
    def union(x, y)
      xroot = find(x)
      yroot = find(y)
      @parent[yroot] = xroot if xroot != yroot
    end
  end