# frozen_string_literal: true

require './shot'

class Frame
  private attr_reader :shots

  def initialize(shots, num)
    @shots = shots
    @num = num
  end

  def score(next_frame, after_next_frame)
    if last_frame?
      base_score
    elsif strike?
      return base_score + next_frame.two_shot_sum if nine_frame?

      return base_score + next_frame.two_shot_sum + after_next_frame.first_shot if next_frame.strike?

      base_score + next_frame.two_shot_sum
    elsif spare?
      base_score + next_frame.first_shot
    else
      base_score
    end
  end

  def first_shot
    shots[0]
  end

  def strike?
    shots[0] == 10
  end

  def two_shot_sum
    shots.slice(0, 2).sum
  end

  def spare?
    shots.sum == 10
  end

  private

  def nine_frame?
    @num == 8
  end

  def last_frame?
    @num == 9
  end

  def base_score
    shots.sum
  end

end
