# frozen_string_literal: true

require './ls'
require 'optparse'

params = ARGV.getopts('alr')
Ls.new(params).exec
