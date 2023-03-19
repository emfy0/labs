require 'hash_map'

RSpec.describe HashMap do
  subject { described_class.new }

  context '#initialize' do
    it 'sets instance variables' do
      expect(subject.size).to eq 0
      expect(subject.max_capacity_level).to eq 2.0
      expect(subject.cassettes_size).to eq described_class::DEFAULT_CASSETTES_SIZE
    end
  end

  context '#insert/get' do
    before do
      5.times { |n| subject[n] = n + 1 }
    end

    it 'inserts values correctly' do
      5.times { |n| expect(subject[n]).to eq (n + 1) }
    end

    it 'returns nil if value was not found' do
      expect(subject['no such value']).to be_nil
    end

    it 'calculates capacity level' do
      expect(subject.current_capacity_level).to eq 0.5
    end

    it 'reads size correctly' do
      expect(subject.size).to eq 5
    end
  end

  context '#delete' do
    before do
      30.times { |n| subject[n] = n + 1 }
      subject.delete(20)
      subject.delete(21)
    end

    it 'deletes elements' do
      expect(subject.size).to eq 28
      expect(subject[20]).to be_nil
      expect(subject[21]).to be_nil
    end
  end

  context 'works correctly with dublicates' do
    let(:a) { 'asd' }
    let(:b) { 'dsa' }

    before do
      allow(a).to receive(:hash).and_return (1)
      allow(b).to receive(:hash).and_return (1)

      subject[a] = 'test1'
      subject[b] = 'test2'
    end

    it 'reads values correctly' do
      expect(subject[a]).to eq 'test1'
      expect(subject[b]).to eq 'test2'
    end
  end

  context 'rebuild hash' do
    before do
      100.times { |n| subject[n] = n + 1 }
    end

    it 'rebuilds correctly' do
      100.times { |n| expect(subject[n]).to eq (n + 1) }
    end
  end

  context '#delete' do
    
  end
end
