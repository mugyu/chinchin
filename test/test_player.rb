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
    @player = ChinChin::Player.new("Alan Smithee", StabReslut)
  end

  def testCast
    assert_kind_of StabReslut, @player.cast
  end

  def testName
    assert_equal "Alan Smithee", @player.name
  end

  # result_klass の実質的なデフォルト値は ChinChin::Result
  def testDefaultResultClass
    player = ChinChin::Player.new("test default result class")
    assert_kind_of ChinChin::Result, player.cast
  end
end
