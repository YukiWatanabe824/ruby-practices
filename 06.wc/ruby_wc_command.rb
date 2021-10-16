#! /usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  option = ARGV.getopts('l')
  path_list = ARGV
  file_info_list = (FileTest.exist?(path_list[0].to_s) ? file_info_list_by_path(path_list) : file_info_list_by_stdin)
  file_info_list.each { |params| print_format(params, option['l']) }
  print_total(file_info_list, option['l']) if file_info_list.size > 1
end

def file_info_list_by_path(path_list)
  path_list.map do |path|
    path_text = IO.read(path)
    create_file_info_list(path_text, path)
  end
end

def file_info_list_by_stdin
  $stdin.tty? ? input_text : pipe_text
end

def pipe_text
  pipe_text = $stdin.read
  [create_file_info_list(pipe_text, nil)]
end

def input_text
  stdin_text = []
  while (line = $stdin.gets)
    stdin_text << line
  end
  [create_file_info_list(stdin_text.join, nil)]
end

def create_file_info_list(text, path)
  {
    line: text.split("\n").size,
    word: text.split(/\s+/).size,
    bytesize: text.bytesize,
    filename: (path ? path : "")
  }
end

def print_format(info, option)
  printf("%<line>8s", info)
  printf(["%<word>8s", 
          "%<bytesize>8s"].join, info) unless option == true
  printf(" %<filename>s\n", info)
end

def print_total(file_info_list, option)
  total_file_info = build_total_file_info(file_info_list)

  printf("%<line_total>8s", total_file_info)
  printf(["%<word_total>8s",
         "%<bytesize_total>8s"].join, total_file_info) unless option == true
  puts ' total'
end

def build_total_file_info(file_info_list)
  {
    line_total: file_info_list.map { |info| info[:line] }.sum,
    word_total: file_info_list.map { |info| info[:word] }.sum,
    bytesize_total: file_info_list.map { |info| info[:bytesize] }.sum
  }
end
main
