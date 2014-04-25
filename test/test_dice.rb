#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

$LOAD_PATH.unshift "#{File.dirname(__FILE__)}/../lib"
require 'test/unit'
require 'chinchin/dice'

class TestDice < Test::Unit::TestCase
  def setup
    @dice = ChinChin::Dice.new
  end

  def testThrow
    assert_kind_of Integer, @dice.cast
  end

  def testThrowPhony
    assert_equal 1, @dice.cast(0)
    assert_equal 2, @dice.cast(1)
    assert_equal 3, @dice.cast(2)
    assert_equal 4, @dice.cast(3)
    assert_equal 5, @dice.cast(4)
    assert_equal 6, @dice.cast(5)
  end
end
