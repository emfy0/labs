require_relative 'spec_helper'
require 'btree'

RSpec.describe Btree do
  it 'creates btree' do
    t = Btree.create(5)
    t.insert(5, '5')
    expect(t.root.size).to eq 1
    expect(!t.root.full?).to eq true
    expect(t.degree).to eq 5
    expect(t.size).to eq 1
  end

  it 'raises when btree size is to small' do
    expect { Btree.create(1) }.to raise_error RuntimeError
  end

  it 'doesnt allow to insert a dublicates' do
    t = Btree.create(2)
    t.insert(1, '1')
    expect { t.insert(1, '1') }.to raise_error RuntimeError
  end

  it 'inserts values correctly' do
    t = Btree.create(2)
    45.times do |i|
      t.insert i, i * i
    end

    expect(t.size).to eq 45
    45.times do |i|
      expect(t.value_of(i)).to eq i * i
    end
  end

  it 'takes values correctly' do
    t = Btree.create(5)
    t.insert(1, 'foo')
    t.insert(5, 'bar')
    t.insert(7, 'baz')
    t.insert(3, 'findme')
    expect(t.value_of(3)).to eq 'findme'
    expect(t.value_of(7)).to eq 'baz'
    expect(t.value_of(5)).to eq 'bar'
    expect(t.value_of(1)).to eq 'foo'
    expect(t.value_of(11)).to eq nil
    expect(t.size).to eq 4
    expect(t.value_of(3..6)).to eq %w[findme bar]
  end

  it 'fills root correctly' do
    t = Btree.create(2)
    3.times { |n| t.insert(n, n.to_s) }

    expect(t.root.full?).to eq true
    expect(t.root.keys).to eq [0, 1, 2]
    expect(t.root.values).to eq %w[0 1 2]
    expect(t.size).to eq 3
  end

  context 'full root' do
    before do
      @t = Btree.create(2)

      3.times { |n| @t.insert(n * 2, n.to_s) }
    end

    it 'is able to insert at end' do
      @t.insert(10, '10')
      expect(@t.value_of(10)).to eq '10'
      expect(@t.value_of(0)).to eq '0'
      expect(@t.value_of(2)).to eq '1'
      expect(@t.value_of(4)).to eq '2'
      expect(@t.size).to eq 4
    end

    it 'is able to insert at front' do
      @t.insert(-1, '10')
      expect(@t.value_of(-1)).to eq '10'
      expect(@t.value_of(0)).to eq '0'
      expect(@t.value_of(2)).to eq '1'
      expect(@t.value_of(4)).to eq '2'
      expect(@t.size).to eq 4
    end

    it 'is able to insert in the middle' do
      @t.insert(3, '10')
      expect(@t.value_of(3)).to eq '10'
      expect(@t.value_of(0)).to eq '0'
      expect(@t.value_of(2)).to eq '1'
      expect(@t.value_of(4)).to eq '2'
      expect(@t.size).to eq 4
    end

    context 'full last child' do
      before do
        2.times { |n| @t.insert(n * 2 + 10, 'foo') }
      end

      it 'have full last child' do
        expect(@t.root.children.last.full?).to eq true
        expect(@t.size).to eq 5
      end

      it 'is able to add to end' do
        @t.insert(100, 'YEAH!')
        expect(@t.value_of(100)).to eq 'YEAH!'
        expect(@t.size).to eq 6
      end

      it 'is able to insert many' do
        10.times { |n| @t.insert((n + 1) * 100, 'YEAH!') }
        expect(@t.value_of(100)).to eq 'YEAH!'
        expect(@t.size).to eq 15
      end
    end

    context 'second split of root' do
      before do
        6.times { |n| @t.insert(n * 2 + 10, 'foo') }
      end

      it 'works' do
        expect(@t.value_of(10)).to eq 'foo'
        expect(@t.size).to eq 9
      end
    end
  end
end
