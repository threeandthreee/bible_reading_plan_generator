class Feeder
  attr_accessor :original_length
  
  def initialize(books)
    @books = books
    @halted = true
    @blocked = true
    @original_length = content_length
  end
  
  def shift
    return nil if is_halted?
    is_end_of_book = @books.first[:chapters].length == 1
    book = if is_end_of_book
        @blocked = true
        @books.shift
      else
        @books.first
      end
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
  
  def clear
    @halted = false
    @blocked = false unless @books.empty?
  end
  
  def halt
    @halted = true
  end
  
  def is_halted?
    @halted || @blocked
  end
  
  def is_blocked?
    @blocked
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