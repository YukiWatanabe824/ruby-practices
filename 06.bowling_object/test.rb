require 'minitest/autorun'
require './Shot.rb'

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
end

def greeting
  'hello world'
end


class Frame
  attr_reader :first_shot, :second_shot, :third_shot

#  - 1フレーム原則2投、例外で3投
#    - 1〜3投の結果を受け取って、各ショットスコアの合計値で返す
#  - 1投目で10本倒したらストライク
#    - 1投目で10本倒したらストライクと判定する
#  - 1投目で10本倒せず、2投目で全て倒したらスペア
#    - 2投目で全て倒したらスペアと判定する
  def initialize(first_mark, second_mark, third_mark =nil)
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
