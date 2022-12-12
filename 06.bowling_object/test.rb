# frozen_string_literal: true
require 'minitest/autorun'
require './Shot.rb'
require 'byebug'

class HelloTest < Minitest::Test
  describe 'Shot' do
    def test_数値1を受け取って数値1を返す
      shot = Shot.new(1)
      assert_equal 1, shot.score
    end

    def test_文字列Xを受け取って数値10を返す
      shot = Shot.new('X')
      assert_equal 10, shot.score
    end
  end

  describe 'Frame' do
    def test_0と0の2投の結果を受け取ってスコアの合計値を返す
      frame = Frame.new(0, 0)
      assert_equal 0, frame.score
    end

    def test_XとXとXの3投の結果を受け取ってスコアの合計値を返す
      frame = Frame.new('X', 'X', 'X')
      assert_equal 30, frame.score
    end
  end

  describe 'Game' do
    def test_10フレームで1ゲームを構成する
      game = Game.new(["0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4"])
      assert_equal 10, game.generate_frames.size
    end

    def test_全フレームストライク時にゲームスコア300点を返す
      game = Game.new(["X,X,X,X,X,X,X,X,X,X,X,X"])
      assert_equal 300, game.generate_score
    end

    def test_ランダムな値を渡したときに適切なスコアを返す
      game = Game.new(['0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4'])
      assert_equal 107, game.generate_score
    end
  end
end

class Game
  FRAME_RANGE = 0..9
  attr_accessor :score

  def initialize(score)
    @shots = score[0].split(',')
  end

  def generate_frame(shot, frame, frames)
    if frames.size < 10
      frames << frame.dup if frame.size >= 2 || shot == 'X'
    else # last frame
      frames.last << shot
    end
    frames
  end

  def generate_frames
    frame = []
    frames = []
    @shots.each do |shot|
      frame << shot
      frames = generate_frame(shot, frame, frames)
      frame.clear if frame.size >= 2 || shot == 'X'
    end
    frames
  end

  def cal_frame_score(game,n)
    frame, next_frame, after_next_frame = game.slice(n, 3)
    next_frame ||= []
    after_next_frame ||= []
    left_shots = next_frame + after_next_frame

    return Frame.new(frame[0], frame[1], frame[2]) if n == 9 && frame[0] == 'X' # strike & last
    return Frame.new(frame[0], left_shots[0], left_shots[1]) if frame[0] == 'X' # strike
    return Frame.new(frame[0], frame[1], left_shots[0]) if frame.map(&:to_i).sum == 10 # spare
    return Frame.new(frame[0],frame[1])
  end

  def generate_score
    game = generate_frames
    game_score = 0

    FRAME_RANGE.each { |n| game_score += cal_frame_score(game, n).score }
    game_score
  end
end

class Frame
  attr_reader :first_shot, :second_shot, :third_shot

  def initialize(first_mark, second_mark = nil, third_mark = nil)
    @first_shot = Shot.new(first_mark)
    @second_shot = Shot.new(second_mark)
    @third_shot = Shot.new(third_mark)
  end

  def score
    @first_shot.score + @second_shot.score + @third_shot.score
  end
end

class Shot
  attr_reader :mark

  def initialize(mark)
    @mark = mark
  end

  def score
    return 10 if mark =='X'

    mark.to_i
  end
end

game = Game.new(ARGV)
puts game.generate_score
