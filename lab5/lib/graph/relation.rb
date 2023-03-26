class Graph
  class Relation
    attr_reader :to, :weight

    def initialize(to, weight)
      # :fb - forward backward, :f - forward, :b - backward
      @to = to
      @weight = weight
    end

    def ==(other)
      other.to == @to && other.weight == @weight
    end
  end
end
