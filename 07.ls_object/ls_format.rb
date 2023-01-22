# frozen_string_literal: true

require './ls'

class Format
  def export(lines)
   lines.each { |line| puts line }
  end
end
