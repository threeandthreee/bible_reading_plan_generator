require_relative 'lib/builder.rb'

blueprint_name = ARGV[0] || 'simple'
output_filename = ARGV[1] || './plan.txt'

blueprint_file = File.open "blueprints/#{blueprint_name}.yml"
bible_file = File.open "resources/KJV.xml"

plan = Builder.build blueprint_file, bible_file

File.write output_filename, plan
puts 'Done!'
