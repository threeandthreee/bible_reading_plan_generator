require 'date'
require 'psych'

class Blueprint
  include Enumerable

  def initialize blueprint_string
    @data = Psych.parse(blueprint_string).to_ruby
      .transform_keys{ |timeframe| parse_timeframe timeframe }
  end

  def each &block
    @data.each &block
  end

  def parse_timeframe timeframe
    raw_months = case timeframe
    when String, Integer then [timeframe, timeframe]
    when Array then [timeframe.first, timeframe.last]
    when Hash then [timeframe['from'], timeframe['to']]
    end

    year = 2019 # exact year doesnt matter, just pegging a non-leap year
    raw_months
      .map do |raw|
        if raw.class == Integer
          raw
        else
          Date.strptime("#{year}-#{raw[0,3]}", '%Y-%b').month
        end
      end
      .zip([1, -1]).map do |month_num, day|
        Date.new(year, month_num, day)
      end
  end
end
