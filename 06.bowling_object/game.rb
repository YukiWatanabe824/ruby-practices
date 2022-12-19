# frozen_string_literal: true

require './frame'
require './shot'
require 'byebug'

class Game
  FRAME_RANGE = 0..9

  def initialize(score)
    @shots = score[0].split(',')
  end

  def generate_score
    game = generate_frames
    game_score = 0

    FRAME_RANGE.each { |n| game_score += cal_frame_score(game, n).score }
    game_score
  end

  private

  def generate_frame(shot, frame, frames)
    if frames.size < 10
      frames << frame.dup if frame.size >= 2 || shot == 'X'
    else # last frame
      frames.last << shot
    end
    frames
  end

  def generate_frames
    frame = []
    frames = []
    @shots.each do |shot|
      frame << shot
      frames = generate_frame(shot, frame, frames)
      frame.clear if frame.size >= 2 || shot == 'X'
    end
    frames
  end

  def cal_frame_score(game, num)
    frame, next_frame, after_next_frame = game.slice(num, 3)
    next_frame ||= []
    after_next_frame ||= []
    left_shots = next_frame + after_next_frame

    return Frame.new(frame[0], frame[1], frame[2]) if num == 9 && frame[0] == 'X' # strike & last
    return Frame.new(frame[0], frame[1], frame[2]) if num == 9 && frame[0].to_i + frame[1].to_i == 10 # spare & last
    return Frame.new(frame[0], left_shots[0], left_shots[1]) if frame[0] == 'X' # strike
    return Frame.new(frame[0], frame[1], left_shots[0]) if frame.map(&:to_i).sum == 10 # spare

    Frame.new(frame[0], frame[1])
  end

end
