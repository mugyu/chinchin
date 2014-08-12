#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

lib = File.expand_path("../lib", File.dirname(__FILE__))
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
app = File.expand_path("../app", File.dirname(__FILE__))
$LOAD_PATH.unshift(app) unless $LOAD_PATH.include?(app)
require "test/unit"
require "models/player"

# test/unit extened player class
class TestExtendedPlayer < Test::Unit::TestCase
  # 結果クラス
  class StabReslut
    def initialize(dices)
      @dices = dices
    end
  end

  def setup
    @player = Models::Player.new("Alan Smithee", StabReslut)
  end

  # トークンの量
  def test_tokens
    assert_kind_of Integer, @player.tokens
    assert_equal 100, @player.tokens
  end

  # トークンを増やす
  def test_increment_token
    assert_equal 100, @player.tokens
    @player.increment_tokens 40
    assert_equal 140, @player.tokens
  end

  # トークンを減らす
  def test_decrement_token
    assert_equal 100, @player.tokens
    @player.decrement_tokens 40
    assert_equal 60, @player.tokens
  end
end
