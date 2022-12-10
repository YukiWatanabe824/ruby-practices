require 'minitest/autorun'
require './Shot.rb'
require 'byebug'

class HelloTest < Minitest::Test
  def test_greeting
    assert_equal 'hello world', greeting
  end
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
    def test_1投目で10だと文字列strikeと返す
      frame = Frame.new('X', 5, 3)
      assert_equal 'strike', frame.decision
    end
    def test_1投目と2投目の合計値が10だと文字列spareと返す
      frame = Frame.new(7, 3)
      assert_equal 'spare', frame.decision
    end
  end

  describe 'Game' do
    def test_10フレームで1ゲームを構成する
      game = Game.new
      assert_equal 10, game.set_game.size
    end
  end
end

def greeting
  'hello world'
end

class Game
## game 定義仕様TODO
#  - 1ゲーム=10フレーム
#  - ストライクの場合は2投目は表記しない
#  - スペアのフレームの場合は次の1投の点を加算
#  - ストライクのフレームの場合は次の2投の点を加算
#  - 10フレーム目は1投目がストライクもしくは2投目がスペアだった場合、3投目が投げられる
  def initialize
    argv = ["6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5"]
    @shots = argv[0].split(',').map{ |shot| shot == 'X' ? 10 : shot.to_i }
  end

  def set_game
    frame = []
    frames = []

    @shots.each do |shot|
      frame << shot

      if frames.size < 10
        if frame.size >= 2 || shot == 10
          frames << frame.dup
          frame.clear
        end
      else # last frame
        frames.last << shot
      end
    end
    frames
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

  def decision
    return 'strike' if @first_shot.score == 10
    return 'spare' if @first_shot.score + @second_shot.score == 10
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
