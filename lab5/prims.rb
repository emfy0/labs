# Prim's Minimum Spanning Tree Algorithm - Naive version

def file
  @file ||= File.readlines('edges.txt')
end

def header
  @header ||= file.take(1)[0]
end

def number_of_nodes
  @number_of_nodes ||= header.split(' ')[0].to_i
end

def create_adjacency_matrix
  adjacency_matrix = [].tap { |m| number_of_nodes.times { m << Array.new(number_of_nodes) } }
  file.drop(1).map { |x| x.gsub(/\n/, '').split(' ').map(&:to_i) }.each do |(node1, node2, weight)|
    adjacency_matrix[node1 - 1][node2 - 1] = weight
    adjacency_matrix[node2 - 1][node1 - 1] = weight
  end
  adjacency_matrix
end

def find_cheapest_edge(adjacency_matrix, nodes_spanned_so_far, number_of_nodes)
  available_nodes = (0..number_of_nodes - 1).to_a.reject { |node_index| nodes_spanned_so_far.include?(node_index + 1) }

  cheapest_edges = available_nodes.each_with_object([]) do |node_index, acc|
    get_edges(adjacency_matrix, node_index).select do |_, other_node_index|
      nodes_spanned_so_far.include?(other_node_index + 1)
    end.each do |weight, other_node_index|
      acc << { start: node_index + 1, end: other_node_index + 1, weight: weight }
    end
  end

  cheapest_edges.sort { |x, y| x[:weight] <=> y[:weight] }.first
end

def get_edges(adjacency_matrix, node_index)
  adjacency_matrix[node_index].each_with_index.reject { |edge, _index| edge.nil? }
end

def select_first_edge(adjacency_matrix)
  starting_node = 1
  cheapest_edges = get_edges(adjacency_matrix, 0).each_with_object([]) do |(edge, index), all_edges|
    all_edges << { start: starting_node, end: index + 1, weight: edge }
  end
  cheapest_edges.sort { |x, y| x[:weight] <=> y[:weight] }.first
end

def nodes_left_to_cover
  (1..number_of_nodes).to_a - @nodes_spanned_so_far
end

# Prim's algorithm

adjacency_matrix = create_adjacency_matrix
first_edge = select_first_edge(adjacency_matrix)
@nodes_spanned_so_far = [first_edge[:start], first_edge[:end]]
@edges = [first_edge]

until nodes_left_to_cover.empty?
  cheapest_edge = find_cheapest_edge(adjacency_matrix, @nodes_spanned_so_far, number_of_nodes)
  @edges << cheapest_edge
  @nodes_spanned_so_far << cheapest_edge[:start]
end

puts "edges: #{@edges}, total spanning tree cost #{@edges.inject(0) { |acc, edge| acc + edge[:weight] }}"
