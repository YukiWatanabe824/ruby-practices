# frozen_string_literal: true

require './ls-long'
require 'etc'

class File_stat

  MODE_MAP = {
    '0' => '---',
    '1' => '--x',
    '2' => '-w-',
    '3' => '-wx',
    '4' => 'r--',
    '5' => 'r-x',
    '6' => 'rw-',
    '7' => 'rwx'
  }.freeze

  def initialize(paths)
    @paths = paths
    @path_stats = stat
  end

  def stat
    @paths.map do |path|
    fs = File.stat(path)
    {
      path: path,
      type: format_type(fs),
      mode: format_mode(fs.mode),
      nlink: fs.nlink,
      username: Etc.getpwuid(fs.uid).name,
      grpname: Etc.getgrgid(fs.gid).name,
      bytesize: fs.size,
      mtime: format_mtime(fs.mtime),
      blocks: fs.blocks
    }
    end
  end

  def max_size_map
    {
      nlink: @path_stats.map { |stat| stat[:nlink].to_s.size }.max,
      username: @path_stats.map { |stat| stat[:username].size }.max,
      grpname: @path_stats.map { |stat| stat[:grpname].size }.max,
      bytesize: @path_stats.map { |stat| stat[:bytesize].to_s.size }.max
    }
  end

  def total_block
    @path_stats.map { |stat| stat[:blocks] }.sum
  end

  private

  def format_type(file_stat)
    file_stat.directory? ? 'd' : '-'
  end

  def format_mode(mode)
    permissions = mode.to_s(8).slice(-3..-1).split(//)

    permissions.map { |n| MODE_MAP[n] }.join
  end

  def format_mtime(mtime)
    format('%<mon>2d %<mday>2d %<hour>02d:%<min>02d', mon: mtime.mon, mday: mtime.mday, hour: mtime.hour, min: mtime.min)
  end
end
