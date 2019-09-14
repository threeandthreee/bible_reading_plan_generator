require 'nokogiri'
require_relative 'day_of_reading'
require_relative 'feeder'

OT_BOOK_COUNT = 39
NT_BOOK_COUNT = 27
DAYS = 365


# Read in Bible
file = File.open('KJV.xml')
bible = Nokogiri::XML(file)


# Set up feeder
feeders = bible.root.css('BIBLEBOOK')
  .partition{ |book| book['bnumber'].to_i <= OT_BOOK_COUNT}
  .map do |books|
    Feeder.new(books.map do |book|
      chapters = book.css('CHAPTER').map do |chapter|
        length = chapter.css('VERS').sum{ |verse| verse.text.length }
        {number: chapter['cnumber'], length: length}
      end
      {name: book['bsname'], number: book['bnumber'], chapters: chapters}
    end)
end


# Build plan
TOTAL_LENGTH = feeders.sum{ |feeder| feeder.original_length }
DAILY_QUOTA = TOTAL_LENGTH.to_f / DAYS

allocated = 0
reading_plan = Array.new(DAYS) do |day|
  # Setup
  todays_quota = DAILY_QUOTA * (day + 1) - allocated
  today = DayOfReading.new(day, todays_quota)
  feeders.each{ |feeder| feeder.clear }

  # Add chapter from least read feed, unconditionally
  #today << feeders.max_by{ |feeder| feeder.remaining }.shift
  today << feeders.first.shift
  
  until feeders.all?{ |feeder| feeder.is_halted? } do
    feeder = feeders
      .reject{ |feeder| feeder.is_halted? }
      .max_by{ |feeder| feeder.remaining }
    if today.can_fit? feeder.first
      today << feeder.shift
    else
      feeder.halt
    end
  end
  
  # Select best capstone, only use if it gets us closer to quota
  best_capstone_feeder = feeders
    .reject{ |feeder| feeder.is_blocked? }
    .min_by{ |feeder| today.projected_distance_from_quota_with feeder.first }
  if(best_capstone_feeder and today.improved_by? best_capstone_feeder.first)
    best_capstone_feeder.clear
    today << best_capstone_feeder.shift
  end
  
  # Cleanup
  allocated += today.allocated
  
  today
end


# Output
File.open('Plan.txt', 'w') do |f|
  reading_plan.each{ |plan_day| f.puts plan_day }
end