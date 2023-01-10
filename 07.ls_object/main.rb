# frozen_string_literal: true

require './ls'

params = ARGV.getopts('alr')
Ls.new(params).exec
