require 'csv'
require_relative 'matcher'

# Ensure user provides match type(s) and a CSV file as arguments
if ARGV.size < 2
  puts "Usage: ruby match_users.rb <match_type(s)> <input_file.csv>"
  exit
end

# Extract match types (email, phone, or both) and the input file
match_types = ARGV[0...-1]       # All args except the last one
input_file  = ARGV.last
output_file = "output_#{File.basename(input_file)}"

# Process matching logic
matcher = Matcher.new(match_types, input_file)
matcher.process

# Write results to output CSV file with a prepended 'user_id' column
CSV.open(output_file, 'w') do |csv|
  csv << ['user_id'] + matcher.headers
  matcher.grouped_rows.each { |user_id, row| csv << [user_id] + row }
end

puts "✅ Matching complete! Output saved to: #{output_file}"
