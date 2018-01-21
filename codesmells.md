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
