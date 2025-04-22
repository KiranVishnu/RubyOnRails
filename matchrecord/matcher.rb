require 'csv'
require_relative 'disjoint_set'

# Matcher groups rows from a CSV based on shared email or phone number.
# It assigns a common user_id to rows representing the same individual.
class Matcher
  attr_reader :headers, :grouped_rows

  def initialize(match_types, file_path)
    @match_types = match_types     # e.g. ['email', 'phone']
    @file_path = file_path         # input CSV file
    @rows = []                     # will hold all data rows
  end

  # Main method to process the CSV and perform matching
  def process
    read_csv
    index_columns
    match_records
    assign_user_ids
  end

  private

  # Reads CSV file into headers and rows
  def read_csv
    @headers, *@rows = CSV.read(@file_path)
  end

  # Maps header field names (email/phone) to their column indices
  def index_columns
    @indices = {
      "email" => @headers.index("email"),
      "phone" => @headers.index("phone")
    }
  end

  # Groups rows using disjoint-set based on matching fields
  def match_records
    @dsu = DisjointSet.new(@rows.size)

    @match_types.each do |type|
      seen = {}  # maps a field value to its first occurrence index

      @rows.each_with_index do |row, index|
        value = row[@indices[type]]&.strip
        next if value.nil? || value.empty?

        # Union current row with the previously seen row if matched
        seen.key?(value) ? @dsu.union(index, seen[value]) : seen[value] = index
      end
    end
  end

  # Assigns user_id to each row based on their disjoint-set group
  def assign_user_ids
    group_ids = {}       # maps disjoint group index to user_id
    user_id = 1
    @grouped_rows = []   # stores [user_id, row] pairs

    @rows.each_with_index do |row, index|
      group = @dsu.find(index)
      group_ids[group] ||= user_id
      @grouped_rows << [group_ids[group], row]
      user_id += 1 if group_ids[group] == user_id
    end
  end
end
