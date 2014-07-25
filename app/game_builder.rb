# -*- coding: utf-8 -*-
require "chinchin/player"
require "chinchin/players"
require "models/playing_game"
require "models/token_limiter"

# Game Object 生成
module GameBuilder
  def self.included(base)
    base.extend ClassMethods
  end

  # extend class methods
  module ClassMethods
    attr_accessor :result
    attr_reader :token_limiter

    def new_game
      @players = new_players
      banker = @players.to_a[0]
      @token_limiter = Models::TokenLimiter.new(@players, 200, 0)
      @game = Models::PlayingGame.new(
        ChinChin::Game.new(@players),
        @players,
        value: 3, player: banker
      )
      @players.banker = banker
      @game
    end

    def players
      @players ||= new_players
    end

    def new_players
      return reset_players if @players

      banker  = ChinChin::Player.new("Alan Smithee")
      punter1 = ChinChin::Player.new("John Doe")
      punter2 = ChinChin::Player.new("Richard Roe")
      punter3 = ChinChin::Player.new("Mario Rossi")
      ChinChin::Players.new(banker, punter1, punter2, punter3)
    end

    def reset_players
      ChinChin::Players.new(
        @players.to_a.map { |player| ChinChin::Player.new(player.name) })
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

  # syntax suger for `self.class.players`
  def players
    self.class.players
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
    self.class.token_limiter.upper_limit_reahed?
  end

  # syntax suger for `self.class.tokes_limiter.lower_limit_reahed?`
  def tokens_is_lower_limit_reahed?
    self.class.token_limiter.lower_limit_reahed?
  end

  # 参加者一覧表示用にソート
  #
  # @param [array]            players 参加者一覧
  # @param [ChinChin::Player] banker  親プレイヤ
  # @return ソートした参加者一覧
  def sorted_players(players, banker)
    players.sort do |a, b|
      if a.tokens == b.tokens
        case
        when a == banker
          -1
        when b == banker
          1
        else
          0
        end
      else
        b.tokens <=> a.tokens
      end
    end
  end
end
