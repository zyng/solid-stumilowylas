require_relative "word"
#CompoundWord class
class CompoundWord < Word 
	
	attr_reader :position_y, :points, :vel

	def initialize(string)
		@position_y=position_y
		@vel=vel
		@points=points
		super(string)
		@color = Gosu::Color.new(0xff_00ff00)
		@points = 20 
	end

	def move
		@vel = @vel + 0.5 * rand(0.05..0.07)#This is the acceleration
		@yposition_y += @position_y * 0.25
	end
	
end