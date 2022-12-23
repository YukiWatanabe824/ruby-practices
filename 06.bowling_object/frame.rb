# frozen_string_literal: true

require './shot'

class Frame
  FRAME_RANGE = 0..9
  def initialize(shots)
    @shots = shots
  end

  def generate_point_cal_frame
    frames = generate_frames
    point_cal_frame = []

    FRAME_RANGE.each { |n| point_cal_frame << generate_cal_frame(frames, n) }

    point_cal_frame
  end

  private

  def generate_frames
    frame = []
    frames = []
    @shots.each do |shot|
      frame << shot
      frames = generate_frame(shot, frame, frames)
      frame.clear if frame.size >= 2 || shot == 10
    end
    frames
  end

  def generate_frame(shot, frame, frames)
    if frames.size < 10
      frames << frame.dup if frame.size >= 2 || shot == 10
    else # last frame
      frames.last << shot
    end
    frames
  end

  def generate_cal_frame(game, num)
    frame, next_frame, after_next_frame = game.slice(num, 3)
    next_frame ||= []
    after_next_frame ||= []
    left_shots = next_frame + after_next_frame

    strike_or_spare_point = strike_or_spare(num, frame, left_shots)
    return strike_or_spare_point unless strike_or_spare_point.nil?

    [frame[0], frame[1]]
  end

  def strike_or_spare(num, frame, left_shots)
    if num == 9 # last
      return [frame[0], frame[1], frame[2]] if frame[0] == 10 || frame[0] + frame[1] == 10 # strike or spare
    else
      return [frame[0], left_shots[0], left_shots[1]] if frame[0] == 10 # strike
      return [frame[0], frame[1], left_shots[0]] if frame.map.sum == 10 # spare
    end
  end
end
