require_relative 'relation'

class Graph
  class Vertex
    attr_accessor :value, :relations

    def initialize(v, r = [])
      @value = v
      @relations = r
    end

    def add_relation(to_vertex, weight:)
      @relations << Relation.new(to_vertex, weight)
    end

    def ==(other)
      value == other.value && relations == other.relations
    end
  end
end
