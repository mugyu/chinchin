# -*- coding: utf-8 -*-
require "models/playing_game"

# Game Object 生成
module GameBuilder
  def self.included(base)
    base.extend ClassMethods
  end

  # extend class methods
  module ClassMethods
    def new_game
      @players = new_players
      banker = @players.to_a[0]
      make_token_limiter(@players)
      @game = Models::PlayingGame.new(
        ChinChin::Game.new(@players),
        @players,
        value: 3, player: banker
      )
      @players.banker = banker
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
end
