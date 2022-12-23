# frozen_string_literal: true
require 'minitest/autorun'
require 'byebug'

class HelloTest < Minitest::Test
#  describe 'Shot' do
#    def test_数値1を受け取って数値1を返す
#      shot = Shot.new(1)
#      assert_equal 1, shot.score
#    end
#
#    def test_文字列Xを受け取って数値10を返す
#      shot = Shot.new('X')
#      assert_equal 10, shot.score
#    end
#  end
#
#  describe 'Frame' do
#    def test_0と0の2投の結果を受け取ってスコアの合計値を返す
#      frame = Frame.new(0, 0)
#      assert_equal 0, frame.score
#    end
#
#    def test_XとXとXの3投の結果を受け取ってスコアの合計値を返す
#      frame = Frame.new('X', 'X', 'X')
#      assert_equal 30, frame.score
#    end
#  end

  describe 'Game' do
#    def test_10フレームで1ゲームを構成する
#      game = Game.new(["0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4"])
#      assert_equal 10, game.generate_frames.size
#    end
#
#    def test_全フレームストライク時にゲームスコア300点を返す
#      game = Game.new(["X,X,X,X,X,X,X,X,X,X,X,X"])
#      assert_equal 300, game.generate_score
#    end
#
#    def test_ランダムな値を渡したときに適切なスコアを返す
#      game = Game.new(['0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4'])
#      assert_equal 107, game.generate_score
#    end
  end
end

class Game
  attr_reader :shots

  def initialize(score)
    scores = score[0].split(',')
    @shots = scores.map { |s| Shot.new(s).score }
  end

  def generate_score
    frames = Frame.new(@shots)
    point = frames.generate_point_calculate_frame
    point.flatten.sum
  end

end

class Frame
  FRAME_RANGE = 0..9
  def initialize(shots)
    @shots = shots
  end

  def generate_point_calculate_frame
    frames = generate_frames
    point_calculate_frame = []

    FRAME_RANGE.each { |n| point_calculate_frame << generate_frame_for_score_calcurate(frames, n) }

    point_calculate_frame
  end

  private

  def generate_frames
    frame = []
    frames = []
    @shots.each do |shot|
      frame << shot
      frames = generate_frame(shot, frame, frames)
      frame.clear if frame.size >= 2 || shot == 10
    end
    frames
  end

  def generate_frame(shot, frame, frames)
    if frames.size < 10
      frames << frame.dup if frame.size >= 2 || shot == 10
    else # last frame
      frames.last << shot
    end
    frames
  end

  def generate_frame_for_score_calcurate(game, num)
    frame, next_frame, after_next_frame = game.slice(num, 3)
    next_frame ||= []
    after_next_frame ||= []
    left_shots = next_frame + after_next_frame

    return [frame[0], frame[1], frame[2]] if num == 9 && frame[0] == 10 # strike & last
    return [frame[0], frame[1], frame[2]] if num == 9 && frame[0] + frame[1] == 10 # spare & last
    return [frame[0], left_shots[0], left_shots[1]] if frame[0] == 10 # strike
    return [frame[0], frame[1], left_shots[0]] if frame.map.sum == 10 # spare

    [frame[0], frame[1]]
  end

end

class Shot
  def initialize(mark)
    @mark = mark
  end

  def score
    return 10 if mark == 'X'

    mark.to_i
  end
end

game = Game.new(ARGV)
puts game.generate_score
