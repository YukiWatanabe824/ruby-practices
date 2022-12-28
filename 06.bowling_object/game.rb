# frozen_string_literal: true

require './frame'
require './shot'
require 'byebug'

class Game
  def initialize(score)
    @shots = score[0].split(',').map { |shot| Shot.new(shot).score }
  end

  def generate_score
    game = generate_frames
    game.sum
  end

  private

  def generate_frames
    frame = []
    frame_scores = []
    @shots.each_with_index do |shot, idx|
      break if frame_scores.size >= 10

      frame << shot
      frame = generate_frame(frame, shot, idx)

      if frame.size >= 2 || shot == 10
        frame_scores << Frame.new(frame).score
        frame.clear
      end
    end
    frame_scores
  end

  def generate_frame(frame, shot, idx)
    if frame.size >= 2
      frame << @shots[idx + 1] if frame.sum == 10 # spare
    elsif frame[0] == 10 && shot == 10 # strike
      frame << @shots[idx + 1]
      frame << @shots[idx + 2]
    end
    frame
  end
end
