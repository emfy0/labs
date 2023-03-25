require_relative 'relation'

class Graph
  class Vertex
    attr_accessor :value, :relations

    def initialize(v, r = [])
      @value = v
      @relations = r
    end

    def add_relation(to_vertex, weight:, orientation:)
      @relations << Relation.new(to_vertex, weight, orientation)
    end

    def ==(vertex)
      value == vertex.value && relations == vertex.relations
    end
  end
end
