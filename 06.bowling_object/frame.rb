# frozen_string_literal: true

require './shot'
require 'byebug'

class Frame
  attr_reader :frame, :frame_range

  def initialize(frame, frame_range)
    @frame = frame
    @frame_range = frame_range
  end

  def is_strike
    'strike' if frame[0] == 10
  end

  def is_spare
    'spare' if frame.sum == 10
  end

  def is_last_frame
    'last' if frame_range == 9
  end

  def for_strike_score_cal
    # ストライクとスペア用に値を返す
    return frame[0] if is_strike
    return frame.sum
  end

  def for_strike_score_cal_before_frame_is_strike # 一個前のフレームがストライクの場合に一投目が計算される用
    frame[0]
  end

  def for_spare_score_cal
    frame[0]
  end

  def score
    frame.sum
  end
end
