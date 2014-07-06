#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

lib = File.expand_path("../lib", File.dirname(__FILE__))
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "test/unit"
require "chinchin/game/result"

# test/unit ChinChin::Game::Result
class TestGameResult < Test::Unit::TestCase
  def setup
    @result = ChinChin::Game::Result.new(:player, :yaku, :point, :dice)
  end

  def test_construct
    assert_equal :player, @result.player
    assert_equal :yaku, @result.yaku
    assert_equal :point, @result.point
    assert_equal :dice, @result.dice
  end

  def test_outcome
    @result.outcome(:win)
    assert_equal :win, @result.outcome

    @result.outcome(:lost)
    assert_equal :lost, @result.outcome
  end
end
