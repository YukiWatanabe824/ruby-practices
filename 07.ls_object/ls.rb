# frozen_string_literal: true

require 'etc'
require './ls_normal'
require './ls_long'

class Ls
  def initialize(params)
    @params = params
  end

  def exec
    paths = @params['a'] ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
    list_paths(paths, long_format: @params['l'], reverse: @params['r'])
  end

  private

  def list_paths(paths, reverse: false, long_format: false)
    paths = paths.reverse if reverse
    paths = long_format ? LongFormat.new(paths) : NormalFormat.new(paths)
    paths.output
  end
end
