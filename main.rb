require 'gosu'
require_relative "word"
require_relative "z_order"
require_relative "compound_word"
require_relative "document_parser"

class GameWindow < Gosu::Window
  WIDTH = 1200
  HEIGHT= 500
  def initialize
    super WIDTH, HEIGHT
    self.caption = "TYPESPEED"
    @background_image = Gosu::Image.new("media/background.jpeg", :tileable => true)
    @font = Gosu::Font.new(20)
    @bigfont= Gosu::Font.new(40)
    @biggestfont = Gosu::Font.new(100)
    #data = determine_words_database()
    @words_on_screen = []
    @words = determine_words_database()
    @health = 100
    @score = 0 
    @time = Gosu::milliseconds
    @beep = Gosu::Sample.new("media/beep.wav")
    @explosion_sound = Gosu::Sample.new("media/explosion.wav")
    self.text_input =Gosu::TextInput.new
  end

  def determine_words_database
    puts "Would you like to use your own words database (y/n)?"
    answer = gets.chomp
    #any answer that contains y,Y and doesn't contain n,N will work
    if answer =~ /y/i && !(answer =~ /n/i)
      puts "Please specify name of the file in the main game folder"
      file_name = gets.chomp
      return parse_file_type(file_name)
    #any answer that contains n,N and doesn't contain y,Y will work
    elsif answer =~ /n/i && !(answer =~ /y/i) 
      default_words_list = DocumentParser.new
      return default_words_list.parse
    else
      puts "We couldn't determine the answer with the input you gave. Please try again!"
      determine_words_database()
    end
  end

  def parse_file_type(file_name)
    split_file_name = file_name.split(".")
    case split_file_name[-1]
    when "txt"
      table_to_return = DocumentParser.new "#{file_name}", TxtDocumentParser
      return table_to_return.parse
    when "docx"
      table_to_return = DocumentParser.new "#{file_name}", DocxDocumentParser
      return table_to_return.parse
    else
      puts "Unsupported filetype given, try txt or docx"
      determine_words_database()
    end
  end

  def update
    check_words_at_bottom
    move_words
    check_time
    check_health
    compare_user_input_to_word
  end
  
  def draw
    @background_image.draw(0, 0, 0)
    @bigfont.draw("TYPESPEED", 10, 10, ZOrder::UI, 1.0, 1.0, 0xff_00ffff )
    @font.draw("Score: #{@score}", 10, 50, ZOrder::UI, 1.0, 1.0, 0xff_ffffff)
	  @font.draw("Health: #{@health}",10, 70, ZOrder::UI, 1.0, 1.0, 0xff_ffffff)
    @words_on_screen.each {|word| word.draw}
    if @health <= 0
      @biggestfont.draw("GAME OVER", 300, 150, ZOrder::UI, 1.0, 1.0, 0xff_ff0000)
      @biggestfont.draw("Final Score : #{@score}", 300, 300, ZOrder::UI, 1.0, 1.0, 0xff_ff0000 )
    end
  end
  
  def button_down(id)
     if id == Gosu::KbReturn && @health <= 0 #Restart function 
	    initialize
	  elsif id == Gosu::KbEscape
	  	close
     end
  end

  

  private
    def move_words
      @words_on_screen.each { |word|
       word.move
      }
    end
    def check_words_at_bottom
      @words_on_screen.each { |word|
      if word.explode_drawn?
        @explosion_sound.play
         @health -= 10
        @words_on_screen.delete(word)
      end
      }
    end
    def check_time
      if (Gosu::milliseconds - @time) >= 60000 #once time is greater than a minute then game gets harder
        if (Gosu::milliseconds - @time) % 6000 <= self.update_interval #adds a compound and normal word every 6 seconds
            @words_on_screen.push(Word.new(@words[(rand(@words.length-1)).to_i]))
            @words_on_screen.push(CompoundWord.new(@words[(rand(@words.length-1)).to_i] + @words[(rand(@words.length-1)).to_i]))
         elsif (Gosu::milliseconds - @time) % 3000 <= self.update_interval #adds a normal word every 3 seconds
            @words_on_screen.push(Word.new(@words[(rand(@words.length-1)).to_i]))
        end    
      elsif (Gosu::milliseconds - @time) % 3000 <= self.update_interval # under a minute, only add 1 normal word every 3 seconds
            @words_on_screen.push(Word.new(@words[(rand(@words.length-1)).to_i]))
      end      
    end
    def check_health
      if @health <= 0
        @words_on_screen.clear
      end
    end
    def compare_user_input_to_word
      if Gosu::button_down? Gosu::KbReturn #once enter is pressed, the text input is compared to words on the screen
         @words_on_screen.each { |word|
          if self.text_input.text.eql? word.string 
           @score += word.points
           @beep.play
           @words_on_screen.delete(word)  
         end
         } 
        self.text_input = nil 
        self.text_input =Gosu::TextInput.new #reseting the user input after they press enter for next typed word
      end  
    end

end


window = GameWindow.new
window.show
