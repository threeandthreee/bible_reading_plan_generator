class Feeder
  attr_accessor :original_length

  def initialize chapters
    @chapters = chapters
    @original_length = content_length
  end

  def content_length
    @chapters.sum{ |chapter| chapter[:length] }
  end

  def remaining
    1 - (@original_length - content_length) / @original_length.to_f
  end

  def peek
    @chapters.first
  end

  def next
    @chapters.shift
  end
end
