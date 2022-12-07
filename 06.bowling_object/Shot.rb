# frozen_string_literal: true

class Shot
  attr_reader :mark

  def initialize(mark)
    @mark = mark
  end

  def score
    return 10 if mark =='X'

    mark.to.i
  end
end

shot = Shot.new('X')
shot.mark
shot.score

