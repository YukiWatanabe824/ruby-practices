# frozen_string_literal: true

class Frame
  attr_reader :first_shot, :second_shot, :third_shot

  def initialize(first_mark, second_mark, third_mark =nil)
    @first_shot = Shot.new(first_mark)
    @second_shot = Shot.new(second_mark)
    @third_shot = Shot.new(third_mark)
  end

  def score
    # TODO
    #
  end
end

frame = Frame.new('1', '9')
puts frame.score