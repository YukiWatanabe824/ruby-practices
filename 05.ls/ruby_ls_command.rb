#! /usr/bin/env ruby
# frozen_string_literal: true

require 'etc'
require 'date'

command_option = ARGV.map { |val| val.match?(/-[arl][arl]?[arl]?/) ? val.delete('-') : nil }
command_option = command_option.join

path = ARGV.last
if path.nil? || path.match?(/-[arl][arl]?[arl]?/)
  dir_file_list = Dir.entries('./')
  path = './'
elsif path == '~'
  dir_file_list = Dir.entries('/')
else
  dir_file_list = Dir.entries(path)
end
dir_file_list.sort!

class LsCommand
  Column = 3

  def initialize(dir_file_list, path, command_option)
    @dir_file_list = dir_file_list
    @command_option = command_option
    @path = path
  end

  def set_option_format_and_output
    @dir_file_list.delete_if { |dir| dir =~ /^\..*/ } unless @command_option.match?(/a/)
    @dir_file_list.reverse! if @command_option.match?(/r/)
    @command_option.match?(/l/) ? output_l_option_format(@dir_file_list) : output_normal_format(@dir_file_list)
  end

  def output_l_option_format(dir_file_list)
    filestat_info = dir_file_list.map { |f| File::Stat.new(@path + f) }

    size_length = filestat_info.map { |f| f.size.to_s }
    size_length = size_length.max_by(&:length).length

    sum_file_blocks = filestat_info.map(&:blocks).sum
    puts "total #{sum_file_blocks}"

    filestat_info.each_with_index do |f, idx|
      print filetype(f.ftype)
      output_permission(f)
      print '  '
      print f.nlink.to_s.ljust(4)
      print "#{Etc.getpwuid(f.uid).name}  "
      print "#{Etc.getgrgid(f.gid).name}  "
      print "#{f.size.to_s.rjust(size_length)}  "
      output_filetime(f)
      puts dir_file_list[idx]
    end
  end

  def output_filetime(filestat)
    file_birth_day = Date.new(filestat.ctime.year, filestat.ctime.month, filestat.ctime.day)
    today = Date.today
    if file_birth_day <= today.prev_month(6) || file_birth_day >= today.next_month(6)
      print "#{filestat.ctime.month.to_s.rjust(2)} #{filestat.ctime.day.to_s.rjust(2)} #{filestat.ctime.year.to_s.rjust(5)} "
    else
      print "#{filestat.ctime.month.to_s.rjust(2)} #{filestat.ctime.day.to_s.rjust(2)} "
      print "#{filestat.ctime.hour.to_s.rjust(2, '0')}:#{filestat.ctime.min.to_s.rjust(2, '0')} "
    end
  end

  def output_permission(filestat)
    fmode = filestat.mode.to_s(8).length <= 5 ? "0#{filestat.mode.to_s(8)}".split(//) : filestat.mode.to_s(8).split(//)
    fmode.each_with_index do |fmode_num, fmode_idx|
      next if fmode_idx < 3

      permission_value =
        case fmode[2]
        when '1'
          permission(fmode_num)[2] == '-' ? 't' : 'T'
        when '2'
          permission(fmode_num)[0] == '-' ? 's' : 'S'
        when '4'
          permission(fmode_num)[1] == '-' ? 's' : 'S'
        else
          permission(fmode_num)
        end
      print permission_value
    end
  end

  def permission(fmode)
    {
      '0' => '---',
      '1' => '--x',
      '2' => '-w-',
      '3' => '-wx',
      '4' => 'r--',
      '5' => 'r-x',
      '6' => 'rw-',
      '7' => 'rwx'
    }[fmode]
  end

  def filetype(type)
    {
      'fifo' => 'p',
      'characterSpecial' => 'c',
      'directory' => 'd',
      'blockSpecial' => 'b',
      'file' => '-',
      'link' => 'l',
      'socket' => 's'
    }[type]
  end

  def output_normal_format(dir_file_list)
    max_char_space = dir_file_list.max_by(&:length).length
    char_space = max_char_space > 20 ? max_char_space : 20
    d_len = dir_file_list.length

    row = (d_len / Column) + ((d_len % Column).zero? ? 0 : 1)
    dir_file_array = []
    dir_file_list.each_slice(row) { |val| dir_file_array << val }
    max_size = dir_file_array.map(&:size).max
    dir_file_array.map! { |val| val.values_at(0...max_size) }
    dir_file_array = dir_file_array.transpose
    dir_file_array.each do |dir_file|
      dir_file.each do |d_f_child|
        if d_f_child == dir_file.last
          puts d_f_child
        else
          print "#{d_f_child.to_s.ljust(char_space)} "
        end
      end
    end
  end
end

lscommand = LsCommand.new(dir_file_list, path, command_option)
lscommand.set_option_format_and_output
