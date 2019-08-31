class Collection
  attr_reader :length
  include Enumerable

  def initialize(contents)
    @contents = contents
    @length = contents.reduce(0) do |sum, contents|
      sum + contents.length
    end
  end

  def each(&block)
    @contents.each(&block)
  end
end