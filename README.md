# Open/Closed Principle
#### Autorzy: Krzysztof Łozowski, Michał Kisielewski

## Kod do refaktoryzacji: gra Typespeed

[Link do oryginalnego repozytorium.](https://github.com/mmish321/typeSpeed)

Oryginalny kod jest prostą implementacją gry Typespeed, w języku Ruby. Program działa przy wykorzystaniu gemu gosu, z prostym interfejsem 2D.

Aby uruchomić grę, musimy zainstalować gem gosu:
```
gem install gosu
```
a następnie w głównym folderze z grą użyć komendy:
```
ruby main.rb
```

### Opis kodu
Najważniejszym plikiem pozostaje [main.rb](https://github.com/OpenClosed/solid-stumilowylas/blob/master/main.rb), odpowiadający za pętle gry, tworzenie planszy i interakcję gracza z grą.

Istotną klasą jest [compound_word.rb](https://github.com/OpenClosed/solid-stumilowylas/blob/master/compound_word.rb) odpowiadzialna za dobieranie przyśpieszenia słów pojawiających się na planszy.

Pozostałe klasy z oryginalnej wersji programu to:
[word.rb](https://github.com/OpenClosed/solid-stumilowylas/blob/master/word.rb) odpowiedzialna za umieszczanie słów na planszy,
[z_order.rb](https://github.com/OpenClosed/solid-stumilowylas/blob/master/z_order.rb)

## Refaktoryzacja

### Proponowana zmiana: Obsługa plików z bazą słów w wielu formatach tekstowych

Oryginalny kod używał "na sztywno" jednej i tej samej listy słów: [words.txt](https://github.com/OpenClosed/solid-stumilowylas/blob/master/words.txt).

Postanowiliśmy wprowadzić zmianę, która pozwoliłaby użykownikowi na podanie własnej listy słów do programu, zarówno w formacie .txt jak i .docx.

Gracz przed rozpoczęciem rozgrywki będzie wybierał, czy chce użyć domyślnej bazy słów, czy podać swoją własną.

### Właściwa refaktoryzacja

Program posiadał pewną pulę zapachów w kodzie, a postanowiliśmy się ich pozbyć po wprowadzeniu zaproponowanych przez nas zmian, podążając za radą ze schematu z książki 99 Bottles of OOP:

![Source: 99 Bottles of OOP by S. Metz & K. Owen](https://raw.githubusercontent.com/advprog/ztp/master/images/open_closed.png)

### Użycie schematu

Bazowy program był napisany w sposób dość zrozumiały.

Postanowiliśmy stowrzyć klasę odpowiadającą za obsługę różnych formatów plików - ```document_parser.rb```, która w zależności od typu pliku wykonuje odpowiednie operacje na nich.
```ruby
require 'docx'
#Document Parser klasa
class DocumentParser
  def initialize(path = "words.txt", parser_class = TxtDocumentParser)
    @path = path
    @parser_service = parser_class.new(@path)
  end

  def parse
    @parser_service.parse
  end
end

#klasa dla base
class BaseDocumentParser
  def initialize(path = "words.txt")
    @path = path
  end
end

# klasa dla txt
class TxtDocumentParser < BaseDocumentParser

  attr_reader :file_handler

  def initialize(path = "words.txt")
    @path = path
    @file_handler = file_handler
  end

  def parse
    @file_handler = File.read("#{@path}")
    @file_handler = @file_handler.split(", ")
    return @file_handler
  end
end

#klasa dla docx
class DocxDocumentParser < BaseDocumentParser

  attr_reader :file_handler

  def initialize(path = "words.txt")
    @path = path
    @file_handler = file_handler
  end

  def parse
    @file_handler = Docx::Document.open("#{@path}").to_s
    @file_handler = @file_handler.split(", ")
    return @file_handler
  end
end
```

Następnie aby klasa mogła być użyta w działąjącym już programie musieliśmy zmodyfikować plik ```main.rb`` dodając do niego odpowiednie metody.
```ruby
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
```

dzięki czemu zmienna ```@words``` wywołuje funkcję ```determine_words_database()``` zamiast pobierać tylko plik ```words.txt```.


### Reek
Lista wyeliminowanych zapachów w kodzie znajduje się w pliku [codesmells.md](https://github.com/OpenClosed/solid-stumilowylas/blob/master/codesmells.md)
