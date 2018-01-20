#class word
class Word
	
	#attr_accessor :x, :y , :points, :string

	def position_x
 		@position_x
 	end

 	def position_x=(position_x)
    	@position_x = position_x
    end

    def position_y
 		@position_y
 	end

 	def position_y=(position_y)
    	@position_y = position_y
    end

    def points
 		@points
 	end

 	def points=(points)
    	@points = points
    end
	
	 def string
 		@string
 	end

 	def string=(str)
    	@string = str
    end

	def initialize(string)
		@string = string 
		@color = Gosu::Color.new(0xff_00ffff)
		@position_x = rand(225..1000)
		@position_y = 0.00
		@vel = rand(0.20..1.00)
		@explosion = Gosu::Image.new("media/explosion.png")
		@exploded = false
		@explosion_drawn = false
		@font = Gosu::Font.new(24)
		@points = 10
	end

	def move
		@position_y = @position_y + @vel 
	end
	
	def draw
		 if self.is_at_bottom? == true
		 	@explosion_drawn = true 	
		 	@explosion.draw(@position_x - @explosion.width / 2.0, @position_y - @explosion.height/2.0, 
			 ZOrder::Words, 1, 1)	
		else
			@font.draw(@string, @position_x, @position_y, ZOrder::Words, 1.0, 1.0, @color )
		end
	end
 
	def is_at_bottom?
		if @position_y <= GameWindow::HEIGHT && @position_y >= 475.0
			@exploded = true
			return @exploded
		else
			 @exploded = false
			 return @exploded
		end
	end
	
	def explode_drawn?
		return @explosion_drawn
	end

end