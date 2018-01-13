require_relative '../lib/board'
require_relative '../lib/player'
require_relative '../lib/engine'

describe Engine do
  subject(:engine){described_class.new}
  subject(:board){Board.new}

  describe '#start' do
    it 'checks if player goes first' do
      @ans = 'y'
      expect(@current_player).to eq(@x_player)
    end

    it 'checks if player goes second' do
      @ans = 'n'
      expect(@current_player).to eq(@o_player)
    end
  end

  describe '#check_winner' do
    it 'checks if X wins' do
      board.positions_with_values["1"] = "X"
      board.positions_with_values["2"] = "X"
      board.positions_with_values["3"] = "X"
      engine.check_winner(board)
      expect(board.positions_with_values["1"]).to eq("X")
    end
  end
end

