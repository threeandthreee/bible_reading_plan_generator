require 'date'

class DayOfReading
  def initialize(day, quota)
    @date = Date.new(2019, 1, 1) + day
    @quota = quota
    @parts = []
  end
  
  def allocated
    @parts.sum{ |part| part[:length] }
  end

  def <<(part)
    @parts << part unless part.nil?
  end

  def can_fit?(part)
    allocated + part[:length] <= @quota
  end

  def projected_distance_from_quota_with(part)
    (@quota - (allocated + part[:length])).abs
  end

  def improved_by?(part)
    baseline = (@quota - allocated).abs
    projected = projected_distance_from_quota_with part
    projected <= baseline
  end

  def to_s
    date = @date.strftime('%b %e')
    reading = @parts
      .sort_by{ |part| part[:book_number].to_i }
      .chunk{ |part| part[:book_name] }
      .map do |book_name, chunk|
        chapter_string = ''+chunk.first[:chapter_number]
        chapter_string << "-#{chunk.last[:chapter_number]}" if chunk.length > 1
        "#{book_name} #{chapter_string}"
      end
      .join(', ')
      
    "#{date}: #{reading}"
  end
end
