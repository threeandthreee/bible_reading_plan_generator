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

  # Add chapter from old testament, unconditionally
  today << feeders.first.shift

  # Add from feeders part by part
  until feeders.reject{ |feeder| feeder.done? }.none?{ |feeder| today.improved_by? feeder.first } do
    feeder = feeders
      .reject{ |feeder| feeder.done? }
      .select{ |feeder| today.improved_by? feeder.first }
      .max_by{ |feeder| feeder.remaining }
    today << feeder.shift
  end
  
  # Cleanup
  allocated += today.allocated
  
  today
end


# Output
File.open('Plan.txt', 'w') do |f|
  reading_plan.each{ |plan_day| f.puts plan_day }
end