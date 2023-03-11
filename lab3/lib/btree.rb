module Btree
  def self.create(degree)
    raise 'Degree of Btree must be >= 2' if degree < 2

    Btree::Tree.new(degree)
  end
end

require_relative 'btree/tree'
require_relative 'btree/node'
