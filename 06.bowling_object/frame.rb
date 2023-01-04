# frozen_string_literal: true

require './shot'

class Frame
  attr_reader :shots, :num

  def initialize(shots, num)
    @shots = shots
    @num = num
  end

  def strike?
    'strike' if shots[0] == 10
  end

  def spare?
    'spare' if shots.sum == 10
  end

  def before_last_frame?
    'the one before last frame' if num == 8
  end

  def last_frame?
    'last' if num == 9
  end

  def for_strike_score_cal
    return shots[0] if strike?

    shots.sum
  end

  def for_strike_score_cal_before_frame_is_strike
    shots[0]
  end

  def for_spare_score_cal
    shots[0]
  end

  def score
    shots.sum
  end
end
