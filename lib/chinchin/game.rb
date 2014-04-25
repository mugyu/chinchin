# -*- coding: utf-8 -*-

module ChinChin

  # ゲームを制御するクラス
  class Game

    # プレイヤー(参加者)全員
    attr_reader :players

    # 親(Banker)
    attr_reader :banker

    # 子の組(Punters)
    attr_reader :punters

    # @param [Array] players
    #   ゲームのプレイヤー(参加者)を配列、または複数のパラ
    #   メータとして渡す。
    def initialize(*players)
      @players = players.flatten
    end

    # 親を決定する
    #
    # 親が決まった時点で、
    # それ以外のプレイヤーが子となる
    #
    # @param player 親にするプレイヤー
    def banker=(player)
      @punters = @players - [player]
      @banker = player
    end
  end
end
