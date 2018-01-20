class DocumentParser
  def initialize(path = "words.txt", parser_class = TxtDocumentParser)
    @path = path
    @parser_service = parser_class.new(@path)
  end

  def parse
    @parser_service.parse
  end
end

class BaseDocumentParser
  def initialize(path = "words.txt")
    @path = path
  end
end

class TxtDocumentParser < BaseDocumentParser
  def parse
    @stolec = File.read("#{@path}")
    @stolec = @stolec.split(", ")
    return @stolec
  end
end

class DocxDocumentParser < BaseDocumentParser
  def parse
    s
  end
end
