#! /usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def count_lines(file)
  File.open(file) do |io|
    io.readlines.size
  end
end

def count_words(text)
  text.split(/\s+/).size
end

def count_bytesize(text)
  text.split("\n").join.bytesize
end

def normal_wc
  total_lines = 0
  total_words = 0
  total_bytesizes = 0
  ARGV.each do |file|
    text = File.read(file)
    line = count_lines(file)
    word = count_words(text)
    bytesize = (count_bytesize(text) + ("\n".bytesize * line))

    print line.to_s.rjust(8)
    print word.to_s.rjust(8)
    print bytesize.to_s.rjust(8)
    puts " #{file}"

    total_lines += line
    total_words += word
    total_bytesizes += bytesize
  end
  total_output(total_lines, total_words, total_bytesizes) if ARGV.size >= 2
end

def total_output(total_lines, total_words, total_bytesizes)
  print total_lines.to_s.rjust(8)
  print total_words.to_s.rjust(8)
  print total_bytesizes.to_s.rjust(8)
  puts ' total'
end

def save_stdin
  attrs = []
  while (line = $stdin.gets)
    attrs << line.chomp
  end
  attrs
end

opt = OptionParser.new
params = {}

opt.on('-l') { |l| params[:l_option] = l }
opt.parse!(ARGV)

if params[:l_option] == true && FileTest.exist?(ARGV[0].to_s)
  total_lines = 0
  ARGV.each do |file|
    line = count_lines(file)
    print line.to_s.rjust(8)
    puts " #{file}"

    total_lines += line
  end
  if ARGV.size >= 2
    print total_lines.to_s.rjust(8)
    puts ' total'
  end
elsif params[:l_option] == true && !$stdin.tty?
  io = $stdin.read
  print io.count("\n").to_s.rjust(8)
  puts
elsif params[:l_option] == true
  stdin_params = save_stdin
  puts stdin_params.size.to_s.rjust(8)
elsif FileTest.exist?(ARGV[0].to_s)
  normal_wc
elsif !$stdin.tty?
  io = $stdin.read
  bytesize = (count_bytesize(io) + ("\n".bytesize * io.count("\n")))
  print io.count("\n").to_s.rjust(8)
  print count_words(io).to_s.rjust(8)
  print bytesize.to_s.rjust(8)
  puts
else
  stdin_params = save_stdin
  print stdin_params.size.to_s.rjust(8)
  print stdin_params.join(' ').split(' ').size.to_s.rjust(8)
  puts (stdin_params.join.bytesize + ("\n".bytesize * stdin_params.size)).to_s.rjust(8)
end
