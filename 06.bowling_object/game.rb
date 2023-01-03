# frozen_string_literal: true

require './frame'
require './shot'
require 'byebug'

class Game
  FRAME_RANGE = 0..9

  def initialize(score)
    @shots = score[0].split(',').map { |shot| Shot.new(shot).score }
  end

  def generate_score
    frames = generate_frame_array
    score_calculate(frames)
  end

  private

  def generate_frame_array
    frame = []
    frames = []

    @shots.each do |s|
      frame << s

      if frames.size < 10
        if frame.size >= 2 || s == 10
          frames << frame.dup
          frame.clear
        end
      else
        frames.last << s
      end
    end
    frames.map.with_index {|frame, idx| Frame.new(frame, idx)}
  end

  def score_calculate(frames)
    FRAME_RANGE.map {|n| generate_point(frames, n)}.sum
  end

  def generate_point(frames, num)
    if frames[num].is_last_frame
      return frames[num].score
    elsif frames[num].is_strike
      return frames[num].score + frames[num + 1].frame.slice(0, 2).sum if frames[num].frame_range == 8
      return frames[num].score + frames[num + 1].for_strike_score_cal + frames[num + 2].for_strike_score_cal_before_frame_is_strike if frames[num + 1].is_strike
      return frames[num].score + frames[num + 1].for_strike_score_cal
    elsif frames[num].is_spare
      return frames[num].score + frames[num + 1].for_spare_score_cal
    else
      return frames[num].score
    end
  end
end
