# frozen_string_literal: true

require './shot'
require 'byebug'

class Frame
  attr_reader :frame

  def initialize(shots)
    @frame = shots
  end

  def score
    frame.sum
  end
end
