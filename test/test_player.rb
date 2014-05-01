#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

$LOAD_PATH.unshift "#{File.dirname(__FILE__)}/../lib"
require 'test/unit'
require 'chinchin/player'

class TestPlayer < Test::Unit::TestCase

  class StabReslut
    def initialize(dices)
      @dices = dices
    end
  end

  def setup
    @player = ChinChin::Player.new(StabReslut)
  end

  def testCast
    assert_kind_of StabReslut, @player.cast
  end
end
