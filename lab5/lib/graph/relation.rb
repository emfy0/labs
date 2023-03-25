class Graph
  class Relation
    attr_reader :to, :weight, :orientation

    def initialize(to, weight, orientation)
      # :fb - forward backward, :f - forward, :b - backward
      @to, @weight, @orientation = to, weight, orientation
    end

    def ==(rel)
      rel.to == @to && rel.weight == @weight && rel.orientation == @orientation
    end
  end
end

