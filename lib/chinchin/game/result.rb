#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require "forwardable"
require "chinchin/constants"

module ChinChin
  # ゲームを制御するクラス
  class Game
    # Game#play の結果を表すクラス
    class Result
      attr_reader :player, :yaku, :point, :dice

      # @param [#cast]   player プレイヤ
      # @param [Symble]  yaku   役
      # @param [Integer] point  点数
      # @param [Array<Array<Integer>>] dice 賽の目
      def initialize(player, yaku = nil, point = nil, dice = nil)
        @player  = player
        @yaku    = yaku
        @point   = point
        @dice    = dice
        @outcome = nil
      end

      # @overload outcome(outcome)
      #   勝敗をセットする
      #   @param  [Symble] outcome 勝敗
      #   @return [Result] 自身を返す
      # @overload outcome(outcome)
      #   勝敗を返す
      #   @return [Symble, nil] 勝敗
      def outcome(outcome  = nil)
        return @outcome if  outcome.nil?
        @outcome = outcome
        self
      end
    end
  end
end
