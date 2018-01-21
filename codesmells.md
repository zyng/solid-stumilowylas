## Opis
Usunięto z pierwotnej wersji programu 32 z 45 „code smells”. Po wstępnym zapoznaniu się z ostrzeżeniami pokazywanymi przez gem Reek, postanowiono rozpocząć ich usuwanie od pliku word.rb. W tym pliku znajdowało się początkowo 8 ostrzeżeń:

## ```word.rb```
![word.rb](https://i.imgur.com/PMaJVXI.png)

### Attribute
Ostrzeżenie to pojawia się w momencie, gdy użyto ```attr_accessor``` na początku klasy. Używany jako getter oraz seter. Rozwiązaniem pozwalającym pozbyć się niechcianego „zapachu” jest rozbicie go na metody. Poniżej przedstawiono dokładny przebieg usuwania tego ostrzeżenia. Analogicznie postąpiono z pozostałymi atrybutami.
Przed:
```ruby
class Word

  attr_accessor :x, :y, :points, :string
```
Po:
```ruby
def x
  @x
end

def x=(position_x)
  @x = position_x
end

### UncommunicativeMethodName & UncommunicativeVariableName:
W projekcie występowało wiele nic niemówiących dla czytającego kod programisty zmiennych i metod. Poniżej pokazano jeden przykład. Należało pamiętać by wprowadzić tą zmianę w całym kodzie.
```ruby
def position_x
  @position_x
end

def position_x = (position_x)
  @position_x = position_x
end
```

## ```compund_word.rb```
Pozbyto się wszystkich ostrzeżeń występujących w klasie CompoundWord. Tym razem poza ostrzeżeniami Attribute oraz UncommunicativeVariableName wystąpiły takie ostrzeżenia jak: IrresponsibleModule oraz InstanceVariableAssumption. Pierwszy z nich mówi o tym, że klasy i moduły to jednostki, ponownego użycia, a więc warto dodać przynajmniej jeden krótki komentarz opisujący przeznaczenie klasy/modułu. Drugi z „nowych” ostrzeżeń informuje nas o tym, że zmienne instancyjne nie powinny być ustawiane poza definicją klasy, dlatego trzeba je zdefiniować w klasie. Cała klasa CompoundWord jest dość krótka, składa się zaledwie z 1 metody, więc całość przed edycja jak i po została zamieszczona poniżej.
Przed:
```ruby 
attr_accessor :x, :y, :points

def initialize(string)
  super(string)
  @color = Gosu::Color,new(0xff_00ff00)
  @points = 20
end

def move
  @vel = @vel + 0.5 * rand(0.05..0.07)#This is the acceleration
  @y += @vel * 0.25
end
```

Po:
```ruby
attr_reader :position_y, :points, :vel

def initialize(string)
  @position_y = position_y
  @vel = vel
  @points = points
  super(string)
  @color = Gosu::Color.new(0xff_00ff00)
  @points = 20
end

def move
  @vel = @vel + 0.5 * rand(0.05..0.07)#This is the acceleration
  @position_y += @vel * 0.25
end
```

## ```document_parser.rb```
Plik był stworzony przez grupę w celu dodania możliwości wyboru miedzy plikami o rozszerzeniu .txt oraz .docx. Początkowo występowały dwa ostrzeżenia z gemu Reek: InstanceVariableAssumption, IrresponsibleModule, jednak bazując na zdobytym doświadczeniu szybko się ich pozbyto. Przy okazji usuwania drugiego ostrzeżenia, usunięto go również z pliku z_order.rb.

## ```main.rb```
W ```main.rb``` głównymi ostrzeżeniami, z którymi należało się uporać było ostrzeżenia typu: TooManyStatements oraz DuplicateMethodCall, również wystąpiły podobne ostrzeżenia jak w poprzednich klasach. 

### TooManyStatements & DuplicateMethodCall:
„TooManyStatements” jest to ostrzeżenie dotyczące długości metody. W dokumentacji reek można zauważyć, iż metoda powinna składać się z maksymalnie pięciu instrukcji. Nie zawsze jest to możliwe, szczególnie przy refaktoryzacji czyjegoś kodu. Często metody są długie, zbyt długie. Należy je rozbić na mniejsze metody. Dzięki temu kod na pewno będzie łatwiejszy do czytania oraz edycji dla innych programistów. Podczas refaktoryzowania projektu zdarzyło się nie pozbyć tego „zapachu”, a jedynie zredukować maksymalną liczbę instrukcji w poszczególnych metodach do sześciu. Niestety nie zawsze jest to możliwe bez większego naruszenia struktury kodu. Poniżej przedstawiono metody z pliku main.rb, z których usunięto ostrzeżenie „TooManyStatements”.

Przed:
```ruby
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
```

Po:
```ruby
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
```

Powyższa metoda check_time zawierała zbyt dużo instrukcji, a także zbyt wiele powtórzeń. Stworzono dodatkową metodę, a także zmienne, dzięki temu kod jest bardziej czytelny.

Przed:
```ruby
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

```
Po:
```ruby
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

  ```


### Zmiany we własnym kodzie
Metoda determine_words_database została rozbita, na mniejsze metody, które odpowiadają za: ustalanie nowego pliku, z którego mają być pobrane słowa do gry, wybór podstawowej bazy danych słów oraz za ponowne wykonanie metody w przypadku błędnej odpowiedzi użytkownika. Ponadto zmieniono warunek w instrukcji warunkowej, tak aby tylko „y lub Y” bądź „n lub N” były uznawane za poprawną odpowiedź. W pierwotnej wersji odpowiedź np. „yyyyy” spełniała pierwszy warunek.

Przed
```ruby
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
```

Po
```ruby
def parse_file_type(file_name)
  split_file_name = file_name.split(".")
  case split_file_name[-1]
  when "txt"
    determine_file_type(file_name, TxtDocumentParser)
  when "docx"
    determine_file_type(file_name, DocxDocumentParser)
  else
    wrong_file_type
  end
end

def wrong_file_type
  puts "Unsupported filetype given, try txt or docx"
  determine_words_database()
end

def determine_file_type(file_name, file_type)
  table_to_return = DocumentParser.new "#{file_name}", file_type
  return table_to_return.parse
end
```

Metoda parse_file_type została rozbita na dwie dodatkowe, z których jedna odpowiada za ustalenie typu pliku jaki ma być parsowany.

