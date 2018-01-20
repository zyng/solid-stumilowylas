require 'docx'

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
    @file_handler = File.read("#{@path}")
    @file_handler = @file_handler.split(", ")
    return @file_handler
  end
end

class DocxDocumentParser < BaseDocumentParser
  def parse
    @file_handler = Docx::Document.open("#{@path}").to_s
    @file_handler = @file_handler.split(", ")
    return @file_handler
  end
end
