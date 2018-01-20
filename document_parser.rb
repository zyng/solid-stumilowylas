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
