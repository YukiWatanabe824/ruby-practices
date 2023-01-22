# frozen_string_literal: true

require 'byebug'
require 'etc'
require './ls_format'
require './ls_r'
require './ls_normal'
require './ls_long'
require './ls_a'


class Ls
  def initialize(params)
    @params = params
  end

  def exec
    paths = Option.new(dotmatch: @params['a']).a_option
    list_paths(paths, long_format: @params['l'], reverse: @params['r'])
  end

  private

  def list_paths(paths, reverse: false, long_format: false)
    paths = paths.r_option if reverse
    #long_format ? LongFormat.new(paths).output : NormalFormat.new(paths).output
    NormalFormat.new(paths).format
  end
end
