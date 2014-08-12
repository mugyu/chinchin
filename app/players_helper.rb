# -*- coding: utf-8 -*-
require "models/player"
require "chinchin/players"

# Player And Players Object 生成
module PlayersHelper
  def self.included(base)
    base.extend ClassMethods
  end

  # extend class methods
  module ClassMethods
    attr_accessor :result

    def players
      @players ||= new_players
    end

    def new_players
      return reset_players if @players

      banker  = Models::Player.new("Alan Smithee")
      punter1 = Models::Player.new("John Doe")
      punter2 = Models::Player.new("Richard Roe")
      punter3 = Models::Player.new("Mario Rossi")
      ChinChin::Players.new(banker, punter1, punter2, punter3)
    end

    def reset_players
      ChinChin::Players.new(
        @players.to_a.map { |player| Models::Player.new(player.name) })
    end
  end

  # syntax suger for `self.class.players`
  def players
    self.class.players
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
