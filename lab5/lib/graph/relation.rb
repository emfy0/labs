class Graph
  class Relation
    attr_reader :to, :weight

    def initialize(to, weight)
      # :fb - forward backward, :f - forward, :b - backward
      @to, @weight = to, weight
    end

    def ==(rel)
      rel.to == @to && rel.weight == @weight
    end
  end
end

