# -*- coding: utf-8 -*-

module ChinChin

  # ゲームを制御するクラス
  class Game

    # 例外クラス:
    # 親を決定する際、親がゲームに参加していない場合に発生する
    class NotJoinedGameError < TypeError; end

    # 例外クラス:
    # プレイヤ以外のオブジェクト
    class NotPlayerError < TypeError; end

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
    #     パラメータの player がゲームに参加していない場合は、
    #     例外が発生する
    attr_reader :banker

    # 子の組(Punters)
    attr_reader :punters

    # @overload initialize(players)
    #   @param [Array<#cast>] players ゲーム参加者を配列で設定する
    # @overload initialize(*players)
    #   @param [#cast] *players 可変長引数に個々のプレイヤを設定する
    # @raise [NotPlayerError] プレイヤ以外を参加者に登録すると例外が発生する
    def initialize(*players)
      @players = validate_players(players.flatten)
    end

    # 親を決定する
    #
    # @see #banker
    def banker=(player)
      validate_banker(player)
      @punters = @players - [player]
      @banker = player
    end

    private

    # プレイヤの集合の検証
    #
    # - 全ての要素がプレイヤである事
    #
    # @param players [Array<#cast>] プレイヤの集合
    # @return [Array<#cast>] プレイヤの集合
    # @raise [NotPlayerError]
    def validate_players(players)
      players.each{|player| validate_player(player)}
    end

    # プレイヤの検証
    #
    # - castメソッドを持っている
    #
    # @param player [#cast] プレイヤ
    # @return [#cast] プレイヤ
    # @raise [NotPlayerError]
    def validate_player(player)
      unless player.respond_to? :cast
        raise NotPlayerError,
          "This is not player object. cast method is necessary."
      end
      player
    end

    # 親プレイヤの検証
    #
    # - ゲームに参加している事
    #
    # @param player プレイヤ
    # @return プレイヤ
    # @raise [NotJoinedGameError]
    #   パラメータの player がゲームに参加していない場合は、
    #   例外が発生する
    def validate_banker(player)
      unless players.include? player
        raise NotJoinedGameError,
          "banker has not joined game."
      end
    end
  end
end
