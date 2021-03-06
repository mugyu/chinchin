# -*- coding: utf-8 -*-
require "chinchin/constants"

module ChinChin
  # 投じられた賽の結果を表すクラス
  class Result
    include ChinChin::Constants::Yaku

    # 賽の目を返す
    #
    # @return [Array<Integer>] 3つの賽の目
    attr_reader :dice

    # @param [Array<Integer>] pips 3つの賽の目
    def initialize(pips)
      @dice = pips
    end

    # 点数を返す
    #
    # @return [Integer] 点数
    def point
      case yaku
      when HIFUMI
        -1
      when SHIGORO
        10
      when ARASHI
        10 + _point
      else
        _point
      end
    end

    # 役を返す
    #
    # @return [Symbol] 役に応じたSymbol
    # @return [nil] 役なしはnil
    #
    # 役の種類
    # - :HIFUMI  — ヒフミ [1, 3, 3]
    # - :SHIGORO — シゴロ [4, 5, 6]
    # - :ARASHI  — アラシ [ゾロ目]
    # - nil      — 役なし
    def yaku
      case @dice.sort
      when [1, 2, 3]
        HIFUMI
      when [4, 5, 6]
        SHIGORO
      when [1, 1, 1], [2, 2, 2], [3, 3, 3],
           [4, 4, 4], [5, 5, 5], [6, 6, 6]
        ARASHI
      else
        NOTHING
      end
    end

    private

    # 出目の点数を返す
    #
    # @return [Integer] 出目の点数
    def _point
      pips = @dice.sort
      case
      when pips[0] == pips[1]
        pips[2]
      when pips[1] == pips[2]
        pips[0]
      else
        0
      end
    end
  end
end
