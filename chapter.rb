require_relative 'collection'

class Chapter < Collection
  attr_reader :number

  def initialize(number, verses)
    super verses
    @number = number
end