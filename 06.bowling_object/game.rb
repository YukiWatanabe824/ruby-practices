# frozen_string_literal: true

require './frame'
require './shot'
require 'byebug'

class Game
  attr_reader :shots

  def initialize(score)
    scores = score[0].split(',')
    @shots = scores.map { |s| Shot.new(s).score }
  end

  def generate_score
    frames = Frame.new(@shots)
    point = frames.generate_point_cal_frame
    point.flatten.sum
  end
end
