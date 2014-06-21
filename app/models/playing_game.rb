# -*- coding: utf-8 -*-
require "forwardable"
require "chinchin/game"
require "chinchin/result"

module Models
  # アプリケーション用 拡張Gameクラス
  class PlayingGame
    extend Forwardable
    def_delegators :@game, :players, :punters, :banker, :banker=

    # 賭けるポイント
    DEFAULT_POINT = 5.freeze

    def initialize(game,
                   playing_max_limit,
                   tokens_upper_limit, tokens_lower_limit)
      @game = game
      if playing_max_limit.is_a? Hash
        @playing_max_limit = playing_max_limit[:value]
        @starting_player = playing_max_limit[:player]
      else
        @playing_max_limit = playing_max_limit
        @starting_player = nil
      end
      @tokens_upper_limit = tokens_upper_limit
      @tokens_lower_limit = tokens_lower_limit
      counter_reset
    end

    # 役からポイントを返す
    #
    # @param [Symble, nil] yaku 役
    # @return [integer] 役を評価して得たポイント
    def point_by(yaku)
      case yaku
      when ChinChin::Result::ARASHI
        DEFAULT_POINT * 3
      when ChinChin::Result::SHIGORO
        DEFAULT_POINT * 2
      when ChinChin::Result::HIFUMI
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
        when ChinChin::Game::WIN
          banker.decrement_tokens point
          punter_result.player.increment_tokens point
        when ChinChin::Game::LOST
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
      self.banker = punters[0]
      countup if @starting_player == banker
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

    # 何れかのプレイヤーのトークンが上限に達した
    def tokens_is_upper_limit_reahed?
      @game.players.any? { |player| player.tokens > @tokens_upper_limit }
    end

    # 何れかのプレイヤーのトークンが下限に達した
    def tokens_is_lower_limit_reahed?
      @game.players.any? { |player| player.tokens < @tokens_lower_limit }
    end
  end
end
