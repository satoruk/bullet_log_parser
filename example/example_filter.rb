#!/usr/bin/env ruby
# frozen_string_literal: true

$LOAD_PATH.push("#{__dir__}/../lib")

require 'bullet_log_parser'

if __FILE__ == $PROGRAM_NAME
  results = BulletLogParser.uniq_log($stdin) do |ast|
    # skip no call stack
    next if ast[:stack].empty?

    stack = ast[:stack].last
    puts "#{stack[:filename]}:#{stack[:lineno]}:#{ast[:level]}"
    ast[:details].each do |detail|
      puts "  #{detail}"
    end
    puts ''
  end
  puts '-- summary ------'
  puts results
    .keys
    .map { |k| "#{k}:#{results[k].size}" }
    .join("\n")
end
