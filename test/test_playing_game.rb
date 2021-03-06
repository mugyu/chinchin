#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

test_dir = File.dirname(__FILE__)
lib = File.expand_path("../lib", test_dir)
app = File.expand_path("../app", test_dir)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
$LOAD_PATH.unshift(app) unless $LOAD_PATH.include?(app)
require "test/unit"
require "chinchin/players"
require "chinchin/game"
require "models/playing_game"

# unit/test
class TestPlayingGame < Test::Unit::TestCase
  # プレイヤ用スタブ
  class StabPlayer
    attr_accessor :tokens, :name

    def initialize(tokens = 100)
      @tokens = tokens
    end

    def cast
      self
    end
  end

  def setup
    @player1 = StabPlayer.new
    @player2 = StabPlayer.new
    @player3 = StabPlayer.new
    @players = ChinChin::Players.new(@player1, @player2, @player3)
    game = ChinChin::Game.new(@players)
    @game = Models::PlayingGame.new(game, @players, 3)
  end

  def test_play
    # TODO
  end

  def test_point_by
    assert_equal 15, @game.point_by(:ARASHI)
    assert_equal 10, @game.point_by(:SHIGORO)
    assert_equal 10, @game.point_by(:HIFUMI)
  end

  def test_rotate_banker
    @players.banker = @player1
    @game.rotate_banker
    assert_equal @player2, @players.banker
    assert_equal [@player3, @player1], @players.punters
  end

  def test_counter_limit_reached?
    @game.countup
    assert_false @game.counter_limit_reached?
    @game.countup
    assert_false @game.counter_limit_reached?
    @game.countup
    assert_true @game.counter_limit_reached?

    @game.counter_reset

    @game.countup
    assert_false @game.counter_limit_reached?
    @game.countup
    assert_false @game.counter_limit_reached?
    @game.countup
    assert_true @game.counter_limit_reached?
  end
end
