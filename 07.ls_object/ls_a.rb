# frozen_string_literal: true

require './ls'

class All
  def initialize(dotmatch: false)
    @dotmatch = dotmatch
  end

  def search_path
    @dotmatch ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
  end
end
