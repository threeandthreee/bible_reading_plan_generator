require_relative 'collection'

class Book < Collection
  attr_reader :name

  def initialize(name, chapters)
    super chapters
    @name = name
end