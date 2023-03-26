require_relative 'graph/definition_context'

class Graph
  def self.define(&block)
    definition = DefinitionContext.new.tap { |d| d.instance_exec(&block) }

    new(definition._head.vertex, definition.vertexes)
  end

  attr_reader :vertexes, :head

  def initialize(head, vertexes)
    @head = head
    @vertexes = vertexes
    @visited_values = []
    @queue = []
  end

  def set_head(v)
    @head = vertexes.find { |vertex| vertex.value == v }
  end

  def dsf
    bfc_dsf :dsf
  end

  def bfc
    bfc_dsf :bfc
  end

  def dijkstra
    clear
    @key_weight = {}

    @key_weight[head] = 0
    do_dijkstra(head)

    @key_weight.transform_keys(&:value)
  end

  private

  def clear
    add_to_queue(nil, reset: true)
    visit_value(nil, reset: true)
  end

  def do_dijkstra(vertex)
    return unless visit_value(vertex.value)

    vertex.relations.each do |relation|
      sum = @key_weight[vertex] + relation.weight
      @key_weight[relation.to] = sum if !@key_weight.key?(relation.to) || sum < @key_weight[relation.to]
      do_dijkstra(relation.to)
    end
  end

  def bfc_dsf(alg)
    clear

    add_to_queue vertexes.find_all { |v| v.relations.any? { |r| r.to == head } }
    send :"do_#{alg}", head

    send :"do_#{alg}", @queue.shift until @queue.empty?

    @visited_values
  end

  def do_bfc(vertex)
    return unless visit_value(vertex.value)

    relations = vertex.relations
    add_to_queue relations.filter.map(&:to) if relations.any?

    first = @queue.shift
    do_bfc(first) if first
  end

  def do_dsf(vertex)
    return unless visit_value(vertex.value)

    first_relation = vertex.relations.first

    return if first_relation.nil?

    slice = vertex.relations[1..]
    add_to_queue slice.map!(&:to) unless slice.nil?

    do_dsf(first_relation.to)
  end

  def visit_value(value, reset: false)
    return(@visited_values = []) if reset

    if @visited_values.include?(value)
      false
    else
      @queue.delete_if { |v| v.value == value }
      @visited_values << value
      true
    end
  end

  def add_to_queue(vertex, reset: false)
    return(@queue = []) if reset

    @queue += vertex
  end
end
