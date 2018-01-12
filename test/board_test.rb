require_relative '../lib/board' 
 
	describe Board do 
	  subject(:board){described_class.new} 
	 
	  describe '#initialize' do 
	    it 'initialize with an array, @positions_with_values' do 
	      expect(board.positions_with_values).to be_a(array) 
    	end 
  end 
end 
