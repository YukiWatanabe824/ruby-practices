# frozen_string_literal: true

require './ls'

class NormalFormat
  COLUMN_NUMBER = 3

  def initialize(paths)
    @paths = paths
  end

  def output
    row_number = (@paths.size / COLUMN_NUMBER).ceil
    max_length = text_max_length

    lines = Array.new(row_number) { [] }
    lines = generate_lines(lines, row_number, max_length)
    lines.each { |line| puts line }
  end

  private

  def text_max_length
    @paths.reduce(0) { |result, item| [result, item.size].max }
  end

  def generate_lines(lines, row_number, max_length)
    @paths.each_with_index do |path, index|
      line_number = index % row_number
      lines[line_number].push(path.ljust(max_length + 6))
    end
    lines.map { |line| line.join.strip }
  end
end
