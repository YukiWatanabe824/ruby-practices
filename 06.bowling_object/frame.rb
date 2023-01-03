# frozen_string_literal: true

require './shot'

class Frame
  attr_reader :frame, :frame_num

  def initialize(frame, frame_num)
    @frame = frame
    @frame_num = frame_num
  end

  def strike?
    'strike' if frame[0] == 10
  end

  def spare?
    'spare' if frame.sum == 10
  end

  def before_last_frame?
    'the one before last frame' if frame_num == 8
  end

  def last_frame?
    'last' if frame_num == 9
  end

  def for_strike_score_cal
    return frame[0] if strike?

    frame.sum
  end

  def for_strike_score_cal_before_frame_is_strike
    frame[0]
  end

  def for_spare_score_cal
    frame[0]
  end

  def score
    frame.sum
  end
end
