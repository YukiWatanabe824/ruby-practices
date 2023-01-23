# frozen_string_literal: true

require 'etc'
require './ls'
require './ls_long_file_stat'

class LongFormat
  def initialize(paths)
    @paths = paths
  end

  def output
    file_stats_objs = FileStat.new(@paths)
    path_stats = file_stats_objs.stat
    lines = []

    lines.push("total #{file_stats_objs.total_block}")
    path_stats.each { |stat| lines.push(print_long_format(stat, file_stats_objs.max_size_map)) }
    lines.each { |line| puts line }
  end

  private

  def print_long_format(stat, max_size_map)
    format([
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
