require 'minitest/autorun'
require './Shot.rb'

class HelloTest < Minitest::Test
  def test_greeting
    assert_equal 'hello world', greeting
  end

  def test_数値1を受け取って数値1を返す
    shot = Shot.new(1)
    result = shot.score
    assert_equal 1, result
  end

  def test_文字列Xを受け取って数値10を返す

  end
end

def greeting
  'hello world'
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
