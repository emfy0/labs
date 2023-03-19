class HashMap
  class Node
    attr_reader :k, :v

    def initialize(k, v)
      @k, @v = k, v
    end
  end
end
