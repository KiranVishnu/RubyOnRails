require 'csv'
require_relative 'disjoint_set'

class Matcher
  attr_reader :headers, :grouped_rows

  def initialize(match_types, file)
    @match_types = match_types
    @file = file
    @rows = []
  end

  def process
    read_csv
    initialize_index
    find_matches
    assign_user_ids
  end

  def read_csv
    @headers, *@rows = CSV.read(@file)
  end

  def initialize_index
    @indices = {
      "email" => @headers.index("email"),
      "phone" => @headers.index("phone")
    }
  end

  def find_matches
    @dsu = DisjointSet.new(@rows.size)

    @match_types.each do |type|
      seen = {}
      @rows.each_with_index do |row, i|
        value = row[@indices[type]]
        next if value.nil? || value.strip.empty?

        if seen[value]
          @dsu.union(i, seen[value])
        else
          seen[value] = i
        end
      end
    end
  end

  def assign_user_ids
    groups = {}
    counter = 1
    @grouped_rows = []

    @rows.each_with_index do |row, i|
      group = @dsu.find(i)
      groups[group] ||= counter
      @grouped_rows << [groups[group], row]
      counter += 1 if groups[group] == counter
    end
  end
end