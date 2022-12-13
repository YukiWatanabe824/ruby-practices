# frozen_string_literal: true

require './game'

game = Game.new(ARGV)
puts game.generate_score
