class Feeder
  attr_accessor :original_length
  
  def initialize(books)
    @books = books
    @halted = true
    @blocked = true
    @original_length = content_length
  end
  
  def shift
    book_end = @books.first[:chapters].length == 1
    book = book_end ? @books.shift : @books.first
    chapter = book[:chapters].shift
    format_result book, chapter
  end
  
  def first
    book = @books.first
    chapter = book[:chapters].first
    format_result book, chapter
  end
  
  def format_result(book, chapter)
    {
      book_name: book[:name],
      book_number: book[:number],
      chapter_number: chapter[:number],
      length: chapter[:length]
    }
  end
  
  def done?
    @books.empty?
  end
  
  def content_length
    @books.sum do |book|
      book[:chapters].sum do |chapter|
        chapter[:length]
      end
    end
  end
  
  def remaining
    1 - (@original_length - content_length) / @original_length.to_f
  end
end