# -*- coding: utf-8 -*-
require 'chinchin/game'

module Models
  class PlayingGame < ChinChin::Game

    # 賭けるポイント
    DEFAULT_POINT = 5.freeze

    def initialize(playing_max_limit, *players)
      super(players)
      @playing_max_limit = playing_max_limit
      self.count_reset
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
      results = super

      countup

      results[:punters].each do |punter_result|
        point = point_by(results[:banker].yaku ? results[:banker].yaku : punter_result.yaku)

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
    end

    def countup
      @playing_count += 1
    end

    def count_limit_reached?
      @playing_count >= @playing_max_limit
    end

    def count_reset
      @playing_count = 0
    end
  end
end
