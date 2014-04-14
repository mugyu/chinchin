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
    assert_kind_of Integer, @dice.thow
  end

  def testThrowPhony
    assert_equal 1, @dice.thow(0)
    assert_equal 2, @dice.thow(1)
    assert_equal 3, @dice.thow(2)
    assert_equal 4, @dice.thow(3)
    assert_equal 5, @dice.thow(4)
    assert_equal 6, @dice.thow(5)
  end
end
