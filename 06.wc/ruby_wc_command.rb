#! /usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  option = ARGV.getopts('l')
  path_list = ARGV
  file_info_list = FileTest.exist?(path_list[0].to_s) ? file_info_list_by_path(path_list) : file_info_list_by_stdin
  print_wc_command(file_info_list, path_list, option['l'])
end

def file_info_list_by_path(path_list)
  path_list.map do |path|
    path_text = IO.read(path)
    create_file_info(path_text, path)
  end
end

def file_info_list_by_stdin
  $stdin.tty? ? input_text : pipe_text
end

def pipe_text
  pipe_text = $stdin.read
  [create_file_info(pipe_text, nil)]
end

def input_text
  stdin_text = []
  while (line = $stdin.gets)
    stdin_text << line
  end
  [create_file_info(stdin_text.join, nil)]
end

def create_file_info(text, path)
  {
    line: text.split("\n").size,
    word: text.split(/\s+/).size,
    bytesize: text.bytesize,
    filename: (path || '')
  }
end

def print_wc_command(file_info_list, path_list, print_line_only)
  file_info_list << build_total_file_info(file_info_list) if path_list.size > 1
  file_info_list.each do |info|
    printf('%<line>8s', info)
    printf('%<word>8s%<bytesize>8s', info) unless print_line_only
    printf(" %<filename>s\n", info)
  end
end

def build_total_file_info(file_info_list)
  {
    line: file_info_list.map { |info| info[:line] }.sum,
    word: file_info_list.map { |info| info[:word] }.sum,
    bytesize: file_info_list.map { |info| info[:bytesize] }.sum,
    filename: 'total'
  }
end

main
