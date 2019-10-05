require 'date'
require_relative './bible.rb'
require_relative './blueprint.rb'
require_relative './day_of_reading.rb'

class Builder
  def initialize bible_file
    @bible = Bible.new bible_file
  end

  def build blueprint_string
    blueprint = Blueprint.new blueprint_string
    blueprint.map do |date_range, reading_streams|
      feeders = reading_streams.map{ |stream| @bible.get_feeder stream }
      self.build_portion date_range, feeders
    end.flatten(1).map{ |day| day.to_s }.join("\n")
  end

  def build_portion date_range, feeders
    start, finish = date_range
    days = (finish - start).to_i + 1
    total_length = feeders.sum{ |feeder| feeder.original_length }
    daily_quota = total_length.to_f / days

    allocated = 0
    reading_plan = Array.new days do |day_num|
      today = start + day_num
      todays_quota = daily_quota * (day_num + 1) - allocated
      todays_reading = DayOfReading.new today, todays_quota
      self.fill_day todays_reading, feeders
      self.cap_day todays_reading, feeders
      allocated += todays_reading.allocated
      todays_reading
    end
  end

  def fill_day day_of_reading, feeders
    until feeders.none?{ |feeder| day_of_reading.can_fit? feeder }
      day_of_reading << feeders
        .select{ |feeder| day_of_reading.can_fit? feeder}
        .max_by{ |feeder| feeder.remaining }
    end
  end

  def cap_day day_of_reading, feeders
    shortest = feeders
      .reject{ |feeder| feeder.remaining == 0 }
      .min_by{ |feeder| feeder.peek[:length] }
    day_of_reading << shortest if day_of_reading.improved_by? shortest
  end
end
