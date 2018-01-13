require_relative '../lib/board' 
require_relative '../lib/player'
require_relative '../lib/engine'
 
describe Board do 
  subject(:board){described_class.new} 
  subject(:player){Player.new}
 
  describe '#initialize' do 
    it 'initialize with an empty array, @positions_with_values' do 
      expect(board.positions_with_values["1"]).to eq " "
      expect(board.positions_with_values["2"]).to eq " "
      expect(board.positions_with_values["3"]).to eq " "
      expect(board.positions_with_values["4"]).to eq " "
      expect(board.positions_with_values["5"]).to eq " "
      expect(board.positions_with_values["6"]).to eq " "
      expect(board.positions_with_values["7"]).to eq " "
      expect(board.positions_with_values["8"]).to eq " "
      expect(board.positions_with_values["9"]).to eq " "
    end 
  end 

  describe '#display_positions' do
    it 'check if array has been properly initialized' do
      expect{board.display_positions}.to output("\n 1 | 2 | 3 \n-----------\n 4 | 5 | 6 \n-----------\n 7 | 8 | 9 \n\n").to_stdout
    end
  end

  describe '#display' do
    it 'check if field is empty' do
      expect(board.positions_with_values["1"]).to eq " "
    end
  end
end 
