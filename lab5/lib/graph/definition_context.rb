require_relative 'vertex'

class Graph
  class DefinitionContext
    class Wrapper
      attr_reader :weight, :vertex

      def initialize(v, w, vertexes)
        vert = vertexes.find { |vert| vert.value == v }

        @weight = w
        @vertex =
          if vert
            vert
          else
            vert = Vertex.new(v)
            vertexes << vert
            vert
          end
      end

      def >>(to_vertex_with_weight)
        @vertex.add_relation(to_vertex_with_weight.vertex, weight: to_vertex_with_weight.weight, orientation: :f)
        to_vertex_with_weight
      end

      def <<(to_vertex_with_weight)
        @vertex.add_relation(to_vertex_with_weight.vertex, weight: to_vertex_with_weight.weight, orientation: :b)
        to_vertex_with_weight
      end

      def |(to_vertex_with_weight)
        @vertex.add_relation(to_vertex_with_weight.vertex, weight: to_vertex_with_weight.weight, orientation: :fb)
        to_vertex_with_weight
      end
    end

    attr_reader :vertexes

    def initialize
      @vertexes = []
    end

    def v(v, w = 1)
      wrapper = Wrapper.new(v, w, @vertexes)
    end

    def set_head(v)
     @head = v
    end

    def _head = @head
  end
end
