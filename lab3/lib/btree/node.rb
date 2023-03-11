class Btree::Node
  def initialize(degree)
    @degree = degree
    @keys = []
    @children = []
  end

  def dump(level = 0)
    @keys.each_with_index do |key, idx|
      puts "LEVEL: #{level} => #{key.first}: full? #{full?} leaf? #{leaf?} children: #{values.inspect}"
      @children[idx].dump(level + 1) if @children[idx]
    end
    (@children[@keys.size..-1] || []).each do |c|
      c.dump(level + 1)
    end
    nil
  end

  def add_child(node)
    @children << node
  end

  def children
    @children.dup.freeze
  end

  def keys
    @keys.map(&:first).freeze
  end

  def values
    @keys.map(&:last).freeze
  end

  def full?
    size >= 2 * @degree - 1
  end

  def leaf?
    @children.length == 0
  end

  def size
    @keys.size
  end

  def values_of(range)
    result = []

    i = 1
    while i <= size && range.end >= @keys[i - 1].first
      if range.cover? @keys[i - 1].first
        result << @keys[i - 1].last
        child = @children[i - 1].values_of(range) unless leaf?
        result += child if child
      end
      i += 1
    end

    result
  end

  def value_of(key)
    return values_of(key) if key.is_a? Range

    i = 1
    i += 1 while i <= size && key > @keys[i - 1].first

    # puts "Getting value of key #{key}, i = #{i}, keys = #{@keys.inspect}, leaf? #{leaf?}, numchildren: #{@children.size}"

    if i <= size && key == @keys[i - 1].first
      # puts "Found key: #{key.inspect}"
      @keys[i - 1].last
    elsif leaf?
      # puts "We are a leaf, no more children, so val is nil"
      nil
    else
      # puts "Looking into child #{i}"
      @children[i - 1].value_of(key)
    end
  end

  def insert(key, value)
    i = size - 1
    # puts "INSERTING #{key} INTO NODE: #{self.inspect}"
    if leaf?
      raise 'Duplicate key' if @keys.any? { |(k, _v)| k == key } # OPTIMIZE: This is inefficient

      while i >= 0 && @keys[i] && key < @keys[i].first
        @keys[i + 1] = @keys[i]
        i -= 1
      end
      @keys[i + 1] = [key, value]
    else
      i -= 1 while i >= 0 && @keys[i] && key < @keys[i].first
      # puts "   -- INSERT KEY INDEX #{i}"
      if @children[i + 1] && @children[i + 1].full?
        split(i + 1)
        i += 1 if key > @keys[i + 1].first
      end
      @children[i + 1].insert(key, value)
    end
  end

  def split(child_idx)
    if child_idx < 0 || child_idx >= @children.size
      raise "Invalid child index #{child_idx} in split, num_children = #{@children.size}"
    end

    # puts "SPLIT1: #{self.inspect}"
    splitee = @children[child_idx]
    y = Btree::Node.new(@degree)
    z = Btree::Node.new(@degree)
    (@degree - 1).times do |j|
      z._keys[j] = splitee._keys[j + @degree]
      y._keys[j] = splitee._keys[j]
    end
    unless splitee.leaf?
      @degree.times do |j|
        z._children[j] = splitee._children[j + @degree]
        y._children[j] = splitee._children[j]
      end
    end
    mid_val = splitee._keys[@degree - 1]
    # puts "SPLIT2: #{self.inspect}"
    @keys.size.downto(child_idx) do |j|
      @children[j + 1] = @children[j]
    end

    @children[child_idx + 1] = z
    @children[child_idx] = y

    # puts "SPLIT3: #{self.inspect}"

    (@keys.size - 1).downto(child_idx) do |j|
      @keys[j + 1] = @keys[j]
    end

    # puts "SPLIT4: #{self.inspect}"

    @keys[child_idx] = mid_val
    # puts "SPLIT5: #{self.inspect}"
  end

  protected

  def _keys
    @keys
  end

  def _children
    @children
  end
end
