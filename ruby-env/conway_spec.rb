# frozen_string_literal: true
require 'rspec'

require 'ruby/cellular-automaton/conways_game_of_life'

describe GameOfLife do
  describe '.from_str' do
    subject(:game) { described_class.from_str(input_string) }
    
    context 'with an X of living cells shape in a 3x3' do
      let(:input_string) do
        <<~GAME_GRID
          0·0
          ·0·
          0·0
        GAME_GRID
      end
      let(:expected_grid) do
        dead = be_an_instance_of(Dead)
        live = be_an_instance_of(Live)
        [
          [live, dead, live],
          [dead, live, dead],
          [live, dead, live]
        ]
      end

      it { is_expected.to be_an_instance_of(described_class) }

      it 'has a matching grid' do
        expect(game.grid).to match expected_grid
      end
    end
  end

  describe '#next_generation' do
    let(:gen_one) do
      <<~GEN_ONE.strip
        ·0·
        0·0
      GEN_ONE
    end
    let(:gen_two) do
      <<~GEN_TWO.strip
        ·0·
        ·0·
      GEN_TWO
    end
    let(:gen_three) do
      <<~GEN_THREE.strip
        ···
        ···
      GEN_THREE
    end
    it 'works' do
      gen_two_game = described_class.from_str(gen_one).next_generation
      expect(gen_two_game.to_s).to eq gen_two
      gen_three_game = gen_two_game.next_generation
      expect(gen_three_game.to_s).to eq gen_three
    end
  end
end

describe Dead do
  describe '#next_state' do
    subject(:next_state) { described_class.new.next_state(neighbor_count) }

    context 'when there is under population' do
      context 'zero live neighbors' do
        let(:neighbor_count) { 0 }
        it { is_expected.to be_an_instance_of(Dead) }
      end

      context 'one or two live neighbors' do
        let(:neighbor_count) { [1, 2].sample }
        it { is_expected.to be_an_instance_of(Dead) }
      end
    end

    context 'when there is reproduction' do
      let(:neighbor_count) { 3 }
      it { is_expected.to be_an_instance_of(Live) }
    end

    context 'when there is overpopulation' do
      let(:neighbor_count) { (4..8).to_a.sample }
      it { is_expected.to be_an_instance_of(Dead) }
    end
  end
end

describe Live do
  describe '#next_state' do
    subject(:next_state) { described_class.new.next_state(neighbor_count) }

    context 'when there is under population' do
      let(:neighbor_count) { [0, 1].sample }
      it { is_expected.to be_an_instance_of(Dead) }
    end

    context 'when there is a stable population' do
      let(:neighbor_count) { [2, 3].sample }
      it { is_expected.to be_an_instance_of(Live) }
    end

    context 'when there is overpopulation' do
      let(:neighbor_count) { (4..8).to_a.sample }
      it { is_expected.to be_an_instance_of(Dead
        ) }
    end
  end
end

describe 'Glider example' do
  it 'works' do
    expect { glider_example }.not_to raise_error
  end
end