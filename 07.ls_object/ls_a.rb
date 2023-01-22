# frozen_string_literal: true

require './ls'

class Option
  def initialize(dotmatch: false, paths: nil)
    @dotmatch = dotmatch
    @paths = paths
  end

  def a_option
    @dotmatch ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
  end

  def r_option
    @paths.reverse
  end
end
