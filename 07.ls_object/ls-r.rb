# frozen_string_literal: true

require './ls'

class R_option
  def initialize(paths)
    @paths = paths
  end

  def reverse
    @paths.reverse
  end
end

