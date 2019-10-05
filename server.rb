require 'sinatra'
require_relative './lib/builder.rb'

bible_file = File.open "resources/KJV.xml"
builder = Builder.new bible_file

set :bind, '0.0.0.0'

get '/' do
  haml :index
end

post '/' do
  builder.build request.body.read
end
