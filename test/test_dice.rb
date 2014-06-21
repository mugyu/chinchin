#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

lib = File.expand_path("../lib", File.dirname(__FILE__))
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "test/unit"
require "chinchin/dice"

# test/unit dice class
class TestDice < Test::Unit::TestCase
  def setup
    @dice = ChinChin::Dice.new
  end

  def test_cast
    assert_kind_of Integer, @dice.cast
  end

  def test_cast_phony
    assert_equal 1, @dice.cast(0)
    assert_equal 2, @dice.cast(1)
    assert_equal 3, @dice.cast(2)
    assert_equal 4, @dice.cast(3)
    assert_equal 5, @dice.cast(4)
    assert_equal 6, @dice.cast(5)
  end
end
