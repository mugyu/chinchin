# -*- coding: utf-8 -*-

module ChinChin

  class Game

    attr_reader :players

    def initialize(*players)
      @players = players.flatten
    end
  end
end
