require 'graph'

RSpec.describe Graph do
  it 'defines graph' do
    graph = Graph.define do
      head = set_head(v(1))

      head | v(2, 3) | v(3, 5)
      head | v(4, 2) | v(5, 4)
    end

    head = graph.head

    last1 = Graph::Relation.new Graph::Vertex.new(3), 5
    last2 = Graph::Relation.new Graph::Vertex.new(5), 4

    first1 = Graph::Relation.new Graph::Vertex.new(2, [last1]), 3
    first2 = Graph::Relation.new Graph::Vertex.new(4, [last2]), 2

    head_t = Graph::Vertex.new(1, [first1, first2])

    expect(head).to eq head_t
  end

  it '#dsf' do
    graph = Graph.define do
      head = set_head(v(1))

      v1 = v(2)

      head | v1
      v1 | v(3) | v(5) | v(7)
      v1 | v(4) | v(8)
      v1 | v(6) | v1
      v1 | v1
    end

    expect(graph.dsf).to eq [1, 2, 3, 5, 7, 4, 8, 6]

    graph.set_head(2)
    expect(graph.dsf).to eq [2, 3, 5, 7, 1, 6, 4, 8]
  end

  it '#bfc' do
    graph = Graph.define do
      head = set_head(v(1))

      v1 = v(2)

      head | v1
      v1 | v(3) | v(5) | v(7)
      v1 | v(4) | v(8)
      v1 | v(6) | v1
      v1 | v1
    end

    expect(graph.bfc).to eq [1, 2, 3, 4, 6, 5, 8, 7]

    graph.set_head(2)
    expect(graph.bfc).to eq [2, 1, 6, 3, 4, 5, 8, 7]
  end

  it '#dijkstra' do
    graph = Graph.define do
      head = set_head(v(1))

      v1 = v(2, 5)

      head | v1
      v1 | v(3, 2) | v(5, 3) | v(7)
      v1 | v(4) | v(8)
      v1 | v(6) | v1
      v1 | v(5, 4)
    end

    expect(graph.dijkstra).to eq({
      1 => 0, 2 => 5, 3 => 7, 5 => 9, 7 => 11, 4 => 6, 8 => 7, 6 => 6
    })
  end
end
