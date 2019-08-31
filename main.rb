require 'nokogiri'
require_relative 'book'
require_relative 'chapter'
require_relative 'day_of_reading'
require_relative 'testament'
require_relative 'testament_feeder'

OT_BOOK_COUNT = 39
NT_BOOK_COUNT = 27
DAYS = 365


# Read in Bible
file = File.open('KJV.xml')
bible = Nokogiri::XML(file)


# Set up
ot, nt = bible.root.css('BIBLEBOOK').partition{ |book| book['bnumber'] <= OT_BOOK_COUNT}.map do |books|
  Testament.new books.map do |book|
    Book.new book['bsname'], book.css('CHAPTER').map do |chapter|
      Chapter.new chapter['cnumber'], chapter.css('VERS').map do |verse|
        verse.text
      end
    end
  end
end


# Build plan
TOTAL_LENGTH = ot.length + nt.length
DAILY_QUOTA = TOTAL_LENGTH.to_f / DAYS

feeders = [TestamentFeeder.new(ot), TestamentFeeder.new(nt)]
reading_plan = Array.new(DAYS){ |day| DayOfReading.new(day + 1) }

(1..DAYS).each do |day|
  target = day * DAILY_QUOTA - (otr.allocated + ntr.allocated)
  current = 0

  feeders.sort_by!{ |tr| tr.percent_allocated } # favor testament that is behind

  # alternate until we go over, stop and try from other channel until we go over, select best capstone or none
  until feeders.all?{ |feeder| feeder.is_halted? } do
    feeders.reject{ |feeder| feeder.is_halted? }.each{ |feeder| do
      if feeder.peek.length + current <= target do
        reading_plan << feeder.pop
      else
        feeder.halt
      end
    end
  end
  
  # Select best capstone provider (or none)
  best_capstone_provider = (feeder + TestamentFeeder.none).min_by{ |feeder| do
    (feeder.peek.length + current - target).abs
  end
  reading_plan << best_capstone_provider.pop if best_capstone_provider.exists?
end
