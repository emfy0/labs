class Btree::Tree
  attr_reader :root, :degree, :size

  def initialize(degree = 2)
    @degree = degree
    @root = Btree::Node.new(@degree)
    @size = 0
  end

  def insert(key, value = nil)
    node = @root
    if node.full?
      @root = Btree::Node.new(@degree)
      @root.add_child(node)
      @root.split(@root.children.size - 1)
      # puts "After split, root = #{@root.inspect}"
      # split child(@root, 1)
      node = @root
    end
    node.insert(key, value)
    @size += 1
    self
  end

  def dump
    @root.dump
  end

  def value_of(key)
    @root.value_of(key)
  end

  alias [] value_of
  alias []= insert
end
