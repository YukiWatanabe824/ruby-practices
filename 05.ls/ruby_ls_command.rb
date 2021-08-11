#! /usr/bin/env ruby
# frozen_string_literal: true

require 'etc'
require 'date'

command_option = ARGV.map { |val| val.match?(/-[arl][arl]?[arl]?/) ? val.delete('-') : nil }
command_option = command_option.join

path = ARGV.last
if path.nil? || path.match?(/-[arl][arl]?[arl]?/)
  directory_and_file_list = Dir.entries('./')
  path = './'
elsif path == '~'
  directory_and_file_list = Dir.entries('/')
else
  directory_and_file_list = Dir.entries(path)
end
directory_and_file_list = directory_and_file_list.sort

class LsCommand
  def initialize(directory_and_file_list, path, command_option)
    @directory_and_file_list = directory_and_file_list
    @command_option = command_option
    @path = path
  end

  def set_option_format_and_output
    @command_option.match?(/a/) ? @directory_and_file_list : @directory_and_file_list.delete_if { |dir| dir =~ /^\..*/ }
    directory_and_file_list = @command_option.match?(/r/) ? @directory_and_file_list.reverse : @directory_and_file_list
    @command_option.match?(/l/) ? output_l_option_format(directory_and_file_list) : output_normal_format(directory_and_file_list)
  end

  def output_l_option_format(directory_and_file_list)
    filestat_info = directory_and_file_list.map { |f| File::Stat.new(@path + f) }

    size_length = filestat_info.map { |f| f.size.to_s }
    size_length = size_length.max_by(&:length).length

    file_blocks = filestat_info.map(&:blocks)
    sum_file_blocks = file_blocks.inject { |result, item| result + item }
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
      puts directory_and_file_list[idx]
    end
  end

  def output_filetime(filestat)
    file_birth_day = Date.new(filestat.ctime.year, filestat.ctime.month, filestat.ctime.day)
    today = Date.today
    if today - file_birth_day <= 183 || file_birth_today - today >= -183
      print "#{filestat.ctime.month.to_s.rjust(2)} #{filestat.ctime.day.to_s.rjust(2)} "
      print "#{filestat.ctime.hour.to_s.rjust(2, '0')}:#{filestat.ctime.min.to_s.rjust(2, '0')} "
    else
      print "#{filestat.ctime.month.to_s.rjust(2)} #{filestat.ctime.day.to_s.rjust(2)} #{filestat.ctime.year.to_s.rjust(5)} "
    end
  end

  def output_permission(filestat)
    fmode = filestat.mode.to_s(8).length <= 5 ? "0#{filestat.mode.to_s(8)}".split(//) : filestat.mode.to_s(8).split(//)
    fmode.each_with_index do |fmode_num, fmode_idx|
      next if fmode_idx < 3

      permission_value = permission(fmode_num)
      case fmode[2]
      when '1'
        permission_value = permission_value[2] == '-' ? 't' : 'T'
      when '2'
        permission_value = permission(fmode_num)[0] == '-' ? 's' : 'S'
      when '4'
        permission_value = permission(fmode_num)[1] == '-' ? 's' : 'S'
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

  def output_normal_format(directory_and_file_list)
    max_char_space = @directory_and_file_list.max_by(&:length).length
    char_space = max_char_space > 20 ? max_char_space : 20
    d_len = directory_and_file_list.length
    normal_format_output_part(directory_and_file_list, char_space, d_len)
  end

  def normal_format_output_part(dir_file_list, char_space, d_len)
    dir_file_list.each_with_index do |d, idx|
      next if idx >= (d_len / 3) + (d_len % 3)

      print d.ljust(char_space)
      print dir_file_list[(d_len / 3) + (idx + d_len % 3)].ljust(char_space) unless (d_len / 3) + (idx + d_len % 3) >= (d_len / 3 * 2 + d_len % 3)
      puts dir_file_list[(d_len / 3 * 2) + (idx + d_len % 3)] unless (d_len / 3 * 2) + (idx + d_len % 3) >= d_len
      puts ' ' if (d_len / 3 * 2) + (idx + d_len % 3) >= d_len
    end
  end
end

lscommand = LsCommand.new(directory_and_file_list, path, command_option)
lscommand.set_option_format_and_output