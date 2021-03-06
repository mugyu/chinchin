#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

lib = File.expand_path("../lib", File.dirname(__FILE__))
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "test/unit"
require "chinchin/player"

# test/unit player class
class TestPlayer < Test::Unit::TestCase
  # 結果クラス
  class StabReslut
    def initialize(dices)
      @dices = dices
    end
  end

  def setup
    @player = ChinChin::Player.new("Alan Smithee", StabReslut)
  end

  def test_cast
    assert_kind_of StabReslut, @player.cast
  end

  def test_name
    assert_equal "Alan Smithee", @player.name
  end

  def test_no_name_error
    assert_raise ChinChin::Player::NoNamePlayerError do
      ChinChin::Player.new("", StabReslut)
    end

    assert_raise ChinChin::Player::NoNamePlayerError do
      ChinChin::Player.new(nil, StabReslut)
    end
  end

  # result_klass の実質的なデフォルト値は ChinChin::Result
  def test_default_result_class
    player = ChinChin::Player.new("test default result class")
    assert_kind_of ChinChin::Result, player.cast
  end
end
