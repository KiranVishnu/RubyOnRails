require 'csv'
require_relative 'matcher'

if ARGV.length < 2
  puts "Usage: ruby match_users.rb <match_type(s)> <input_file.csv>"
  exit
end

match_types = ARGV[0..-2]
input_file = ARGV[-1]
output_file = "output_#{File.basename(input_file)}"

matcher = Matcher.new(match_types, input_file)
matcher.process

CSV.open(output_file, "w") do |csv|
  csv << ["user_id"] + matcher.headers
  matcher.grouped_rows.each do |user_id, row|
    csv << [user_id] + row
  end
end

puts "Matching complete. Output written to #{output_file}"