require_relative '../lib/board' 
 
describe Board do 
  subject(:board){described_class.new} 
 
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
end 
