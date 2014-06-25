#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

app = File.expand_path("../app", File.dirname(__FILE__))
$LOAD_PATH.unshift(app) unless $LOAD_PATH.include?(app)
require "test/unit"
require "models/limited_number_of_tokens"

# test/unit `limited the numver of tokens`
class TestLimitedNumberOfTokens < Test::Unit::TestCase
  StabPlayer = Struct.new("StabPlayer", :tokens)
  StabPlayers = Struct.new("StabPlayers", :to_a)

  def setup
    @players = StabPlayers.new([
      StabPlayer.new(100),
      StabPlayer.new(100),
      StabPlayer.new(100)
    ])
    @limiter = Models::LimitedNumberOfTokens.new(@players, 200, 0)
  end

  def test_upper_limit
    assert_equal 200, @limiter.upper_limit
  end

  def test_lower_limit
    assert_equal 0, @limiter.lower_limit
  end

  def test_upper_limit_reahed?
    @players.to_a[1].tokens = 200
    assert_false @limiter.upper_limit_reahed?

    @players.to_a[1].tokens = 201
    assert_true @limiter.upper_limit_reahed?
  end

  def test_lower_limit_reahed?
    @players.to_a[1].tokens = 0
    assert_false @limiter.lower_limit_reahed?

    @players.to_a[1].tokens = -1
    assert_true @limiter.lower_limit_reahed?
  end
end
