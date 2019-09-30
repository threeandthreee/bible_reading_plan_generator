require 'nokogiri'
require_relative './feeder.rb'

class Bible
  def initialize bible_file
    @data = Nokogiri::XML(bible_file)
      .root.css('BIBLEBOOK').map do |book|
        book_data = {
          name: book['bname'],
          short_name: book['bsname'],
          number: book['bnumber'].to_i
        }
        book_data.merge({
          chapters: book.css('CHAPTER').map do |chapter|
            length = chapter.css('VERS').sum{ |verse| verse.text.length }
            {number: chapter['cnumber'].to_i, length: length, book: book_data}
          end
        })
      end
  end

  def get_feeder stream
    book_nums = stream.map do |item|
      case item
      when Integer, String
        get_book_num item
      when Array
        (get_book_num(item.first)..get_book_num(item.last)).to_a
      when Hash
        (get_book_num(item['from'])..get_book_num(item['to'])).to_a
      end
    end.flatten(1)

    chapters = book_nums.map do |book_num|
      book = @data.find{ |book| book[:number] == book_num }[:chapters]
    end.flatten(1)

    Feeder.new chapters
  end

  def get_book_num id
    return id if id.class == Integer
    @data.find do |book|
      book[:name] == id || book[:short_name] == id
    end[:number]
  end
end
