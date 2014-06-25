# -*- coding: utf-8 -*-
require "chinchin/player"
require "chinchin/players"
require "models/playing_game"
require "models/limited_number_of_tokens"

# Game Object 生成
module GameBuilder
  def self.included(base)
    base.extend ClassMethods
  end

  # extend class methods
  module ClassMethods
    attr_accessor :result, :tokes_limiter

    def new_game
      banker  = ChinChin::Player.new("Alan Smithee")
      punter1 = ChinChin::Player.new("John Doe")
      punter2 = ChinChin::Player.new("Richard Roe")
      punter3 = ChinChin::Player.new("Mario Rossi")
      players = ChinChin::Players.new(banker, punter1, punter2, punter3)
      @tokes_limiter = Models::LimitedNumberOfTokens.new(players, 200, 0)
      @game = Models::PlayingGame.new(
        ChinChin::Game.new(players),
        value: 3, player: banker
      )
      @game.banker = banker
      @game
    end

    def game
      @game ||= new_game
    end
  end

  # syntax suger for `self.class.game`
  def game
    self.class.game
  end

  # syntax suger for `self.class.new_game`
  def new_game
    self.class.new_game
  end

  # syntax suger for `self.class.result`
  def result
    self.class.result
  end

  # syntax suger for `self.class.result=(result)`
  def result=(result)
    self.class.result = result
  end

  # syntax suger for `self.class.tokes_limiter.upper_limit_reahed?`
  def tokens_is_upper_limit_reahed?
    self.class.tokes_limiter.upper_limit_reahed?
  end

  # syntax suger for `self.class.tokes_limiter.lower_limit_reahed?`
  def tokens_is_lower_limit_reahed?
    self.class.tokes_limiter.lower_limit_reahed?
  end
end
