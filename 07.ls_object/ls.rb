# frozen_string_literal: true

require 'etc'
require 'optparse'
require './ls-r'
require './ls-normal'
require './ls-l'

class Ls
  def initialize(params)
    @params = params
  end

  def exec
    paths = search_path(dotmatch: @params['a'])
    list_paths(paths, long_format: @params['l'], reverse: @params['r'])
  end

  def search_path(dotmatch: false)
    dotmatch ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
  end

  def list_paths(paths, reverse: false, long_format: false)
    paths = R_option.new(paths).reverse if reverse
    long_format ? Ls_long.new(paths).list_long : Ls_normal.new(paths).list_normal
  end
end

