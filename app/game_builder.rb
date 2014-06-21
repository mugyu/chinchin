# -*- coding: utf-8 -*-

# Game Object 生成
module GameBuilder
  def self.included(base)
    base.extend ClassMethods
  end

  # extend class methods
  module ClassMethods
    attr_accessor :result

    def new_game
      banker  = ChinChin::Player.new("Alan Smithee")
      punter1 = ChinChin::Player.new("John Doe")
      punter2 = ChinChin::Player.new("Richard Roe")
      punter3 = ChinChin::Player.new("Mario Rossi")
      @game = Models::PlayingGame.new(
        ChinChin::Game.new(banker, punter1, punter2, punter3),
        { value: 3, player: banker },
        200, 0
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
end
