# Disjoint Set (Union-Find) data structure for efficient group merging and lookup
class DisjointSet
  def initialize(n)
    @parent = (0...n).to_a  # Initialize parent array: each element is its own root
  end

  # Find the root of the set containing x with path compression
  def find(x)
    @parent[x] = find(@parent[x]) while x != @parent[x]  # Path compression
    @parent[x]
  end

  # Merge two sets containing x and y
  def union(x, y)
    @parent[find(y)] = find(x) if find(x) != find(y)  # Union the sets
  end
end
