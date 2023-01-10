# frozen_string_literal: true

require './ls'
require 'etc'
require './ls-long-file-stat'

class LongFormat


  COLUMN_NUMBER = 3

  def initialize(paths)
    @paths = paths
  end

  def format_long
    file_stats_objs = File_stat.new(@paths)
    path_stats = file_stats_objs.stat

    puts "total #{file_stats_objs.total_block}"
    path_stats.each { |stat| print_long_format(stat, file_stats_objs.max_size_map) }
  end

  private

  def print_long_format(stat, max_size_map)
    printf([
      '%<type>s%<mode>s',
      "%<nlink>#{max_size_map[:nlink] + 1}i",
      "%<username>-#{max_size_map[:username] + 1}s",
      "%<grpname>-#{max_size_map[:grpname] + 1}s",
      "%<bytesize>#{max_size_map[:bytesize]}s",
      '%<mtime>2s',
      "%<path>s\n"
    ].join(' '), stat)
  end

end
