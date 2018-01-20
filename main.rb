require 'gosu'
require_relative "word"
require_relative "z_order"
require_relative "compound_word"
require_relative "document_parser"

#main class
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
    #answer y,Y will work
    if answer == "y" || answer == "Y"
      determine_db
    #answer n,N will work
    elsif answer == "n" || answer == "N"
      default_db
    else
      wrong_answer
    end
  end

  def determine_db
    puts "Please specify name of the file in the main game folder"
    file_name = gets.chomp
    return parse_file_type(file_name)
  end

  def default_db
    default_words_list = DocumentParser.new
    return default_words_list.parse
  end

  def wrong_answer
    puts "We couldn't determine the answer with the input you gave. Please try again!"
    determine_words_database()
  end

  def parse_file_type(file_name)
    split_file_name = file_name.split(".")
    case split_file_name[-1]
    when "txt"
      determine_file_type(file_name, TxtDocumentParser)
    when "docx"
      determine_file_type(file_name,DocxDocumentParser)
    else
      wrong_file_type
    end
  end

  def wrong_file_type
    puts "Unsupported filetype given, try txt or docx"
    determine_words_database()
  end

  def determine_file_type(file_name,file_type)
    table_to_return = DocumentParser.new "#{file_name}", file_type
    return table_to_return.parse
  end

  def update
    check_words_at_bottom
    move_words
    check_time
    check_health
    compare_user_input_to_word
  end
  
  def draw
    draw_main_screen
    @words_on_screen.each {|word| word.draw}
    draw_explosion_word
  end

  def draw_main_screen
    @background_image.draw(0, 0, 0)
    @bigfont.draw("TYPESPEED", 10, 10, ZOrder::UI, 1.0, 1.0, 0xff_00ffff )
    @font.draw("Score: #{@score}", 10, 50, ZOrder::UI, 1.0, 1.0, 0xff_ffffff)
    @font.draw("Health: #{@health}",10, 70, ZOrder::UI, 1.0, 1.0, 0xff_ffffff) 
  end

  def draw_explosion_word
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
      lets_rand = @words[rand(@words.length-1).to_i] 
      random_word = Word.new(lets_rand)
      random_compound_word = CompoundWord.new(lets_rand + lets_rand)
      total_time = Gosu::milliseconds - @time
      time_conditions(total_time,random_word,random_compound_word)   
    end

    def time_conditions(total_time,random_word,random_compound_word)
      update_interval = self.update_interval
      if total_time >= 60000 #once time is greater than a minute then game gets harder
        if total_time % 6000 <= update_interval #adds a compound and normal word every 6 seconds
            @words_on_screen.push(random_word)
            @words_on_screen.push(random_compound_word)
         elsif total_time % 3000 <= update_interval #adds a normal word every 3 seconds
            @words_on_screen.push(random_word)
        end    
      elsif total_time % 3000 <= update_interval # under a minute, only add 1 normal word every 3 seconds
            @words_on_screen.push(random_word)
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