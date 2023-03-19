require_relative 'hash_map/node'

class HashMap
  attr_reader :size, :cassettes_size, :max_capacity_level

  DEFAULT_CASSETTES_SIZE = 10

  def initialize(max_capacity_level = 2.0)
    @cassettes = Array.new(DEFAULT_CASSETTES_SIZE, [])

    @max_capacity_level = max_capacity_level
    @cassettes_size = DEFAULT_CASSETTES_SIZE
    @size = 0
  end

  def insert(k, v)
    calculated_level = calculate_new_capasity_level_for incoming_nodes_size: 1

    rebuild_for(new_size: @cassettes_size * 2 + 1) if calculated_level > max_capacity_level
    insert_into_cassettes(k, v, true)
  end
  alias []= insert

  def get(k)
    find_cassette(k).find { |node| node.k == k }&.v
  end
  alias [] get

  def delete(k)
    return if size <= 0

    find_cassette(k).delete_if { |node| node.k == k }
    @size -= 1
  end

  def current_capacity_level = calculate_new_capasity_level_for(incoming_nodes_size: 0)

  private

  attr_accessor :cassettes

  def rebuild_for(new_size:)
    @cassettes_size = new_size

    old_cassettes = cassettes
    @cassettes = Array.new(new_size, [])

    old_cassettes.each do |cassette|
      cassette.each { |node| insert_into_cassettes(node.k, node.v) }
    end
  end

  def insert_into_cassettes(k, v, increase_length = false)
    @size += 1 if increase_length
    find_cassette(k) << Node.new(k, v)
    v
  end

  def find_node(k)
    find_cassette(k).find { |node| node.k == k }
  end

  def find_cassette(k)
    cassettes[calculate_index_from_hash(k)]
  end

  def calculate_new_capasity_level_for(incoming_nodes_size:)
    (size + incoming_nodes_size) / cassettes_size.to_f
  end

  def calculate_index_from_hash(obj)
    obj.hash % @cassettes_size
  end
end
