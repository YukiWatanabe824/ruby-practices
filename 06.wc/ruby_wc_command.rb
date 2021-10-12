#! /usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  option = ARGV.getopts('l')
  #ARGVは可能な限り使わない。mainメソッドで変数に代入する
  #それによって他所で使っているARGVを修正する
  text_params = (FileTest.exist?(ARGV[0].to_s) ? generate_path_text : serch_pipe_input)
  # paramsはNG、〜listがよさげ
  # search_pipe_inputはgenerate〜に揃える
  option['l'] ? short_format(text_params) : long_format(text_params)
  #アウトプットするメソッドは統合してメソッド引数としてLオプションを取るほうがスマート
end

def generate_path_text
  ARGV.map do |path|
    path_text = IO.read(path)
    create_text_params(path_text, path)
  end
end

def serch_pipe_input
  $stdin.tty? ? input_text : pipe_text
end

def pipe_text
  pipe_text = $stdin.read
  text_params = []
  text_params << create_text_params(pipe_text, nil)
  #【】を使って配列化する
end

def input_text
  stdin_text = []
  while (line = $stdin.gets)
    stdin_text << line
  end
  text_params = []
  text_params << create_text_params(stdin_text.join, nil)
  #【】を使って配列化する
end

def create_text_params(text, path)
  {
    line: text.split("\n").size,
    word: text.split(/\s+/).size,
    bytesize: text.bytesize,
    filename: (path == true ? path : nil)
  }
end

def filename

end

#出力の文字数を調整するメソッドを追加
#出力メソッドは統合する
def short_format(text_params)
  text_params.each_with_index do |params, idx|
    print params[:line].to_s.rjust(8)
    puts " #{ARGV[idx]}" if ARGV.size >= 0
  end
  line_total = text_params.map { |params| params[:line] }.sum
  puts "#{line_total.to_s.rjust(8)} total" if text_params.size > 1
end

def long_format(text_params)
  text_params.each_with_index do |params, idx|
    print params[:line].to_s.rjust(8)
    print params[:word].to_s.rjust(8)
    print params[:bytesize].to_s.rjust(8)
    puts " #{ARGV[idx]}" if ARGV.size >= 0
  end
  long_format_total(text_params) if text_params.size > 1
end

def long_format_total(text_params)
  line_total = text_params.map { |params| params[:line] }.sum
  word_total = text_params.map { |params| params[:word] }.sum
  bytesize_total = text_params.map { |params| params[:bytesize] }.sum

  print line_total.to_s.rjust(8)
  print word_total.to_s.rjust(8)
  print bytesize_total.to_s.rjust(8)
  puts ' total'
end

main
