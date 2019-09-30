class DayOfReading
  def initialize(date, quota)
    @date, @quota = date, quota
    @items = []
  end

  def allocated
    @items.sum{ |item| item[:length] }
  end

  def << feeder
    @items << feeder.next
  end

  def can_fit? feeder
    allocated + feeder.peek[:length] <= @quota
  rescue
    false
  end

  def improved_by? feeder
    baseline = (@quota - allocated).abs
    projected = (@quota - allocated - feeder.peek[:length]).abs
    projected <= baseline
  rescue
    false
  end

  def to_s
    reading = @items
      .sort_by{ |item| item[:book][:number] }
      .chunk{ |item| item[:book][:short_name] }
      .map do |short_name, chunk|
        chapter_string = chunk.first[:number].to_s
        chapter_string << "-#{chunk.last[:number].to_s}" if chunk.length > 1
        "#{short_name} #{chapter_string}"
      end
      .join(', ')
    "#{@date.strftime('%b %e')}: #{reading}"
  end
end
