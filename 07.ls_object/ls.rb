# frozen_string_literal: true

require 'etc'
require './ls_r'
require './ls_normal'
require './ls_long'
require './ls_a'

class Ls
  def initialize(params)
    @params = params
  end

  def exec
    paths = All.new(dotmatch: @params['a']).search_path
    list_paths(paths, long_format: @params['l'], reverse: @params['r'])
  end

  private

  def list_paths(paths, reverse: false, long_format: false)
    paths = Reverse.new(paths).reverse if reverse
    long_format ? LongFormat.new(paths).format_long : NormalFormat.new(paths).format_normal
  end
end
