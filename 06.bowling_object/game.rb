# frozen_string_literal: true

require './frame'
require './shot'

class Game
  def initialize(score)
    shots = score[0].split(',').map { |shot| Shot.new(shot).score }
    @frames = generate_frame_array(shots)
  end

  def generate_score
    score_calculate(@frames)
  end

  private

  def generate_frame_array(shots)
    frame = []
    frames = []

    shots.each do |s|
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
    frames.map.with_index { |frame_score, idx| Frame.new(frame_score, idx) }
  end

  def score_calculate(frames)
    frames.map.with_index do |frame, idx|
      frame.score(frames[idx + 1], frames[idx + 2])
    end.sum
  end
end
