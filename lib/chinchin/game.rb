# -*- coding: utf-8 -*-

module ChinChin

  # ゲームを制御するクラス
  class Game

    # 例外クラス:
    # 親を決定する際、親がゲームに参加していない場合に発生する
    class NotJoinedGameError < TypeError; end

    # プレイヤー(参加者)全員
    attr_reader :players

    # 親プレイヤ(Banker)
    # @overload banker
    #   親(Banker)
    #
    #   @return 親プレイヤ
    # @overload banker=(player)
    #   親(Banker)を決定する
    #
    #   親が決まった時点で、
    #   それ以外のプレイヤが子となる。
    #
    #   @param player 親にするプレイヤ
    #   @return 親プレイヤ
    #   @raise [NotJoinedGameError]
    #          パラメータの player がゲームに参加していない場合は、
    #          例外が発生する
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
    # @see #banker
    def banker=(player)
      unless players.include? player
        raise NotJoinedGameError,
          "banker has not joined game."
      end
      @punters = @players - [player]
      @banker = player
    end
  end
end
