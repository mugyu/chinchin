# -*- coding: utf-8 -*-
require "chinchin/constants"
require "chinchin/game"
require "chinchin/result"

module Models
  # アプリケーション用 拡張Gameクラス
  class PlayingGame
    include ChinChin::Constants

    # 賭けるポイント
    DEFAULT_POINT = 5.freeze

    def initialize(game, players, playing_max_limit)
      @game = game
      @players = players
      if playing_max_limit.is_a? Hash
        @playing_max_limit = playing_max_limit[:value]
        @starting_player = playing_max_limit[:player]
      else
        @playing_max_limit = playing_max_limit
        @starting_player = nil
      end
      counter_reset
    end

    # 役からポイントを返す
    #
    # @param [Symble, nil] yaku 役
    # @return [integer] 役を評価して得たポイント
    def point_by(yaku)
      case yaku
      when Yaku::ARASHI
        DEFAULT_POINT * 3
      when Yaku::SHIGORO
        DEFAULT_POINT * 2
      when Yaku::HIFUMI
        DEFAULT_POINT * 2
      else
        DEFAULT_POINT
      end
    end

    # 勝負する
    #
    # @return [Hash] 勝負の結果
    #
    #   - キーが :bunker は親の結果
    #   - キーが :punters は子の結果の組
    def play
      results = @game.play

      countup if @starting_player.nil?

      results[:punters].each do |punter_result|
        point = point_by(
          results[:banker].yaku ? results[:banker].yaku : punter_result.yaku)

        case punter_result.outcome
        when Outcome::WIN
          banker.decrement_tokens point
          punter_result.player.increment_tokens point
        when Outcome::LOST
          banker.increment_tokens point
          punter_result.player.decrement_tokens point
        else
          next
        end
      end

      # ヒフミ、出目なし、出目1の場合は親落ち
      rotate_banker if results[:banker].point < 2

      results
    end

    # 親落ち
    #
    # 親をローテーションする
    def rotate_banker
      @players.banker = @players.punters[0]
      countup if @starting_player == @players.banker
    end

    # ゲームの継続回数をカウントアップ
    def countup
      @playing_counter += 1
    end

    # ゲームの継続回数が上限に達したか?
    def counter_limit_reached?
      @playing_counter >= @playing_max_limit
    end

    # ゲームの継続回数を初期値に戻す
    def counter_reset
      @playing_counter = 0
    end
  end
end
