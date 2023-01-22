# frozen_string_literal: true

require 'byebug'
require 'etc'
require './ls_format'
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
    long_format ? LongFormat.new(paths).format : NormalFormat.new(paths).format
  end
end
