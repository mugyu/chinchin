# -*- coding: utf-8 -*-
require "chinchin/constants"
require "chinchin/game/result"

module ChinChin
  # ゲームを制御するクラス
  class Game
    include ChinChin::Constants::Outcome

    # @overload initialize(players)
    #   @param [Array<#cast>] players ゲーム参加者を配列で設定する
    # @overload initialize(*players)
    #   @param [#cast] *players 可変長引数に個々のプレイヤを設定する
    #
    # @see ChinChin::Players#initialize
    def initialize(players)
      @players = players
      @punters = []
      @banker = nil
      @cast_times = 3
    end

    # 役作りをする
    #
    # 決められた回数、賽を投じ役作りを行う。
    # - 途中で役が出来た場合はその時点で役が決定し以降は賽を振らない。
    # - 役が出来なかった場合は出目の最高点数を結果として返す。
    #
    # @param [#cast] player プレイヤ
    # @return [Result]
    #   結果: player: プレイヤ, yaku: 役, point: 点数, dice: 投じた賽の目
    def make(player)
      dice = []
      play_result = cast_result = player.cast
      @cast_times.times do |number|
        dice << cast_result.dice

        if cast_result.yaku
          play_result = cast_result
          break
        end

        play_result = cast_result if play_result.point < cast_result.point

        cast_result = player.cast if @cast_times > number
      end

      Result.new(player, play_result.yaku, play_result.point, dice)
    end

    # 勝負を行う
    def play
      # 親が役を作り、続いて子の組がそれぞれ役を作る。
      # そして、それぞれの子と親とがお互いの役および出目を比較し
      # 勝敗を判定する。
      # ただし「親に役ができた。あるいは親の出目が1または6」の場合は
      # 子は役を作らず、その時点で勝敗が決する
      banker_result = make_banker

      { banker:  banker_result,
        punters: play_punters(banker_result) }
    end

    private

    # 親の役作り
    #
    # @return [Result] 親の役および出目
    def make_banker
      make(@players.banker)
    end

    # 子の組の役作り
    #
    # @param [Result] banker_result 親の役および出目
    # @return [Array<Result>] 子の組の役および出目
    def play_punters(banker_result)
      @players.punters.reduce([]) do |match_results, punter|
        if (judged = judge(banker_result))
          match_results << Result.new(punter).outcome(judged)
        else
          punter_result = make(punter)
          match_results <<
            punter_result.outcome(judge(banker_result, punter_result))
        end
      end
    end

    # 勝負の判定を行う
    #
    # - 親の役がヒフミの場合、無条件に子の勝ち
    # - 親の役がシゴロの場合、無条件に子の負け
    # - 親の役がアラシの場合、無条件に子の負け
    # - 親の出目が1の場合、無条件に子の負け
    # - 親の出目が6の場合、無条件に子の負け
    # - 親の出目が2から5の場合
    #   - 子の結果が未定義の場合は nil を返す
    #   - 子の役がヒフミの場合、子の負け
    #   - 子の役がシゴロの場合、子の勝ち
    #   - 子の役がアラシの場合、子の勝ち
    #   - 子の出目が親の出目より大きい場合、子の勝ち
    #   - 子の出目が親の出目より小さい場合、子の負け
    #   - 子の出目と親の出目が同じ場合、引き分け
    #
    # @param banker 親の役と出目
    # @param punter 子の役と出目
    # @return [Symble]
    #   「子が勝った、負けた。あるいは引き分けた」
    #   という結果を示すSymbleを返す
    def judge(banker, punter = nil)
      return WIN  if banker.point < 2
      return LOST if banker.point > 5
      return nil  if punter.nil?
      return WIN  if banker.point < punter.point
      return LOST if banker.point > punter.point
      DRAW
    end
  end
end
